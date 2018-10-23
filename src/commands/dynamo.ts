import { DynamoDB } from 'aws-sdk';
import * as signale from 'signale';

export async function dynamo(action: string = 'create') {
    const tableAction = `${action}Table` || 'createTable';
    const db = new DynamoDB({ endpoint: 'http://localhost:3003', region: 'us-west-2', accessKeyId: 'local', secretAccessKey: 'local' });
    const defaultThroughput = { ReadCapacityUnits: 5, WriteCapacityUnits: 5 };
    const params: DynamoDB.CreateTableInput[] = [
        {
            TableName: 'User',
            ProvisionedThroughput: defaultThroughput,
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
                    ProvisionedThroughput: defaultThroughput,
                },
                {
                    IndexName: 'usernameIndex',
                    KeySchema: [
                        { AttributeName: 'username', KeyType: 'HASH' }
                    ],
                    Projection: { ProjectionType: 'ALL' },
                    ProvisionedThroughput: defaultThroughput,
                }
            ]
        },
        {
            TableName: 'Quiz',
            ProvisionedThroughput: defaultThroughput,
            AttributeDefinitions: [
                { AttributeName: 'quiz_id', AttributeType: 'S' }
            ],
            KeySchema: [{ AttributeName: 'quiz_id', KeyType: 'HASH' }]
        },
        {
            TableName: 'Question',
            ProvisionedThroughput: defaultThroughput,
            AttributeDefinitions: [
                { AttributeName: 'quiz_id', AttributeType: 'S' },
                { AttributeName: 'question_num', AttributeType: 'S' }
            ],
            KeySchema: [
                { AttributeName: 'quiz_id', KeyType: 'HASH' },
                { AttributeName: 'question_num', KeyType: 'RANGE' }
            ]
        },
        {
            TableName: 'Answer',
            ProvisionedThroughput: defaultThroughput,
            AttributeDefinitions: [
                { AttributeName: 'question_id', AttributeType: 'S' },
                { AttributeName: 'user_id', AttributeType: 'S' },
                { AttributeName: 'choice_id', AttributeType: 'S' },
            ],
            KeySchema: [
                { AttributeName: 'question_id', KeyType: 'HASH' },
                { AttributeName: 'choice_id', KeyType: 'RANGE' }
            ],
            LocalSecondaryIndexes: [
                {
                    IndexName: 'UserIndex',
                    KeySchema: [
                        { AttributeName: 'question_id', KeyType: 'HASH' },
                        { AttributeName: 'user_id', KeyType: 'RANGE' }
                    ],
                    Projection: { ProjectionType: 'ALL' }
                },
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