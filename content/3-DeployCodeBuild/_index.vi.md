---
title : "Triển khai trên CodeBuild"
date: "2025-07-03" 
weight : 3 
chapter : false
pre : " <b> 3. </b> "
---

Ở Bước này ta sẽ triển khai mã nguồn của mình lên AWS CodeBuild. CodeBuild là một dịch vụ biên dịch mã nguồn tự động, giúp bạn xây dựng và kiểm thử ứng dụng mà không cần quản lý máy chủ.
Trong quá trình này, bạn sẽ tạo một repository trên GitHub để lưu trữ mã nguồn, sau đó tạo một dự án CodeBuild để biên dịch mã nguồn của bạn. Dự án này sẽ sử dụng tệp cấu hình `buildspec.yml` để xác định các bước cần thực hiện trong quá trình biên dịch.

### Nội dung
   - [Tạo GitHub Repository](3.1-CreateGithubRepo/)
   - [Tạo CodeBuild Project](3.2-CreateCodeBuild/)
