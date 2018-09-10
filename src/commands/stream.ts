import { exec } from 'mz/child_process';
import * as signale from 'signale';
import { sleep } from 'sleep';
import { InfrastructureDir } from '../constants';

const ContainerName = 'curveball_stream';

export async function stream() {
    process.on('SIGINT', function () {
        console.log('Killing stream container');
        exec('docker kill curveball_stream').then(() => {
            signale.success('Stream container killed');
        }).catch(() => {
            signale.error(`Failed to kill stream container. Run: docker kill ${ContainerName}`);
        });
    });
    let containers: Array<string>;
    try {
        containers = (await exec(`docker ps -a | grep ${ContainerName}`)).filter(l => l).map(b => b.toString());
    } catch (e) {
        containers = [];
    }

    if (containers.length === 0) {
        signale.warn('Stream container does not exist. Creating');
        // tslint:disable-next-line
        await exec(`docker run --name ${ContainerName} -v ${InfrastructureDir}/test-files:/srs/videos -d -p 3002:1935 ossrs/srs:2.0-ffmpeg`);
    } else {
        signale.start('Container found. Starting');
        await exec(`docker start ${ContainerName}`);
    }
    signale.pending('Starting stream...');
    signale.success('A stream will start in 5 seconds at rtmp://localhost:3002/app/live. Cancel (CTRL+C) this command to stop it.');
    sleep(5);
    // tslint:disable-next-line
    await exec(`docker exec ${ContainerName} /srs/objs/ffmpeg/bin/ffmpeg -re -f concat -i /srs/videos/looped_file.txt -c copy -f flv rtmp://localhost:1935/app/live`);
}