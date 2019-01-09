#!/usr/bin/env ts-node
import * as program from 'commander';
import { fs } from 'mz';
import { backup } from './src/commands/backup';
import { buildImages } from './src/commands/build-images';
import { encrypt } from './src/commands/encrypt';
import { up } from './src/commands/up';
import { CurveballControlDir, InfrastructureDir, QuizDir, RealtimeDir } from './src/constants';
import { reload } from './src/commands/reload';
import { stream } from './src/commands/stream';
import { code } from './src/commands/code';
import { logs } from './src/commands/logs';
import { cleanDb } from './src/commands/clean-db';
import { migrate } from './src/commands/migrate';
import { createBaseSchema } from './src/commands/create-base-schema';

const projectDirs = [InfrastructureDir, RealtimeDir, QuizDir, CurveballControlDir];
const dirChecks = projectDirs.map(d => fs.exists(d));

program.command('backup').action(backup).description('Creates a backup of the local database');
program.command('ssl').action(encrypt).description('Starts flow to create self signed certs on your machine (Mac only)');
program.command('create-base-schema')
    .option('--only-create', 'Only include creation commands in sql file')
    .action(createBaseSchema)
    .description('Creates base schema file for the current database');
program.command('clean-db').action(cleanDb).description('Drop tables and recreate db from base schema file');
program.command('migrate').action(migrate).description('Migrates the database to the latest version');
program.command('build-images').alias('bi').action(buildImages).description('Builds docker images for all services');
program.command('up').alias('u').action(up).description('Recreates the local docker environment for curveball');
program.command('reload').alias('r').action(reload).description('Stops and restarts docker compose');
program.command('stream').action(stream).description('Starts a docker container to begin a stream that can be watched');
program.command('code').action(code).description('The token to log in as an internal user');
program.command('logs').action(logs).description('Outputs logs from the local system');

// tslint:disable-next-line
(async () => {
    try {
        await Promise.all(dirChecks);
    } catch (e) {
        throw new Error('Project is not configured correctly. Please put all repos at the same level within the same folder');
    }
    program.parse(process.argv.slice(0));
})();
