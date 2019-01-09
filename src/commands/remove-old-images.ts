import { exec } from 'mz/child_process';
import * as signale from 'signale';

export async function removeOldImages() {
    signale.info('Removing all docker images from system...');
    await exec(`docker-compose down && docker rmi $(docker images -q) --force`);
    signale.info('Docker images removed');
}
