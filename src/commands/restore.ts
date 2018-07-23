import { exec } from 'mz/child_process';
import { fs } from 'mz';
import * as signale from 'signale';
import { DbContainerName, BackUpDir } from '../constants';

export async function restore() {
    signale.pending('Starting restore');
    signale.time('restore');
    const dockerDir = '/var/log/pg_backups';
    const files = fs.readdirSync(BackUpDir);
    files.sort(function (a, b) {
        return fs.statSync(BackUpDir + b).mtime.getTime() - fs.statSync(BackUpDir + a).mtime.getTime();
    });
    const latestBackup = files[0];
    const fileContents = await fs.readFile(latestBackup, 'utf8');
    const contents = fileContents.replace(/(?:\r\n|\r|\n)/g, ' ');
    await fs.writeFile(latestBackup, contents, 'utf8');
    await exec(`docker exec -t ${DbContainerName} psql admin -f ${dockerDir}/${latestBackup} postgres`);
    signale.timeEnd('restore');
    signale.success('Restore completed');
}
