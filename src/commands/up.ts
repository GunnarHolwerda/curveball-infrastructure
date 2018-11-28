import * as signale from 'signale';
import * as sleep from 'system-sleep';
import axios from 'axios';
// import { buildImages } from './build-images';
import { reload } from './reload';
import { exec } from 'mz/child_process';
import { DbContainerName } from '../constants';
import { cleanDb } from './clean-db';
import { migrate } from './migrate';
import { Command } from 'commander';

export async function up(command: Command) {
    // try {
    //     await buildImages();
    // } catch (e) {
    //     return;
    // }
    await reload();
    let successful = false;
    const msToSleep = 2 * 1000;
    let running = false;
    signale.await('Waiting for containers');
    while (!running) {
        try {
            await exec(`docker exec -t ${DbContainerName} pg_isready -U root`);
            running = true;
        } catch (e) {
            sleep(msToSleep);
        }
    }
    if (!running) {
        signale.error('Environment failed to spin up in time');
        process.exit(1);
    }
    signale.await('Detecting curveball database');
    try {
        sleep(msToSleep);
        await exec(`docker exec -t curveball-db psql -U root curveball -c "SELECT * FROM quizrunner.quizzes LIMIT 1"`);
    } catch (e) {
        signale.warn('Could not find the curveball database, creating clean database');
        try {
            await cleanDb();
        } catch (e) {
            process.exit(1);
        }
    }
    let attempts = 0;
    while (!successful && attempts <= 15) {
        try {
            await migrate(command);
            successful = true;
        } catch (e) {
            attempts++;
            sleep(msToSleep);
            continue;
        }
    }
    if (attempts === 15) {
        signale.error('Failed to spin up environment in time');
        return;
    }
    signale.info('Creating dummy user');
    const result = await axios.post('http://localhost:3001/dev/users', { phone: '+10000000000' });
    await axios.post(`http://localhost:3001/dev/users/${result.data.userId}/verify`, { code: '0000000', username: 'DevAdmin' });
    signale.success('Environment is running in background');
}
