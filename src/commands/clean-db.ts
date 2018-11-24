import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { DbContainerName } from '../constants';
export async function cleanDb(): Promise<void> {
    signale.pending('Moving database to clean state');
    const baseSchemaFile = '/var/log/pg_schema/base-schema.sql';
    try {
        await exec(`docker exec -t ${DbContainerName} psql -U root curveball -c "DROP SCHEMA IF EXISTS quizrunner CASCADE;"`);
        await exec(`docker exec -t ${DbContainerName} psql -U root curveball -f ${baseSchemaFile}`);
        signale.success('Cleaned Database');
    } catch (e) {
        signale.error('Error cleaning database');
        console.log(e);
    }
}