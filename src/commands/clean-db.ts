import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { DbContainerName } from '../constants';

export async function cleanDb(): Promise<void> {
    signale.pending('Moving database to clean state');
    const initializeFile = '/var/log/pg_schema/initialize.sql';
    const baseSchemaFile = '/var/log/pg_schema/base_schema.sql';
    const versionFile = '/var/log/pg_schema/version.sql';
    try {
        await exec(`docker exec -t ${DbContainerName} psql -U admin admin -f ${initializeFile}`);
        await exec(`docker exec -t ${DbContainerName} psql -U developer curveball -f ${baseSchemaFile}`);
        await exec(`docker exec -t ${DbContainerName} psql -U developer curveball -f ${versionFile}`);
        signale.success('Cleaned Database');
    } catch (e) {
        signale.error('Error cleaning database');
        console.log(e);
    }
}
