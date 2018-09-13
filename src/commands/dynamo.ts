import { DynamoDB } from 'aws-sdk';
import * as signale from 'signale';

export async function dynamo() {
    const db = new DynamoDB({ endpoint: 'http://localhost:3003', region: 'us-west-2' });
    db.createTable({
        TableName: 'User',
        ProvisionedThroughput: {
            ReadCapacityUnits: 5,
            WriteCapacityUnits: 5
        },
        AttributeDefinitions: [
            { AttributeName: 'user_id', AttributeType: 'S' }
        ],
        KeySchema: [{ AttributeName: 'user_id', KeyType: 'HASH' }]
    }, (err, data) => {
        if (err) {
            signale.error(err);
            return;
        }
        signale.debug(data);
    });

    db.createTable({
        TableName: 'Quiz',
        ProvisionedThroughput: {
            ReadCapacityUnits: 5,
            WriteCapacityUnits: 5
        },
        AttributeDefinitions: [
            { AttributeName: 'quiz_id', AttributeType: 'S' }
        ],
        KeySchema: [{ AttributeName: 'quiz_id', KeyType: 'HASH' }]
    }, (err, data) => {
        if (err) {
            signale.error(err);
            return;
        }
        signale.debug(data);
    });

    db.createTable({
        TableName: 'Answer',
        ProvisionedThroughput: { ReadCapacityUnits: 5, WriteCapacityUnits: 5 },
        AttributeDefinitions: [
            { AttributeName: 'question_id', AttributeType: 'S' },
            { AttributeName: 'user_id', AttributeType: 'S' },
        ],
        KeySchema: [
            { AttributeName: 'question_id', KeyType: 'HASH' },
            { AttributeName: 'user_id', KeyType: 'RANGE' }
        ]
    }, (err, data) => {
        if (err) {
            signale.error('err');
            return;
        }
        signale.debug(data);
    });
}