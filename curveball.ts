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
import { reload } from './src/commands/reload';
import { stream } from './src/commands/stream';
import { code } from './src/commands/code';

const projectDirs = [InfrastructureDir, RealtimeDir, QuizDir, CurveballControlDir];
const dirChecks = projectDirs.map(d => fs.exists(d));

program.command('create-base-schema').option('--only-create', 'Only include creation commands in sql file').action(createBaseSchema);
program.command('clean-db').action(cleanDb);
program.command('backup').action(backup);
program.command('restore').action(restore);
program.command('ssl').action(encrypt);
program.command('build-images').alias('bi').action(buildImages);
program.command('migrate').action(migrate);
program.command('up').alias('u').action(up);
program.command('reload').alias('r').action(reload);
program.command('stream').action(stream);
program.command('code').action(code);

// tslint:disable-next-line
(async () => {
    try {
        await Promise.all(dirChecks);
    } catch (e) {
        throw new Error('Project is not configured correctly. Please put all repos at the same level within the same folder');
    }
    program.parse(process.argv.slice(0));
})();
