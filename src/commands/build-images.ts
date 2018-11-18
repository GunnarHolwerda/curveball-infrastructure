import { exec } from 'mz/child_process';
import * as signale from 'signale';

export async function buildImages(): Promise<void> {
    signale.time('Building docker images');
    try {
        await exec(`docker rmi -f $(docker images -qa -f 'dangling=true' || true) || true`);
        await exec('docker-compose build');
    } catch (e) {
        signale.error('Something failed, make sure docker is running');
        throw e;
    }
    signale.timeEnd('Building docker images');
}
