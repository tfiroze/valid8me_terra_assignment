# Terraform AWS Deployment

This repository contains Terraform configurations to deploy infrastructure on AWS.

You can find the IP address to of the ec2 at github actions -> terraform -> terraform apply

## Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd terraform-aws-deployment

### Install Terraform:
Follow the instructions on the [Terraform website](https://www.terraform.io/downloads.html) to download and install Terraform for your operating system.

### Set up AWS credentials:
Ensure you have your AWS access key ID and secret access key configured. You can set these up using the AWS CLI or environment variables.

### Initialize Terraform:

    terraform init


### Usage

#### Review Configuration:
Review the `main.tf` file to understand the infrastructure that will be deployed.

#### Plan Deployment:
Run `terraform plan` to see what changes Terraform will make to your infrastructure before actually making any changes:


    terraform plan 


### Apply Changes:
Apply the changes to your infrastructure:

  
    terraform apply -auto-approve 
  
