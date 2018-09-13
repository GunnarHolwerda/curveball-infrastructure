import { DynamoDB } from 'aws-sdk';
import * as signale from 'signale';

export async function dynamo(action: string = 'create') {
    if (action !== 'create') {
        signale.error('Other actions are not supported yet');
        return;
    }
    const tableAction = `${action}Table` || 'createTable';
    const db = new DynamoDB({ endpoint: 'http://localhost:3003', region: 'us-west-2', accessKeyId: 'local', secretAccessKey: 'local' });
    const params: DynamoDB.CreateTableInput[] = [
        {
            TableName: 'User',
            ProvisionedThroughput: {
                ReadCapacityUnits: 5,
                WriteCapacityUnits: 5
            },
            AttributeDefinitions: [
                { AttributeName: 'user_id', AttributeType: 'S' },
                { AttributeName: 'username', AttributeType: 'S' },
                { AttributeName: 'phone', AttributeType: 'S' }
            ],
            KeySchema: [{ AttributeName: 'user_id', KeyType: 'HASH' }],
            GlobalSecondaryIndexes: [
                {
                    IndexName: 'phoneIndex',
                    KeySchema: [
                        { AttributeName: 'phone', KeyType: 'HASH' }
                    ],
                    Projection: { ProjectionType: 'ALL' },
                    ProvisionedThroughput: {
                        ReadCapacityUnits: 1,
                        WriteCapacityUnits: 1
                    },
                },
                {
                    IndexName: 'usernameIndex',
                    KeySchema: [
                        { AttributeName: 'username', KeyType: 'HASH' }
                    ],
                    Projection: { ProjectionType: 'ALL' },
                    ProvisionedThroughput: {
                        ReadCapacityUnits: 1,
                        WriteCapacityUnits: 1
                    },
                }
            ]
        },
        {
            TableName: 'Quiz',
            ProvisionedThroughput: {
                ReadCapacityUnits: 5,
                WriteCapacityUnits: 5
            },
            AttributeDefinitions: [
                { AttributeName: 'quiz_id', AttributeType: 'S' }
            ],
            KeySchema: [{ AttributeName: 'quiz_id', KeyType: 'HASH' }]
        },
        {
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
        }
    ];

    for (const param of params) {
        try {
            const tableData = await db[tableAction](param).promise();
            signale.info(tableData);
        } catch (e) {
            signale.error(e.message);
        }
    }
}