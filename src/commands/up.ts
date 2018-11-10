import * as signale from 'signale';
import { buildImages } from './build-images';
import { reload } from './reload';

export async function up() {
    try {
        await buildImages();
    } catch (e) {
        return;
    }
    await reload();
    signale.success('Environment is running in background');
}
