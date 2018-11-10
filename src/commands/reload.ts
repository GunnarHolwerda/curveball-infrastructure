import { exec, spawn } from 'mz/child_process';
import { fs } from 'mz';
import * as signale from 'signale';
import { InfrastructureDir, QuizDir } from '../constants';

export async function reload() {
    signale.info('Bringing down environment');
    await exec('kill $(lsof -t -i:3000) || true');
    const out = fs.openSync('./out.log', 'a');
    const err = fs.openSync('./out.log', 'a');
    spawn('npm', ['run', 'start:local'], {
        cwd: QuizDir,
        stdio: ['ignore', out, err], // piping stdout and stderr to out.log
        detached: true
    }).unref();
    await exec(`cd ${InfrastructureDir} && docker-compose down`);
    signale.info('Bringing environment up');
    await exec(`cd ${InfrastructureDir} && docker-compose up -d`);
    signale.info('Environment is running');
}
