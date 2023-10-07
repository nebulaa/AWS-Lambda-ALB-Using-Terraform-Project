 # Deploying Lambda Function Behind AWS Application Load Balancer with Terraform

This repository provides Terraform scripts and a Python Lambda function to deploy a Lambda function behind an AWS Application Load Balancer. The Lambda function sends requests to a Slack channel via a webhook. Follow the steps below to set up this infrastructure.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

- An AWS account with appropriate permissions to create Lambda functions, Application Load Balancers, and associated resources.
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed on your local machine.
- AWS CLI configured with the necessary credentials.

## Setup Instructions

1. Clone the repository to your local machine.

2. Modify the `providers.tf` file to configure your AWS provider.

3. Edit the `vpc.tf` file if needed to customize your AWS Virtual Private Cloud (VPC) settings.

4. Customize the Lambda function in `lambda-demo.py` as needed for your use case. This script is responsible for sending requests to the Slack channel via webhook.

5. Review and customize the `alb.tf` and `lambda.tf` files if necessary. You can adjust resource names, descriptions, and other settings as needed.

6. Run the following commands to initialize Terraform and create the infrastructure:

   ```bash
   terraform init
   terraform apply
   ```

   Confirm the changes when prompted.

## Outputs

The `output.tf` file is configured to output the URL of the Application Load Balancer. This URL is where your Lambda function will be accessible.

## Cleanup

Remember to run `terraform destroy` after you've finished using this infrastructure to avoid incurring unnecessary charges from AWS.
