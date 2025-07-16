---
title : "Create Lambda Function"
date: "2025-07-03" 
weight : 2 
chapter : false
pre : " <b> 2.2 </b> "
---

### 1: Create Lambda Function

In this step, we will create a Lambda function to handle requests from API Gateway. This Lambda function will perform CRUD (Create, Read, Update, Delete) operations on the DynamoDB table we created in the previous step.
For simplicity, we use a single Lambda function to handle all CRUD requests. You can create different Lambda functions for each CRUD operation if you want.

The steps you need to complete for this step are as follows:
1. Go to **Lambda Console**
2. Click **Create function**
3. **Function name**: `UserService`
4. **Runtime**: `Node.js 18.x`
5. Click **Create function**

Go to **Lambda Console**: Access the AWS Management Console and search for Lambda.
![Search](/images/2.prerequisite/SearchLambda.png)

Click **Create function**: On the Lambda page, you will see the "Create function" button in the upper right corner.
![Create Function](/images/2.prerequisite/CreateFunction.png)

Fill in function information: Enter the function name as `UserService`, select Runtime as `Node.js 18.x`. Other parameters can be left as default. Finally, click **Create function** to complete.

{{% notice info %}}
Here we use Node.js as the programming language for Lambda function. You can choose another language if you want, but make sure your source code is compatible with that runtime.
{{% /notice %}}

Since I previously created a lambda function named `UserService`, I will name it `UserService1` to avoid name conflicts. If you haven't created one yet, you can name it `UserService`.

Besides the name and runtime information, you can leave other parameters as default. After clicking **Create function**, Lambda will create the function for you. An IAM role will be automatically created to allow Lambda to access other AWS services like DynamoDB.

Click **Create function**: After filling in all information, click the "Create function" button to complete creating the Lambda function.
![Function Info](/images/2.prerequisite/FunctionInfo.png)

After creating the function, you will see the management page of the Lambda function `UserService`. Here, you can configure other parameters such as access permissions, environment variables, and function source code.
![Function Created](/images/2.prerequisite/FunctionCreated.png)

### 2: Upload Source Code for Lambda Function
Now we will upload source code for the Lambda function `UserService`. This source code will include functions to handle CRUD requests from API Gateway and interact with DynamoDB.

You can upload source code directly to Lambda or use AWS CLI or AWS SDK to upload source code from your computer to Lambda.

For simplicity, we will add source code directly to Lambda.
1. In the Lambda function `UserService` management page, in the "Code" tab, you will see a source code editor.
2. Copy and paste the following source code into the editor:
```javascript
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const {
    DynamoDBDocumentClient,
    ScanCommand,
    GetCommand,
    PutCommand,
    UpdateCommand,
    DeleteCommand
} = require('@aws-sdk/lib-dynamodb');
const { randomUUID } = require('crypto');

const client = new DynamoDBClient({});
const dynamodb = DynamoDBDocumentClient.from(client);

const TABLE_NAME = 'Users';

exports.handler = async (event) => {
    console.log("Full Event:", JSON.stringify(event, null, 2));
    console.log("Event Received:", {
        resource: event.resource,
        path: event.path,
        pathParameters: event.pathParameters,
        httpMethod: event.httpMethod
    });
    const { httpMethod, pathParameters, body, resource } = event;

    try {
        switch (httpMethod) {
            case 'GET':
                if (resource === '/v1/users') {
                    return await getAllUsers();
                } else if (resource === '/v1/users/{userID}' && pathParameters?.userID) {
                    return await getUserById(pathParameters.userID);
                }
                break;

            case 'POST':
                if (resource === '/v1/users') {
                    return await createUser(JSON.parse(body));
                }
                break;

            case 'PUT':
                if (resource === '/v1/users/{userID}' && pathParameters?.userID) {
                    return await updateUser(pathParameters.userID, JSON.parse(body));
                }
                break;

            case 'DELETE':
                if (resource === '/v1/users/{userID}' && pathParameters?.userID) {
                    return await deleteUser(pathParameters.userID);
                }
                break;
        }

        console.log("No matching route found for:", {
            httpMethod,
            resource,
            pathParameters
        });
        return {
            statusCode: 404,
            body: JSON.stringify({ message: 'Not Found' })
        };
    } catch (error) {
        console.error("Lambda Error:", {
            message: error.message,
            stack: error.stack
        });

        return {
            statusCode: 500,
            body: JSON.stringify({ message: error.message || 'Internal server error' })
        };
    }
};

// ========== DynamoDB Functions ==========

async function getAllUsers() {
    const result = await dynamodb.send(new ScanCommand({ TableName: TABLE_NAME }));
    return {
        statusCode: 200,
        body: JSON.stringify(result.Items)
    };
}

async function getUserById(userID) {
    const result = await dynamodb.send(new GetCommand({
        TableName: TABLE_NAME,
        Key: { userID }
    }));

    if (!result.Item) {
        return {
            statusCode: 404,
            body: JSON.stringify({ message: 'User not found' })
        };
    }

    return {
        statusCode: 200,
        body: JSON.stringify(result.Item)
    };
}

async function createUser(userData) {
    const userID = randomUUID();
    const user = { userID, ...userData };

    await dynamodb.send(new PutCommand({
        TableName: TABLE_NAME,
        Item: user
    }));

    return {
        statusCode: 201,
        body: JSON.stringify(user)
    };
}

async function updateUser(userID, userData) {
    const updateExpression = [];
    const expressionAttributeValues = {};
    const expressionAttributeNames = {};

    Object.keys(userData).forEach(key => {
        updateExpression.push(`#${key} = :${key}`);
        expressionAttributeValues[`:${key}`] = userData[key];
        expressionAttributeNames[`#${key}`] = key;
    });

    try {
        const result = await dynamodb.send(new UpdateCommand({
            TableName: TABLE_NAME,
            Key: { userID },
            UpdateExpression: `SET ${updateExpression.join(', ')}`,
            ExpressionAttributeValues: expressionAttributeValues,
            ExpressionAttributeNames: expressionAttributeNames,
            ConditionExpression: 'attribute_exists(userID)',
            ReturnValues: 'ALL_NEW'
        }));

        return {
            statusCode: 200,
            body: JSON.stringify(result.Attributes)
        };
    } catch (error) {
        if (error.name === 'ConditionalCheckFailedException') {
            return {
                statusCode: 404,
                body: JSON.stringify({ message: 'User not found' })
            };
        }
        throw error;
    }
}

async function deleteUser(userID) {
    await dynamodb.send(new DeleteCommand({
        TableName: TABLE_NAME,
        Key: { userID }
    }));

    return {
        statusCode: 204,
        body: ''
    };
}

```

When you just added new source code, Lambda will notify that the source code has been changed and ask you to save it.
{{% notice info %}}
Make sure this source code file is saved with the name `index.js` in the root directory of the Lambda function. Lambda will automatically use this file as the entry point for the function.
{{% /notice %}}
3. Click **Deploy** to save changes.
![Code Editor](/images/2.prerequisite/CodeEditor.png)

In this step, I added /v1/users to the beginning of the paths for easy management and API expansion in the future. You can change this path if you want, but remember to update it in the source code and API Gateway configuration later.

### 3: Grant DynamoDB Access Permission to Lambda Function
For the Lambda function to access the DynamoDB table, we need to grant access permission to this Lambda function. This is done through the IAM Role that the Lambda function uses.
1. In the Lambda function `UserService` management page, go to the "Configuration" tab, go to the "Permissions" tab, scroll down to the "Execution role" section.
2. Click on the IAM role link in the "role name" section to open the IAM role management page.
![Execution Role](/images/2.prerequisite/ExecutionRole.png)

3. In the IAM role page, click **Add permissions** and select **Attach policies**.
![Attach Policy](/images/2.prerequisite/AttachPolicy1.png)
4. Search for and select the `AmazonDynamoDBFullAccess` policy to grant full access to DynamoDB. You can also create a custom policy if you want to limit access permissions.
![Attach Policy](/images/2.prerequisite/AttachPolicy2.png)
5. Click **Attach policy** to apply this policy to the IAM role of the Lambda function.
![Policy Attached](/images/2.prerequisite/PolicyAttached1.png)
6. Return to the Lambda function management page, you will see the IAM role has been updated with the new policy.
![Policy Attached](/images/2.prerequisite/PolicyAttached2.png)