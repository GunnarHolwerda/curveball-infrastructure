import { exec } from 'mz/child_process';
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
    while (!successful) {
        try {
            await migrate();
            successful = true;
        } catch (e) {
            continue;
        }
    }
    signale.success('Environment is running in background');
}
