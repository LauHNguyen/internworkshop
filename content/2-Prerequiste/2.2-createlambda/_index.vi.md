---
title : "Tạo Lambda Function"
date: "2025-07-03" 
weight : 2 
chapter : false
pre : " <b> 2.2 </b> "
---

### 1: Tạo Lambda Function

Trong bước này, chúng ta sẽ tạo một Lambda function để xử lý các yêu cầu từ API Gateway. Lambda function này sẽ thực hiện các thao tác CRUD (Create, Read, Update, Delete) trên bảng DynamoDB mà chúng ta đã tạo ở bước trước.
Vì để đơn giản nên chúng ta dùng 1 Lambda function duy nhất để xử lý tất cả các yêu cầu CRUD. Các bạn có thể tạo nhiều Lambda function khác nhau cho từng thao tác CRUD nếu muốn.

Các bước bạn cần hoàn tất bước này sẽ như sau:
1. Vào **Lambda Console**
2. Nhấn **Create function**
3. **Function name**: `UserService`
4. **Runtime**: `Node.js 18.x`
5. Nhấn **Create function**

Vào **Lambda Console**: Truy cập vào AWS Management Console và tìm kiếm Lambda.
![Search](images/2.prerequisite/SearchLambda.png)

Nhấn **Create function**: Tại trang Lambda, bạn sẽ thấy nút "Create function" ở góc trên bên phải.
![Create Function](images/2.prerequisite/CreateFunction.png)

Điền thông tin function: Nhập tên function là `UserService`, chọn Runtime là `Node.js 18.x`. Các thông số khác có thể để mặc định. Cuối cùng, nhấn **Create function** để hoàn tất.

{{% notice info %}}
Ở đây chúng ta sử dụng Node.js làm ngôn ngữ lập trình cho Lambda function. Bạn có thể chọn ngôn ngữ khác nếu muốn, nhưng cần đảm bảo rằng mã nguồn của bạn tương thích với runtime đó.
{{% /notice %}}

Và vì trước đó mình đã tạo 1 lambda function với tên là `UserService` nên mình sẽ ghi thành `UserService1` để tránh trùng tên. Còn nếu bạn chưa tạo thì có thể để tên là `UserService`.

Ngoài thông tin về tên và runtime, bạn có thể để các thông số khác mặc định. Sau khi nhấn **Create function**, Lambda sẽ tạo function cho bạn. Role IAM sẽ được tạo tự động để cho phép Lambda truy cập vào các dịch vụ AWS khác như DynamoDB.

Nhấn **Create function**: Sau khi điền đầy đủ thông tin, nhấn nút "Create function" để hoàn tất việc tạo Lambda function.
![Function Info](images/2.prerequisite/FunctionInfo.png)

Sau khi tạo function, bạn sẽ thấy trang quản lý của Lambda function `UserService`. Tại đây, bạn có thể cấu hình các thông số khác như quyền truy cập, biến môi trường, và mã nguồn của function.
![Function Created](images/2.prerequisite/FunctionCreated.png)

### 2: Tải mã nguồn cho Lambda Function
Bây giờ chúng ta sẽ tải mã nguồn cho Lambda function `UserService`. Mã nguồn này sẽ bao gồm các hàm để xử lý các yêu cầu CRUD từ API Gateway và tương tác với DynamoDB.

Bạn có thể tải mã nguồn trực tiếp lên Lambda hoặc sử dụng AWS CLI hoặc AWS SDK để tải mã nguồn từ máy tính của bạn lên Lambda.

Để đơn giản, chúng ta sẽ thêm mã nguồn trực tiếp lên Lambda.
1. Trong trang quản lý Lambda function `UserService`, ở tab "Code", bạn sẽ thấy một trình soạn thảo mã nguồn.
2. Sao chép và dán mã nguồn sau vào trình soạn thảo:
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
    console.log("Event Received:", {
        resource: event.resource,
        path: event.path,
        pathParameters: event.pathParameters,
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

khi bạn vừa thêm mã nguồn mới, Lambda sẽ thông báo rằng mã nguồn đã được thay đổi và yêu cầu bạn lưu lại.
{{% notice info %}}
Đảm bảo file mã nguồn này được lưu với tên `index.js` trong thư mục gốc của Lambda function. Lambda sẽ tự động sử dụng file này làm entry point cho function.
{{% /notice %}}
3. Nhấn **Deploy** để lưu thay đổi.
![Code Editor](images/2.prerequisite/CodeEditor.png)

Ở bước này mình thêm /v1/users vào đầu các đường dẫn để dễ dàng quản lý và mở rộng API trong tương lai. Bạn có thể thay đổi đường dẫn này nếu muốn, nhưng hãy nhớ cập nhật lại trong mã nguồn và cấu hình API Gateway sau này.

### 3: Cấp quyền truy cập DynamoDB cho Lambda Function
Để Lambda function có thể truy cập vào bảng DynamoDB, chúng ta cần cấp quyền truy cập cho Lambda function này. Điều này được thực hiện thông qua IAM Role mà Lambda function sử dụng.
1. Trong trang quản lý Lambda function `UserService`, vào tag "Configuration", vào tag "Permissions", cuộn xuống phần "Execution role".
2. Nhấn vào liên kết IAM role ở phần "role name" để mở trang quản lý IAM role.
![Execution Role](images/2.prerequisite/ExecutionRole.png)

3. Trong trang IAM role, nhấn **Add permissions** và chọn **Attach policies**.
![Attach Policy](images/2.prerequisite/AttachPolicy1.png)
4. Tìm kiếm và chọn chính sách `AmazonDynamoDBFullAccess` để cấp quyền truy cập đầy đủ vào DynamoDB. Bạn cũng có thể tạo một chính sách tùy chỉnh nếu muốn giới hạn quyền truy cập.
![Attach Policy](images/2.prerequisite/AttachPolicy2.png)
5. Nhấn **Attach policy** để áp dụng chính sách này cho IAM role của Lambda function.
![Policy Attached](images/2.prerequisite/PolicyAttached1.png)
6. Quay lại trang quản lý Lambda function, bạn sẽ thấy IAM role đã được cập nhật với chính sách mới.
![Policy Attached](images/2.prerequisite/PolicyAttached2.png)
