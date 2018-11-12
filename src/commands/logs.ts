import { spawn } from 'mz/child_process';
import { Tail } from 'tail';
import * as signale from 'signale';

export function logs(): void {
    const tail = new Tail('./out.log', { fromBeginning: true });

    tail.on('line', (data) => {
        signale.info('Quiz service:', data);
    });

    tail.on('error', (data) => {
        signale.error(data);
    });

    const dockerLogs = spawn('docker-compose', ['logs', '-f']);
    dockerLogs.stdout.on('data', (data) => {
        console.log(data.toString());
    });
}