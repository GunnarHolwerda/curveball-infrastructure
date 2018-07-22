import { exec } from 'mz/child_process';
import { fs } from 'mz';
import * as signale from 'signale';
import { BackUpDir, DbContainerName } from '../constants';

export async function backup() {
    try {
        fs.mkdirSync('backups');
    } catch (e) { }
    signale.pending('Starting backup');
    signale.time('backup');
    await exec(
        `docker exec -t ${DbContainerName} pg_dumpall -c -U postgres > ${BackUpDir}/dump_\`date+%d-%m-%Y"_"%H_%M_%S\`.sql`
    );
    signale.timeEnd('backup');
    signale.success('Backup completed');
}
