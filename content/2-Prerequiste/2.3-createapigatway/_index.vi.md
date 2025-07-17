---
title : "Tạo API Gateway"
date: "2025-07-03" 
weight : 3 
chapter : false
pre : " <b> 2.3 </b> "
---
## Tạo API Gateway

Trong bước này, chúng ta sẽ tạo một API Gateway để kết nối với Lambda function và DynamoDB. API Gateway sẽ cung cấp các endpoint để thực hiện các thao tác CRUD trên bảng DynamoDB thông qua Lambda function.

Các bước bạn cần hoàn tất bước này sẽ như sau: 

1. Vào **API Gateway Console**
2. Nhấn **Create API**
3. Chọn **REST API** và nhấn **Build**
4. Nhập thông tin cho API:
   - **API name**: `UserServiceAPI`
   - **Description**: `API for User Service`
   - **Endpoint Type**: `Regional`
5. Nhấn **Create API** để hoàn tất việc tạo API Gateway. 

Vào **API Gateway Console**: Truy cập vào AWS Management Console và tìm kiếm API Gateway.
![Search](images/2.prerequisite/SearchAPIGateway.png)
Nhấn **Create API**: Tại trang API Gateway, bạn sẽ thấy nút "Create API" ở góc trên bên phải.
![Create API](images/2.prerequisite/CreateAPI.png)
Chọn **REST API**: Chọn tùy chọn "REST API" và nhấn nút "Build" để bắt đầu tạo API.
![Select REST API](images/2.prerequisite/SelectRESTAPI.png)
Chọn **New API**: Chọn tùy chọn "New API" để tạo một API mới.
Điền thông tin API: Nhập tên API là `UserServiceAPI`, mô tả là `API for User Service`, và chọn loại endpoint là `Regional`. Các thông số khác có thể để mặc định. Cuối cùng, nhấn **Create API** để hoàn tất.
![API Info](images/2.prerequisite/APIInfo.png)

### Tạo Resource và Method cho API

Sau khi tạo API, bạn sẽ thấy trang quản lý của API Gateway `UserServiceAPI`. Tại đây, bạn có thể cấu hình các endpoint, phương thức HTTP, và tích hợp với Lambda function.
Chọn **Create Resource**: Để tạo một resource cho API, bạn cần nhấn nút "Create Resource" trong trang quản lý API.
![Create Resource](images/2.prerequisite/CreateResource.png)
Vì chúng ta sẽ tạo một resource cho người dùng, nên bạn có thể đặt tên resource là `users` hoặc `v1/users` để phân biệt với các phiên bản API khác trong tương lai.
Ở đây, mình sẽ tạo resource là `v1/users` để phù hợp với phiên bản API.
Đầu tiên, bạn cần tạo một resource chính cho API. Resource này sẽ là điểm gốc cho các endpoint của API.

Điền thông tin resource: Nhập tên resource là `v1` và nhấn **Create Resource** để tạo resource này.
![Create Resource](images/2.prerequisite/CreateResource1.png)
Tương tự như v1 ta sẽ tạo một resource con là `users` trong resource `v1`.
![Create Resource](images/2.prerequisite/CreateResource2.png)

Chọn **Create Method**: Sau khi tạo resource `v1/users`, bạn cần tạo các phương thức HTTP cho resource này. Nhấn nút "Create Method" để bắt đầu.
![Create Method](images/2.prerequisite/CreateMethod.png)
Chọn phương thức HTTP: Chọn phương thức HTTP mà bạn muốn tạo cho resource `v1/users`. Ví dụ, bạn có thể chọn `GET`, `POST`, `PUT`, và `DELETE` để thực hiện các thao tác CRUD.
Ở đây mình sẽ tạo các phương thức `GET`, `POST` cho resource `v1/users`.
**Method type**: Chọn loại phương thức HTTP mà bạn muốn tạo. Ví dụ, nếu bạn muốn tạo phương thức `GET`, hãy chọn `GET` từ danh sách.
**Proxy integration**: Bật tùy chọn này để sử dụng tích hợp proxy.
**Integration type**: Chọn loại tích hợp cho phương thức. Đối với trường hợp này, bạn sẽ chọn `Lambda Function` để tích hợp với Lambda function.
**Lambda Function**: Chọn tên Lambda function mà bạn đã tạo ở bước trước, ví dụ `UserService`. Điều này sẽ liên kết phương thức HTTP với Lambda function để xử lý các yêu cầu.
Các bạn có thể chọn `Lambda Function` cho tất cả các phương thức CRUD.
Các phần còn lại bạn có thể để mặc định.
Nhấn **Create Method** để hoàn tất việc tạo phương thức.
![Select Method](images/2.prerequisite/SelectMethod.png)

Ta sẽ tạo thêm resource `v1/users/{userID}` để lấy thông tin chi tiết của một người dùng cụ thể.
Tương tự như trên, bạn có thể tạo resource `v1/users/{userID}` bằng cách chọn `Create Resource`, nhập path là `/v1/users/` và nhập tên resource là `{userID}`.

Đây là các phương thức mà bạn sẽ tạo cho resource `v1/users` và `v1/users/{userID}`:
- **GET /v1/users**: Lấy danh sách tất cả người dùng.
- **POST /v1/users**: Tạo một người dùng mới.
- **GET /v1/users/{userID}**: Lấy thông tin chi tiết của một người dùng cụ thể.
- **PUT /v1/users/{userID}**: Cập nhật thông tin của một người dùng cụ thể.
- **DELETE /v1/users/{userID}**: Xóa một người dùng cụ thể.

![API Method](images/2.prerequisite/APIMethod.png)

### Deploy API
Sau khi đã tạo các resource và phương thức cho API, bạn cần deploy API để có thể sử dụng được. Việc deploy sẽ tạo ra một endpoint mà bạn có thể gọi từ bên ngoài.
Chọn **Deploy API**: Nhấn nút "Deploy API" trong trang quản lý API.
![Deploy API](images/2.prerequisite/DeployAPI.png)
Chọn **Deployment stage**: Chọn hoặc tạo một stage để deploy API. Bạn có thể tạo một stage mới với tên là `dev` hoặc sử dụng stage mặc định.
![Select Stage](images/2.prerequisite/SelectStage.png)
Điền thông tin stage: Nhập tên stage là `dev` và nhấn **Deploy** để hoàn tất việc deploy API.
![Deploy Stage](images/2.prerequisite/DeployStage.png)
Sau khi deploy, bạn sẽ nhận được một URL endpoint cho API. Đây là địa chỉ mà bạn có thể sử dụng để gọi các phương thức của API.
![API Endpoint](images/2.prerequisite/APIEndpoint.png)

### Kiểm tra API

Trước khi kiểm tra API, bạn cần đảm bảo rằng Lambda function đã được cấu hình đúng và có quyền truy cập vào DynamoDB. Bạn có thể kiểm tra quyền IAM của Lambda function để đảm bảo nó có quyền đọc và ghi vào bảng DynamoDB `Users`.

Quay lại Lambda function tab "Configuration", chọn tab "Permissions" và cuộn xuống phần "resource-based policy".
Ở đây bạn sẽ thấy các quyền mà Lambda function đã được cấp tương ứng với các methods mà bạn đã tạo trong API Gateway.
![Lambda Permissions](images/2.prerequisite/LambdaPermission.png)

Bạn có thể kiểm tra API bằng cách sử dụng Postman hoặc curl để gửi các yêu cầu đến các endpoint mà bạn đã tạo.
Ví dụ, thêm một người dùng mới bằng cách gửi một yêu cầu POST với dữ liệu người dùng trong body.
```js
{
    "userID": "12345",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "address": "123 Main St"
}
```
![Postman Request](images/2.prerequisite/PostmanRequest1.png)

Hoặc để lấy danh sách tất cả người dùng, bạn có thể gửi một yêu cầu GET đến URL endpoint `/v1/users`.
![Postman Request](images/2.prerequisite/PostmanRequest2.png)

Vậy chúng ta đã hoàn thành việc tạo API Gateway và cấu hình các phương thức để tương tác với Lambda function và DynamoDB. Bây giờ bạn có thể sử dụng API này để thực hiện các thao tác CRUD trên bảng `Users` trong DynamoDB thông qua Lambda function `UserService`.


