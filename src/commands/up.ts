import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { migrate } from './migrate';

export async function up() {
    signale.log('Bringing environment up');
    await migrate();
    await exec(`docker-compose down`);
    await exec(`docker-compose up -d`);
    signale.success('Environment is running in background');
}
