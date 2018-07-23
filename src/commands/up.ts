import { exec } from 'mz/child_process';
import { sleep } from 'sleep';
import * as signale from 'signale';
import { migrate } from './migrate';
import { buildImages } from './build-images';
import { InfrastructureDir } from '../constants';

export async function up() {
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
            await migrate();
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
