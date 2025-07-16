---
title : "Create API Gateway"
date: "2025-07-03" 
weight : 3 
chapter : false
pre : " <b> 2.3 </b> "
---
## Create API Gateway

In this step, we will create an API Gateway to connect with Lambda function and DynamoDB. API Gateway will provide endpoints to perform CRUD operations on the DynamoDB table through Lambda function.

The steps you need to complete for this step are as follows: 

1. Go to **API Gateway Console**
2. Click **Create API**
3. Select **REST API** and click **Build**
4. Enter API information:
   - **API name**: `UserServiceAPI`
   - **Description**: `API for User Service`
   - **Endpoint Type**: `Regional`
5. Click **Create API** to complete creating the API Gateway. 

Go to **API Gateway Console**: Access the AWS Management Console and search for API Gateway.
![Search](/images/2.prerequisite/SearchAPIGateway.png)
Click **Create API**: On the API Gateway page, you will see the "Create API" button in the upper right corner.
![Create API](/images/2.prerequisite/CreateAPI.png)
Select **REST API**: Select the "REST API" option and click the "Build" button to start creating the API.
![Select REST API](/images/2.prerequisite/SelectRESTAPI.png)
Select **New API**: Select the "New API" option to create a new API.
Fill in API information: Enter the API name as `UserServiceAPI`, description as `API for User Service`, and select endpoint type as `Regional`. Other parameters can be left as default. Finally, click **Create API** to complete.
![API Info](/images/2.prerequisite/APIInfo.png)

### Create Resource and Method for API

After creating the API, you will see the management page of API Gateway `UserServiceAPI`. Here, you can configure endpoints, HTTP methods, and integration with Lambda function.
Select **Create Resource**: To create a resource for the API, you need to click the "Create Resource" button in the API management page.
![Create Resource](/images/2.prerequisite/CreateResource.png)
Since we will create a resource for users, you can name the resource `users` or `v1/users` to distinguish from other API versions in the future.
Here, I will create a resource as `v1/users` to match the API version.
First, you need to create a main resource for the API. This resource will be the root point for the API endpoints.

Fill in resource information: Enter the resource name as `v1` and click **Create Resource** to create this resource.
![Create Resource](/images/2.prerequisite/CreateResource1.png)
Similar to v1, we will create a child resource called `users` within the `v1` resource.
![Create Resource](/images/2.prerequisite/CreateResource2.png)

Select **Create Method**: After creating the `v1/users` resource, you need to create HTTP methods for this resource. Click the "Create Method" button to start.
![Create Method](/images/2.prerequisite/CreateMethod.png)
Select HTTP method: Choose the HTTP method you want to create for the `v1/users` resource. For example, you can choose `GET`, `POST`, `PUT`, and `DELETE` to perform CRUD operations.
Here I will create `GET`, `POST` methods for the `v1/users` resource.
**Method type**: Select the type of HTTP method you want to create. For example, if you want to create a `GET` method, select `GET` from the list.
**Proxy integration**: Enable this option to use proxy integration.
**Integration type**: Select the integration type for the method. In this case, you will select `Lambda Function` to integrate with Lambda function.
**Lambda Function**: Select the name of the Lambda function you created in the previous step, for example `UserService`. This will link the HTTP method with the Lambda function to handle requests.
You can select `Lambda Function` for all CRUD methods.
You can leave the rest as default.
Click **Create Method** to complete creating the method.
![Select Method](/images/2.prerequisite/SelectMethod.png)

We will create an additional resource `v1/users/{userID}` to get detailed information of a specific user.
Similar to above, you can create the resource `v1/users/{userID}` by selecting `Create Resource`, entering the path as `/v1/users/` and entering the resource name as `{userID}`.

Here are the methods you will create for resources `v1/users` and `v1/users/{userID}`:
- **GET /v1/users**: Get a list of all users.
- **POST /v1/users**: Create a new user.
- **GET /v1/users/{userID}**: Get detailed information of a specific user.
- **PUT /v1/users/{userID}**: Update information of a specific user.
- **DELETE /v1/users/{userID}**: Delete a specific user.

![API Method](/images/2.prerequisite/APIMethod.png)

### Deploy API
After creating resources and methods for the API, you need to deploy the API to be able to use it. Deployment will create an endpoint that you can call from outside.
Select **Deploy API**: Click the "Deploy API" button in the API management page.
![Deploy API](/images/2.prerequisite/DeployAPI.png)
Select **Deployment stage**: Select or create a stage to deploy the API. You can create a new stage named `dev` or use the default stage.
![Select Stage](/images/2.prerequisite/SelectStage.png)
Fill in stage information: Enter the stage name as `dev` and click **Deploy** to complete deploying the API.
![Deploy Stage](/images/2.prerequisite/DeployStage.png)
After deployment, you will receive a URL endpoint for the API. This is the address you can use to call the API methods.
![API Endpoint](/images/2.prerequisite/APIEndpoint.png)

### Test API

Before testing the API, you need to ensure that the Lambda function is configured correctly and has access to DynamoDB. You can check the IAM permissions of the Lambda function to ensure it has read and write permissions to the DynamoDB `Users` table.

Return to the Lambda function "Configuration" tab, select the "Permissions" tab and scroll down to the "resource-based policy" section.
Here you will see the permissions that the Lambda function has been granted corresponding to the methods you created in API Gateway.
![Lambda Permissions](/images/2.prerequisite/LambdaPermission.png)

You can test the API using Postman or curl to send requests to the endpoints you created.
For example, add a new user by sending a POST request with user data in the body.
```js
{
    "userID": "12345",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "address": "123 Main St"
}
```
![Postman Request](/images/2.prerequisite/PostmanRequest1.png)

Or to get a list of all users, you can send a GET request to the URL endpoint `/v1/users`.
![Postman Request](/images/2.prerequisite/PostmanRequest2.png)

So we have completed creating API Gateway and configuring methods to interact with Lambda function and DynamoDB. Now you can use this API to perform CRUD operations on the `Users` table in DynamoDB through the Lambda function `UserService`.

