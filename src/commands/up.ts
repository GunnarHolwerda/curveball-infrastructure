import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { migrate } from './migrate';
import { buildImages } from './build-images';

export async function up() {
    signale.log('Bringing environment up');
    await buildImages();
    await exec(`docker-compose down`);
    await exec(`docker-compose up -d`);
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
