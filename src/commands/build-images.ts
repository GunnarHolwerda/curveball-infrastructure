import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { Command } from 'commander';

export async function buildImages(command: Command): Promise<void> {
    signale.time('Building docker images');
    try {
        if (command.option['force-new']) {
            await exec(`docker rmi -f $(docker images -qa -f 'dangling=true' || true) || true`);
        }
        await exec('docker-compose build');
    } catch (e) {
        signale.error('Something failed, make sure docker is running');
        throw e;
    }
    signale.timeEnd('Building docker images');
}
