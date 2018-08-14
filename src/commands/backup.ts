import { exec } from 'mz/child_process';
import { fs } from 'mz';
import * as signale from 'signale';
import { BackUpDir, DbContainerName } from '../constants';
import * as moment from 'moment';

export async function backup() {
    try {
        fs.mkdirSync('backups');
    } catch (e) { }
    signale.pending('Starting backup');
    signale.time('backup');
    const date = moment().format('MM-DD-YYYY_h-mm-ss');
    await exec(
        `docker exec -t ${DbContainerName} pg_dumpall -c -U admin > ${BackUpDir}/dump_${date}.sql`
    );
    signale.timeEnd('backup');
    signale.success('Backup completed');
}
