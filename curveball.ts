#!/usr/bin/env ts-node
import * as program from 'commander';
import { fs } from 'mz';
import { backup } from './src/commands/backup';
import { buildImages } from './src/commands/build-images';
import { cleanDb } from './src/commands/clean-db';
import { createBaseSchema } from './src/commands/create-base-schema';
import { encrypt } from './src/commands/encrypt';
import { migrate } from './src/commands/migrate';
import { restore } from './src/commands/restore';
import { up } from './src/commands/up';
import { CurveballControlDir, InfrastructureDir, QuizDir, RealtimeDir } from './src/constants';

const projectDirs = [InfrastructureDir, RealtimeDir, QuizDir, CurveballControlDir];
const dirChecks = projectDirs.map(d => fs.exists(d));

program.command('create-base-schema').option('--only-create', 'Only include creation commands in sql file').action(createBaseSchema);
program.command('clean-db').action(cleanDb);
program.command('backup').alias('b').action(backup);
program.command('restore').alias('r').action(restore);
program.command('ssl').action(encrypt);
program.command('build-images').alias('bi').action(buildImages);
program.command('migrate').alias('m').action(migrate);
program.command('up').alias('u').action(up);

// tslint:disable-next-line
(async () => {
    try {
        await Promise.all(dirChecks);
    } catch (e) {
        throw new Error('Project is not configured correctly. Please put all repos at the same level within the same folder');
    }
    program.parse(process.argv.slice(0));
})();
