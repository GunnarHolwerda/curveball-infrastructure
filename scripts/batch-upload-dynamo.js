const config = require('aws-sdk').config;
const _ = require('lodash');
const DocumentClient = require('aws-sdk/clients/dynamodb').DocumentClient;

let dbConnectionOptions;
config.accessKeyId = ''; // Key
config.secretAccessKey = ''; //Secret
dbConnectionOptions = { region: 'us-west-2' };

const dynamodb = new DocumentClient(dbConnectionOptions);
const tableName = process.argv[2];
const file = require(process.argv[3]);

const chunks = _.chunk(file, 20);

for (const chunk of chunks) {
    const query = {
        RequestItems: {
            [tableName]: chunk.map(item => ({
                PutRequest: { Item: item }
            }))
        }
    };

    dynamodb.batchWrite(query, (err, data) => {
        if (err) {
            console.log(err);
        }
        console.log(data);
    });
}