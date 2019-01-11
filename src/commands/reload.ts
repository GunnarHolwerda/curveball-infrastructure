import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { InfrastructureDir } from '../constants';

export async function reload() {
    signale.info('Bringing down environment');
    await exec(`cd ${InfrastructureDir} && docker-compose down`);
    signale.info('Bringing environment up');
    await exec(`cd ${InfrastructureDir} && docker-compose up -d`);
    signale.info('Environment is running');
}
