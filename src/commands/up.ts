import * as signale from 'signale';
import axios from 'axios';
import { buildImages } from './build-images';
import { reload } from './reload';
import { exec } from 'mz/child_process';
import { DbContainerName } from '../constants';
import { cleanDb } from './clean-db';
import { migrate } from './migrate';
import { Command } from 'commander';
import { removeOldImages } from './remove-old-images';

export async function up(command: Command) {
    try {
        if (command.opts()['new']) {
            await removeOldImages();
        }
        await buildImages();
    } catch (e) {
        return;
    }
    await reload();

    signale.await('Waiting for containers');
    const dbRunning = await waitFor(25, async () => {
        try {
            await exec(`docker exec -t ${DbContainerName} pg_isready -U root`);
            return true;
        } catch (e) {
            return false;
        }
    }, 'Database container');

    if (!dbRunning) {
        process.exit(1);
    }

    signale.await('Detecting curveball database');
    try {
        await sleep(2);
        await exec(`docker exec -t curveball-db psql -U root curveball -c "SELECT * FROM quizrunner.quizzes LIMIT 1"`);
    } catch (e) {
        signale.warn('Could not find the curveball database, creating clean database');
        try {
            await cleanDb();
        } catch (e) {
            process.exit(1);
        }
    }

    const migrationErrors: Array<any> = [];
    const migrationFinished = await waitFor(60, async () => {
        try {
            await migrate(command);
            return true;
        } catch (e) {
            migrationErrors.push(e);
            return false;
        }
    }, 'Database migration');
    if (!migrationFinished) {
        console.log(migrationErrors);
        process.exit(1);
    }
    signale.info('Creating dummy user');
    const realtimeStarted = await waitFor(15, async () => {
        return !!(await axios.get('http://localhost:3001/health-check')).data;
    }, 'Realtime service startup');

    if (!realtimeStarted) {
        process.exit(1);
    }

    const result = await axios.post('http://localhost:3001/dev/users', { phone: '+10000000000' });
    await axios.post(`http://localhost:3001/dev/users/${result.data.userId}/verify`, {
        code: '0000000', username: 'DevAdmin', name: 'Dev Admin'
    });
    signale.success('Environment is running in background');
}

async function waitFor(timeout: number, callback: () => Promise<boolean>, label: string): Promise<boolean> {
    const expirationTime = Date.now() + (timeout * 1000);
    let success = false;
    while (Date.now() < expirationTime) {
        await sleep(1);
        try {
            success = await callback();
            if (success) {
                signale.complete('success');
                break;
            }
        } catch { }
    }
    if (!success) {
        signale.error(`Waiting for ${label} failed to spin up in time`);
        return false;
    }
    return true;
}

export function sleep(seconds: number): Promise<void> {
    return new Promise((resolve) => {
        setTimeout(resolve, seconds * 1000);
    });
}