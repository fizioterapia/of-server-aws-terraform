# Open Fortress Server on AWS using Terraform
## Overview
This repository contains Terraform code for deploying Open Fortress game server using only one command.  
*This code may be badly written because I was just experimenting and learning Terraform and I don't know best practices yet.*

## Features
- fully configure AWS Free Tier instance with VPC, SG and EIP
- create a http redirect to the github profile of the person hosting the server
- run a server (currently using screen, probably I will move it into a systemd service)

## Prerequisites
- Terraform >= v1.7.5
- AWS CLI >= 2.15.35 (logged in as a default user)
- GitHub SSH key added to the account for accessing admin account on EC2 instance

## Getting started
1. Clone this repository.
```bash
git clone https://github.com/fizioterapia/of-server-aws-terraform
```
2. Navigate to the project directory.
```bash
cd of-server-aws-terraform
```
3. Initialize Terraform.
```
terraform init
```
4. Customize the `terraform.tfvars` file with your configuration.
```
github_username = "fizioterapia"
aws_region = "eu-central-1"
...
rest of the variables is available inside `variables.tf` file
```
5. Review the Terraform plan.
```
terraform plan
```
6. Apply the Terraform configuration.
```
terraform apply
```

## Credits
The setup script is based on the scripts from [NotQuiteApex's Open Fortress Docker Repository](https://github.com/NotQuiteApex/Docker-OpenFortressServer).