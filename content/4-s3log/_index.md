---
title : "API-First Development logs"
date: "2025-07-03"
weight : 4
chapter : false
pre : " <b> 4. </b> "
---


With API-First Development, we can view the history of API calls and deployments through **API history**. However, we have not seen the details of the commands used in a deployment.

![S3](/images/4.s3/001-s3.png)

In this section, we will proceed to create an S3 bucket and configure the API-First Development logs feature to see the details of the commands used in the deployment.

![port-fwd](/images/arc-log.png) 

### Content:

   - [Update IAM Role](./4.1-updateiamrole/)
   - [Create **S3 Bucket**](./4.2-creates3bucket/)
   - [Create S3 Gateway endpoint](./4.3-creategwes3)
   - [Configure **API-First Development logs**](./4.4-configsessionlogs/)