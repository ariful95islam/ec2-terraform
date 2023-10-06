# Automate Provisioning EC2 with Terraform

This repository contains Terraform configuration files for provisioning infrastructure required for deploying an EC2 instance on AWS. The configurations create a VPC, subnet, Internet Gateway, Route Table, Security Group, EC2 instance, and sets up Docker along with deploying an Nginx container on the EC2 instance.

## Prerequisites

- Terraform installed on your local machine.
- AWS account and AWS CLI configured with the necessary credentials.
- SSH key pair generated for accessing the EC2 instance.

## Variables

You need to provide values for the following variables in a `terraform.tfvars` file before applying this configuration:

```plaintext
vpc_cidr_block      = "<CIDR block for VPC>"
subnet_cidr_block   = "<CIDR block for Subnet>"
avail_zone          = "<AWS Availability Zone>"
env_prefix          = "<Environment Prefix>"
my_ip               = "<Your IP Address>"
instance_type       = "<AWS EC2 Instance Type>"
public_key_location = "<Path to your SSH Public Key>"
```

- `vpc_cidr_block`: The IP range for the VPC in CIDR format, e.g., "10.0.0.0/16".
- `subnet_cidr_block`: The IP range for the subnet in CIDR format, e.g., "10.0.1.0/24".
- `avail_zone`: The AWS availability zone where resources should be created, e.g., "us-west-2a".
- `env_prefix`: A prefix for naming AWS resources, e.g., "prod", "staging".
- `my_ip`: Your IP address to allow SSH access to the EC2 instance, e.g., "203.0.113.0/32".
- `instance_type`: The type of EC2 instance to deploy, e.g., "t2.micro".
- `public_key_location`: The file path of your SSH public key, e.g., "~/.ssh/id_rsa.pub".

## Usage

1. Clone this repository to your local machine.
2. Navigate to the directory containing the Terraform configuration files.
3. Create a file named `terraform.tfvars` and specify the values for the variables mentioned above.
4. Initialize Terraform by running `terraform init`.
5. Apply the configuration by running `terraform apply`.

After running `terraform apply`, Terraform will output the public IP address of the EC2 instance where MyApp is deployed. Navigate to `http://<ec2_public_ip>:8080` in your web browser to access the Nginx welcome page.

## Terraform Commands

- `terraform init`: Initialize Terraform in the current directory.
- `terraform plan`: Show the execution plan for the configuration.
- `terraform apply`: Apply the configuration to create/update resources.
- `terraform destroy`: Destroy the infrastructure created by this configuration.

For more information on Terraform commands, refer to the [Terraform CLI documentation](https://www.terraform.io/docs/cli/index.html).

## Troubleshooting

- Ensure that your AWS CLI is configured with the correct credentials.
- Ensure that the specified SSH key pair exists and the private key is accessible.
- Check the security group and route table configurations to ensure traffic is allowed as expected.