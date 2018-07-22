#!/usr/bin/env ts-node
import * as program from 'commander';
import { createBaseSchema } from './src/commands/create-base-schema';
import { backup } from './src/commands/backup';
import { cleanDb } from './src/commands/clean-db';
import { restore } from './src/commands/restore';
import { encrypt } from './src/commands/encrypt';
import { buildImages } from './src/commands/build-images';
import { migrate } from './src/commands/migrate';
import { up } from './src/commands/up';

program.command('create-base-schema').action(createBaseSchema);
program.command('clean-db').action(cleanDb);
program.command('backup').alias('b').action(backup);
program.command('restore').alias('r').action(restore);
program.command('ssl').action(encrypt);
program.command('build-images').alias('bi').action(buildImages);
program.command('migrate').alias('m').action(migrate);
program.command('up').alias('u').action(up);

(async () => {
    program.parse(process.argv.slice(0));
})();
