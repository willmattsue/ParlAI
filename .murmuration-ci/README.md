## Introduction
This purpose of this project is to update the continuous integration pipelien for an open source project located at (https://github.com/facebookresearch/ParlAI).
The CI pipeline is updated by integrating Terraform configuration files within CircleCI workflow to build and deploy a static website for hosting in an Amazon S3 bucket. CloudFront was 
configured for routing and CDN capabilities, All terraform files are found in the terraform folder including addtional configurations for DNS vis AWS route53 and for Certificate Manager.  
The build was tested and ran successfully.


## Architecture
As the site, once built, it's static content being successfully hosted on S3, I decided to build upon this by adding routing and CDN capabilities via CloudFront.

Architecture:
 User -> route53 -> cloudfront -> S3 (www redirect) -> (S3 with content)

```mermaid
graph TD;
    User-->DNS;
    DNS--currently using Cloudfront default domain-->CloudFront;
    S3-->CloudFront;
    Repo--build on commit-->CI;
    CI--pipeline builds website, pushes to bucket-->S3;
```

## Initial exploration:
Looked at ECR with Docker. Some issues, disk size.
First, attempts to build website on local machine. Had issues with dependencies, primarily PyTorch during the building of /docs.
Tested build within Circle CI pipeline, built successfully. Noted addiitional torch dependency steps.

Created terraform to create an S3 bucket, enable hosting, add built files, create CloudFront.
(Also created code for route53 and certificates, but went with cloudfront defaults for this demo rather than an at-cost domain)

Tested terraform in its own pipeline. Successfully accessed website through Cloudfront

Attempted to integrate into the existing ParlAI pipeline using dynamic config. Was unsuccessful in linking a secondary .yml file into .circleci/config.yml


## Thoughts, dilemmas, challenges
- Too many heavy dependencies just for building static website content. Look at ways to separate unnecessary dependenies from buld step
- Unit or other tests failing outside of website build
- Long build time overall
- * Due to initial inability to build via make, I looked at non-static solutions in case there were not html files available
Built files for initial tests by running generate.py directly, excluding the /docs build
- Had permission issues adding ACLs and policies to my S3 bucket when using my own module, so switched to hashicorp's S3 module
- I first applied Terraform to build an S3 bucket to use as the backend, then set another S3 bucket as the resource to be created in the pipeline
