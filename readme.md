# Secure Multi-AZ AWS Network and Application Foundation

This repository is a Terraform starting point for a security-focused AWS deployment. It demonstrates how to combine a VPC, public and private subnets, a pfSense network virtual appliance (NVA), private EC2 application instances, and an internet-facing Application Load Balancer (ALB).

The project is intended as a portfolio and learning reference for infrastructure-as-code, network segmentation, least-privilege security groups, and repeatable AWS deployments. It is not a production-ready blueprint without additional hardening and validation.

## Architecture

The Terraform configuration in `us-east-1` creates:

- One VPC with a `/16` CIDR block.
- Three public subnets:
  - pfSense WAN subnet in `us-east-1a`
  - ALB subnet A in `us-east-1a`
  - ALB subnet B in `us-east-1b`
- Three private subnets:
  - pfSense LAN subnet in `us-east-1a`
  - Application subnet A in `us-east-1a`
  - Application subnet B in `us-east-1b`
- One Internet Gateway and separate public/private route tables.
- One pfSense Plus EC2 NVA with:
  - A public WAN ENI
  - A private LAN ENI
  - Source/destination checks disabled for routing
  - An Elastic IP for administration
- Two private `t3.micro` application EC2 instances.
- One internet-facing Application Load Balancer spanning two Availability Zones.
- An ALB target group and HTTP listener forwarding to both application instances.
- Security groups restricting administrative access to the configured administrator CIDR.
- An encrypted S3 backend with Terraform state locking enabled through `use_lockfile`.

The two Availability Zones provide a useful foundation for multi-AZ application placement. The pfSense NVA is currently single-AZ, so it remains a potential availability bottleneck. A production design should use a highly available network inspection pattern or deploy redundant appliances with a tested failover design.

## Repository layout

```text
.
├── main.tf                    # VPC consumers, application instances, ALB, target attachments
├── firewall.tf                # pfSense AMI, ENIs, EIP, and private routing
├── security-groups.tf         # pfSense WAN and LAN security groups
├── provider.tf                # AWS provider region
├── backend.tf                 # S3 remote state backend
├── variables.tf               # Input variables and defaults
├── terraform.tfvars           # Local/test values; review before use
├── terraform-prod.tfvars      # Production-oriented example values
├── terraform-test.tfvars      # Test-oriented example values
├── steps.txt                  # Original pfSense bootstrap notes
└── modules/
    ├── ALB/
    ├── ec2/
    ├── s3/
    ├── security-groups/
    └── vpc/
```

The `modules/s3` module defines an application bucket but is not currently called by the root module. The S3 bucket in `backend.tf` is the Terraform state bucket and must exist before remote backend initialization.

## Prerequisites

Install or have access to:

- Terraform 1.5 or later, compatible with the AWS provider lock file.
- An AWS account with permission to create the listed VPC, EC2, ELB, IAM-independent networking, EIP, ENI, and S3 resources.
- AWS credentials configured through the AWS CLI profile, environment variables, or another supported credential provider.
- Access to the Netgate pfSense Plus AWS Marketplace AMI.
- An EC2 key pair matching `my_key_name`.
- A globally unique S3 bucket for the Terraform backend.

Do not commit access keys, private keys, passwords, pfSense backups, or other secrets to this repository. The supplied `terraform.tfvars` files contain environment-specific values and should be reviewed before sharing or applying.

## Configure the backend

The backend is configured in [backend.tf](./backend.tf):

```hcl
terraform {
  backend "s3" {
    bucket       = "ztr-bucket-east-us-1-terraform"
    key          = "state/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
```

Create the bucket first, or change the backend configuration to a bucket that already exists in your account. The backend bucket should have public access blocked, encryption enabled, versioning enabled, and a restrictive bucket policy. Backend configuration is initialized before Terraform can manage the rest of the project.

## Deploy

### 1. Select the working directory

```powershell
cd C:\path\to\terraform-beg
```

### 2. Authenticate to AWS

For example, with a named AWS CLI profile:

```powershell
$env:AWS_PROFILE = "my-profile"
aws sts get-caller-identity
```

Confirm that the returned account and identity are the ones intended for this deployment.

### 3. Review variables

Copy or edit a variable file rather than relying on defaults:

```powershell
terraform init
terraform validate
terraform plan -var-file="terraform-test.tfvars"
```

At minimum, review:

- `my_ip_address`: the administrator CIDR allowed to reach management ports.
- `my_key_name`: the existing EC2 key pair.
- `my_ami`: the application AMI available in `us-east-1`.
- `my_instance_type` and `nva_instance_type`.
- All subnet CIDRs and names.
- The backend bucket and state key.

Never use `0.0.0.0/0` for SSH or pfSense administration unless there is a deliberate, documented exception with compensating controls.

### 4. Deploy the network and pfSense NVA

The root configuration currently includes the application and ALB modules. To follow the staged bootstrap process from [steps.txt](./steps.txt), deploy the VPC and pfSense NVA first if you prefer to configure the firewall before starting the private application instances:

```powershell
terraform plan -var-file="terraform-test.tfvars"
terraform apply -var-file="terraform-test.tfvars"
```

The exact resource graph may cause Terraform to create dependent resources in the same apply. Always inspect the plan and use `-target` only for an intentional, temporary bootstrap operation; avoid making targeted applies part of normal lifecycle management.

### 5. Bootstrap pfSense

The Netgate pfSense Plus Marketplace AMI does not provide the same day-one `cloud-init` configuration workflow as a standard Linux AMI. Follow this sequence:

1. Wait for the pfSense EC2 instance and its WAN Elastic IP to become available.
2. Connect through the EC2 serial console and reset the pfSense administrator password.
3. Open `https://<pfSense-EIP>` from the administrator IP configured in `my_ip_address`.
4. In pfSense, go to **Diagnostics > Backup & Restore > Restore Backup**.
5. Restore the intended configuration from `config-pfSense.home.xml`.
6. Verify WAN, LAN, routing, firewall rules, and private-subnet connectivity before exposing the ALB.

Treat the pfSense backup as sensitive. Do not commit it to a public repository or share it without removing secrets and environment-specific values.

### 6. Verify the application and ALB

After pfSense routing and policy are working, apply again if required:

```powershell
terraform apply -var-file="terraform-test.tfvars"
terraform output
```

Then verify:

- Both application instances are running in private subnets.
- The instances do not have public IP addresses.
- The ALB target group reports both targets as healthy.
- The ALB is reachable only from the intended administrator CIDR, as currently configured.
- The application instances can reach only the destinations required by their bootstrap and runtime behavior.
- Private-subnet traffic follows the intended pfSense route.

The root outputs are currently commented out. If you need the ALB DNS name for testing, uncomment or add a reviewed output rather than exposing sensitive values.

## Destroy test resources

For a non-production test environment:

```powershell
terraform plan -destroy -var-file="terraform-test.tfvars"
terraform destroy -var-file="terraform-test.tfvars"
```

Check the AWS console and billing dashboard afterward for unattached Elastic IPs, ENIs, EBS volumes, snapshots, load balancers, and backend resources that should remain.

## Security and best-practice notes

This project demonstrates several good practices:

- Private placement for application EC2 instances.
- Separate public and private route tables.
- Separate security groups for the ALB, applications, and pfSense interfaces.
- ALB-to-application health-check access through a security-group reference.
- Restricted administrative ingress using a configurable `/32` or trusted CIDR.
- Disabled source/destination checks only on the NVA ENIs where routing requires it.
- Encrypted remote Terraform state with locking enabled.
- Automatic discovery of the latest matching pfSense Plus AMI from the Netgate owner account.

Before calling this production-ready, consider:

- Add an explicit IAM strategy with least-privilege roles and instance profiles.
- Add S3 versioning, access logging, and a recovery policy for the backend bucket.
- Store secrets in AWS Secrets Manager or SSM Parameter Store rather than files.
- Add ALB HTTPS with an ACM certificate and redirect HTTP to HTTPS.
- Add WAF, Shield/WAF logging, and centralized audit logging where appropriate.
- Use VPC Flow Logs, CloudTrail, CloudWatch alarms, and alert routing.
- Replace broad LAN/NVA egress rules with narrowly scoped rules.
- Avoid SSH by using Systems Manager Session Manager where practical.
- Make subnet availability-zone selection configurable instead of hard-coding `us-east-1a` and `us-east-1b`.
- Design and test redundant pfSense/NVA failover; the current single NVA is not highly available.
- Pin and review AMI versions instead of automatically selecting the newest image for production.
- Add automated Terraform formatting, validation, security scanning, and CI plan checks.
- Add deletion protection and backup/restore procedures for production workloads.

## Cost estimate

This is an approximate **us-east-1** estimate for resources running continuously for about 730 hours per month. Actual pricing depends on AWS account terms, traffic, storage size, data transfer, CPU-credit usage, Marketplace pricing, and taxes.

| Component | Approximate monthly cost |
|---|---:|
| Two `t3.micro` application EC2 instances | $15.18 |
| One `t3.micro` pfSense EC2 instance | $7.59 |
| Approximately three small EBS root volumes | $1.92 |
| Application Load Balancer base charge | $16.43 |
| ALB LCU usage for low traffic | $0-$5.84 |
| One pfSense Elastic IP | $3.65 |
| Public IPv4 addresses used by the ALB, approximately two | $7.30 |
| S3 state storage and requests | Less than $1 |
| **Infrastructure subtotal** | **Approximately $52-$58/month** |

The pfSense Plus Marketplace listing may add a license charge. The project comments reference approximately `$0.12/hour`, which would be about `$87.60/month` at 730 hours:

```text
$0.12/hour × 730 hours/month ≈ $87.60/month
```

Including that illustrative Marketplace charge, the total estimate is approximately **$140-$146/month**. A practical planning budget is **$160-$180/month** to allow for moderate traffic and usage variation.

The estimate excludes:

- Internet data transfer.
- ALB data processing and higher LCU consumption.
- T3 CPU-credit charges from sustained burst usage.
- Additional EBS, snapshots, logs, backups, or monitoring.
- AWS Marketplace terms that differ from the illustrative pfSense price.
- Taxes and account-level services.

Use the AWS Pricing Calculator before deployment and the AWS Billing console after deployment for an account-specific estimate.

## License and contribution

Add a repository license before accepting contributions or redistributing this project. For changes, run `terraform fmt -recursive`, `terraform validate`, and a reviewed `terraform plan` using a non-production variable file. Never include credentials, private keys, unredacted firewall backups, or Terraform state in pull requests.
