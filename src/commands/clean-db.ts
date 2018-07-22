import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { DbContainerName } from '../constants';

export async function cleanDb(): Promise<void> {
    signale.pending('Moving database to clean state');
    const baseSchemaFile = '/var/log/pg_schema/base_schema.sql';
    const versionFile = '/var/log/pg_schema/version.sql';
    await exec(`docker exec -t ${DbContainerName} psql curveball -f ${baseSchemaFile} postgres`);
    await exec(`docker exec -t ${DbContainerName} psql curveball -f ${versionFile} postgres`);
    signale.success('Cleaned Database');
}
