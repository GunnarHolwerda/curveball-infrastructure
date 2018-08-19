import { Command } from 'commander';
import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { sleep } from 'sleep';
import { DbContainerName } from '../constants';
import { buildImages } from './build-images';
import { migrate } from './migrate';
import { cleanDb } from './clean-db';
import { reload } from './reload';

export async function up(command: Command) {
    try {
        await buildImages();
    } catch (e) {
        return;
    }
    await reload();
    let successful = false;
    const secondsToSleep = 2;
    let running = false;

    signale.await('Waiting for containers');
    while (!running) {
        try {
            await exec(`docker exec -t ${DbContainerName} pg_isready -U admin`);
            running = true;
        } catch (e) {
            sleep(secondsToSleep);
        }
    }
    if (!running) {
        signale.error('Environment failed to spin up in time');
        process.exit(1);
    }

    signale.await('Detecting curveball database');
    try {
        sleep(2);
        const result = await exec(`docker exec -t ${DbContainerName} psql -U admin -lqt | cut -d \\| -f 1 | grep -w curveball`);
        if (result[0].toString().trim() !== 'curveball') {
            throw new Error('Unable to find curveball db');
        }
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
            const adminUserInsertFile = '/var/log/pg_schema/admin_user.sql';
            await exec(`docker exec -t ${DbContainerName} psql -U developer curveball -f ${adminUserInsertFile}`);
            successful = true;
        } catch (e) {
            attempts++;
            sleep(secondsToSleep);
            continue;
        }
    }
    if (attempts === 15) {
        signale.error('Failed to spin up environment in time');
        return;
    }
    signale.success('Environment is running in background');
}
