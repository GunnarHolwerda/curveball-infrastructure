#!/usr/bin/env ts-node
import * as program from 'commander';
import { createBaseSchema } from './src/commands/create-base-schema';
import { backup } from './src/commands/backup';
import { cleanDb } from './src/commands/clean-db';
import { restore } from './src/commands/restore';
import { encrypt } from './src/commands/encrypt';

program.command('create-base-schema').action(createBaseSchema);
program.command('clean-db').action(cleanDb);
program.command('backup').alias('b').action(backup);
program.command('restore').alias('r').action(restore);
program.command('ssl').action(encrypt);

(async () => {
    program.parse(process.argv.slice(0));
})();
