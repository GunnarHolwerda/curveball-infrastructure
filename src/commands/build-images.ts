import { DockerDirs } from '../constants';
import { exec } from 'mz/child_process';
import * as signale from 'signale';

export async function buildImages(): Promise<void> {
    signale.time('Building docker images');
    try {
        const buildImagePromises = DockerDirs.map((dir) => {
            return exec(`cd ${dir} && npm run build:image`);
        });
        await Promise.all(buildImagePromises);
    } catch (e) {
        signale.error('Something failed, make sure docker is running');
    }
    signale.timeEnd('Building docker images');
}
