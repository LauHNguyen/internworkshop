---
title : "Giới thiệu"
date: "2025-07-03" 
weight : 1 
chapter : false
pre : " <b> 1. </b> "
---
Trong thời đại phát triển phần mềm hiện đại, việc thiết kế và phát triển API không chỉ còn là một bước phụ mà đã trở thành trọng tâm trong quy trình phát triển ứng dụng. Với phương pháp **API-First Development**, toàn bộ hệ thống được xây dựng xoay quanh các đặc tả API (API specifications), đảm bảo tính nhất quán, khả năng tái sử dụng và tốc độ phát triển vượt trội.

Đề tài này triển khai một **nền tảng API-First hoàn chỉnh trên AWS**, kết hợp các công cụ và dịch vụ hiện đại như:

- **OpenAPI Specification**: Chuẩn hóa thiết kế API ngay từ đầu.
- **Code Generation**: Tự động sinh code server và client từ file OpenAPI.
- **AWS Lambda & API Gateway**: Triển khai API không máy chủ (serverless).
- **DynamoDB**: Lưu trữ dữ liệu theo mô hình NoSQL, hiệu quả và mở rộng tốt.
- **CodePipeline & CodeBuild**: Tự động hóa toàn bộ quy trình CI/CD.
- **Jest & Coverage**: Đảm bảo chất lượng bằng kiểm thử tự động và đo độ bao phủ mã.
- **Redoc**: Tạo tài liệu API đẹp mắt, tự động từ file OpenAPI.

### Mục tiêu

Xây dựng một workflow phát triển API hiện đại với:

- Thiết kế API trước (API-first)
- Sinh mã nguồn tự động
- Tích hợp kiểm thử và tài liệu hoá
- Tự động hoá triển khai trên AWS

### Lý do chọn đề tài

- Giảm thời gian phát triển và bảo trì API đến 70%
- Giải quyết vấn đề inconsistency giữa code và tài liệu
- Tạo ra một nền tảng dễ mở rộng, có thể tái sử dụng trong nhiều dự án