import { exec } from 'mz/child_process';
import { fs } from 'mz';
import * as signale from 'signale';
import { keypress } from '../utils';
import { QuizDir } from '../constants';


export async function encrypt(): Promise<void> {
    signale.info('Checking SSL cert for local development');
    try {
        fs.mkdirSync('certs');
    } catch (e) { }

    if (fs.existsSync(`./certs/server.crt`) && fs.existsSync(`certs/server.key`)) {
        signale.success(`Certs already created.`);
        return;
    }
    signale.warn('No SSL cert for local development exists');
    signale.info('Generating SSL certs for local development');

    signale.info('Creating private key...');
    await exec(`openssl genrsa -out ./certs/rootCA.key 2048`);
    signale.info('Generating signing cert');
    await exec(
        `openssl req -x509 -new -nodes -key ./certs/rootCA.key` +
        ` -sha256 -days 1024 -out ./certs/rootCA.pem -subj '/CN=Local/O=My Company Name LTD./C=US'`
    );
    fs.mkdirSync(`${QuizDir}/tests/api/ssl-ca`);
    fs.copyFileSync('./certs/rootCA.pem', `${QuizDir}/tests/api/ssl-ca/rootCA.pem`);

    signale.error('Follow the instructions here at "Step 2: Trust the root SSL certificate": https://goo.gl/4vUZJC');
    signale.await('Hit enter when you have trusted the certs generated in ./certs');
    await keypress();

    signale.info('Generating private key for server');
    await exec(
        `openssl req -new -sha256 -nodes -out ./certs/server.csr` +
        ` -newkey rsa:2048 -keyout ./certs/key.pem -config ./certs/server.csr.cnf`
    );
    signale.info(`Generating cert for server`);
    await exec(
        `openssl x509 -req -in ./certs/server.csr -CA ./certs/rootCA.pem` +
        ` -CAkey ./certs/rootCA.key -CAcreateserial -out ./certs/cert.pem -days 500 -sha256 -extfile ./certs/v3.ext`
    );
    signale.success(`SSL cert created successfully`);
    process.exit(0);
}
