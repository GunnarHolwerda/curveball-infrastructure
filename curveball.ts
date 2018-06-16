#!/usr/bin/env ts-node
import * as program from 'commander';
import * as signale from 'signale';
import * as fs from 'fs';
import { exec } from 'child_process';

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

(async () => {
    program.parse(process.argv.slice(0));
})();
