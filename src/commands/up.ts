import { Command } from 'commander';
import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { sleep } from 'sleep';
import { DbContainerName, InfrastructureDir } from '../constants';
import { buildImages } from './build-images';
import { migrate } from './migrate';

export async function up(command: Command) {
    signale.log('Bringing environment up');
    try {
        await buildImages();
    } catch (e) {
        return;
    }
    await exec(`cd ${InfrastructureDir} && docker-compose down`);
    await exec(`cd ${InfrastructureDir} && docker-compose up -d`);
    let successful = false;

    const secondsToSleep = 2;
    let attempts = 0;
    while (!successful && attempts <= 15) {
        try {
            await migrate(command);
            const adminUserInsertFile = '/var/log/pg_schema/admin_user.sql';
            await exec(`docker exec -t ${DbContainerName} psql curveball -f ${adminUserInsertFile} postgres`);
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
