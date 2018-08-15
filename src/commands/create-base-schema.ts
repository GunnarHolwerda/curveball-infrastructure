import { Command } from 'commander';
import { fs } from 'mz';
import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { DbContainerName } from '../constants';

const BaseSchemaFile = 'schema/base_schema.sql';
const VersionFile = 'schema/version.sql';

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
                `${BaseDockerDbCommand} pg_dump -U admin ${createString} --schema-only ` +
                `-N "public" -N "pg_catalog" curveball > ${BaseSchemaFile.replace('.sql', `${createString}.sql`)}`
            ),
            exec(`${BaseDockerDbCommand} pg_dump -U admin --table=quizrunner.migrations --data-only curveball > ${VersionFile}`)
        ]);
        signale.success('Complete.');
    } catch (e) {
        signale.error(e);
    }
}
