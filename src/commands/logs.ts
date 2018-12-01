import { spawn } from 'mz/child_process';

export function logs(): void {
    const dockerLogs = spawn('docker-compose', ['logs', '-f']);
    dockerLogs.stdout.on('data', (data) => {
        console.log(data.toString());
    });
}