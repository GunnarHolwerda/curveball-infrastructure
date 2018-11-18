import { Command } from 'commander';
import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { InfrastructureDir } from '../constants';
import { createBaseSchema } from './create-base-schema';
export async function migrate(command: Command) {
    signale.info('Migrating database to latest version');
    const result = (await exec(`cd ${InfrastructureDir} && npm run migrate up`)).toString();
    if (!result.includes('No migrations to run')) {
        await createBaseSchema(command);
    }
    signale.success('Done updating database');
}