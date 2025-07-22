---
title : "Deploy on CodeBuild"
date: "2025-07-03" 
weight : 3 
chapter : false
pre : " <b> 3. </b> "
---

In this step, we will deploy our source code to AWS CodeBuild. CodeBuild is an automated source code compilation service that helps you build and test applications without having to manage servers.
During this process, you will create a repository on GitHub to store your source code, then create a CodeBuild project to compile your source code. This project will use the `buildspec.yml` configuration file to define the steps to be performed during the compilation process.

### Content
   - [Create GitHub Repository](3.1-CreateGithubRepo/)
   - [Create CodeBuild Project](3.2-CreateCodeBuild/)