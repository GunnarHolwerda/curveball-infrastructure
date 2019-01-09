import { Command } from 'commander';
import { fs } from 'mz';
import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { DbContainerName } from '../constants';
const BaseSchemaFile = 'db-container/config/new_base_schema.sql';
const BaseDockerDbCommand = `docker exec -t ${DbContainerName}`;
export async function createBaseSchema(command: Command) {
    try {
        fs.mkdirSync('schema');
    } catch (e) { }
    const createString = command.opts()['onlyCreate'] ? '--create' : '';
    signale.start('Creating base schema files');
    try {
        await Promise.all([
            exec(
                `${BaseDockerDbCommand} pg_dump -U root ${createString} --schema-only ` +
                `-N "public" -N "pg_catalog" curveball > ${BaseSchemaFile.replace('.sql', `${createString}.sql`)}`
            )
        ]);
        signale.success('Complete.');
    } catch (e) {
        signale.error('Error when creating new base schema file');
        signale.error(e);
    }
}