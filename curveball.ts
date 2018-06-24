#!/usr/bin/env ts-node
import { exec } from 'child_process';
import * as program from 'commander';
import * as fs from 'fs';
import * as signale from 'signale';

program.command('backup').alias('b').action(async () => {
    try {
        fs.mkdirSync('backups');
    } catch (e) { }
    signale.pending('Starting backup');
    signale.time('backup');
    await exec('docker exec -t curveball_curveball-db_1 pg_dumpall -c -U postgres > backups/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql');
    signale.timeEnd('backup');
    signale.success('Backup completed');

});

program.command('restore').alias('r').action(async () => {
    signale.pending('Starting restore');
    signale.time('restore');
    const dir = './backups';
    const files = fs.readdirSync(dir);
    files.sort(function (a, b) {
        return fs.statSync(dir + a).mtime.getTime() - fs.statSync(dir + b).mtime.getTime();
    });
    const latestBackup = files[0];
    console.log(latestBackup);
    await exec(`docker exec -t curveball_curveball-db_1 psql -f ${dir}/${latestBackup} postgres`);
    signale.timeEnd('restore');
    signale.success('Restore completed');
});

(async () => {
    program.parse(process.argv.slice(0));
})();
