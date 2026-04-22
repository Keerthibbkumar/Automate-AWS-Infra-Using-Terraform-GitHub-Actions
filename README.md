# Automate-AWS-Infra-Using-Terraform-GitHub-Actions
AWS Production Infrastructure 

Dedicated Infrastructure Repository
This repository follows the Infrastructure as Code (IaC) best practice of "Separation of Concerns". It is strictly dedicated to managing the AWS platform resources.

**🔄 CI/CD Workflow (Infrastructure Only)**
This repository uses a dedicated GitHub Actions workflow (.github/workflows/terraform.yml) that:

Plans changes on Push Requests (with Security & Linting checks).

�🎯 **Overview**
This demo guide walks you through deploying a production-grade 2-tier AWS infrastructure using Terraform. The infrastructure includes:

- VPC with public subnets across multiple AZs
- Application Load Balancer for traffic distribution
- Security Groups with proper network isolation
- EC2 instances running Nginx web servers

**Prerequisites**

- Terraform
- AWS 
- Github


**Architecture Components Network Layer**

- VPC: 10.0.0.0/16 CIDR block
- Public Subnets: 10.0.1.0/24, 10.0.2.0/24 (AZ-a, AZ-b)
- Internet Gateway: For public subnet internet access

**Load Balancing**

- Application Load Balancer: Distributes traffic across healthy instances
- Target Group: Health checks on port 80
- Listener: HTTP on port 80
