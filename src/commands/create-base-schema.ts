import { exec } from 'mz/child_process';
import { fs } from 'mz';
import * as signale from 'signale';
import { DbContainerName } from '../constants';

const BaseSchemaFile = 'schema/base_schema.sql';
const VersionFile = 'schema/version.sql';

const BaseDockerDbCommand = `docker exec -t ${DbContainerName}`;

export async function createBaseSchema() {
    try {
        fs.mkdirSync('schema');
    } catch (e) { }

    signale.start('Creating base schema files');
    try {
        await Promise.all([
            exec(`${BaseDockerDbCommand} pg_dump --clean --schema-only -U admin curveball > ${BaseSchemaFile}`),
            exec(`${BaseDockerDbCommand} pg_dump -U admin --table=quizrunner.migrations --data-only curveball > ${VersionFile}`)
        ]);
        signale.success('Complete.');
    } catch (e) {
        signale.error(e);
    }
}
