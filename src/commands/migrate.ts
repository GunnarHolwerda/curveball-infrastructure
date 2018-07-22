import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { createBaseSchema } from './create-base-schema';

export async function migrate() {
    signale.info('Migrating database to latest version');
    const result = (await exec(`npm run migrate up`)).toString();
    if (!result.includes('No migrations to run')) {
        await createBaseSchema();
    }
    signale.success('Done updating database');
}
