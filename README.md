# terraform-up-and-running
This repository is about terraform 

NOTE: All aws instances will be terminated and require to  be created a fresh
Always use blue, green deployment never reuse

## Inputs and variable
- variable docs for official docs
- Variable can be provided as a flag or in the tfvars file
- to use a flag run
 - -var=instace_type="t2.micro"

## Terraform divide files
Used to break the main.tf into smaller chunks


## Terraform Destroy
Active destroy mode 
    - Use terraform destroy

## Terraform cloud
Used to work with other in workspaces
 - terraform workspace 
 - terraform login 

## Incase of this error
 `
 │ Error: error configuring Terraform AWS Provider: failed to get shared config profile, default
│
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 20, in provider "aws":
│   20: provider "aws" {
 `
 Please remove the profile section from your code
 - Add the env variable to terraform cloud

## The userdata.yml
 - This file is a cloud-init

### Fix port 443 error
 - https://appuals.com/how-to-fix-an-existing-connection-was-forcibly-closed-by-the-remote-host-error/


## Check terraform output
- terraform output

# Change state from backend to terraform cloud remote to local
 - terraform init -migrate-state

## Working a load balancer
- This will be used to distribute traffic across your servers and and give your user an IP address
- AWS can do this automatically with Amazon elastic load balancer (ELB)

## Types of load balancers
 - Application load balancers(ALB)
    - Best for HTTP and HTTPS operates at the application layer of the OSI
 - Network load balancer(NLB)
    - Best for TCP, UDP, and TLS scale up and down in respond to load than ALB 
 - Classic load balancer(CLB)
    - This is the `legacy` load balancer that predates both the ALB and NLB.
    - It can handle both https, http, tcp and tls traffic but with far fewer features than either ALB or NLB

resource "aws_s3_bucket_versioning" "enabled" { bucket = aws_s3_bucket.terraform_state.id versioning_configuration { status = "Enabled" } }


resource "aws_dynamodb_table" "terraform_locks" { name         = "terraform-up-and-running-locks" billing_mode = "PAY_PER_REQUEST" hash_key     = "LockID" attribute { name = "LockID" type = "S" } 


# Resource meta arguments
Terraform language defines several meta-arguments, which can be used with any resouces type to change the behavior of resources.

 - depends_on, for specifying explicit dependencies
 - count, for creating multiple resource instance according to a count
 - for_each, to create multiple instances according to a map, or set of strings
 - provider, for selecting a non-default provider configuration
 - lifecycle, for lifecycle customizations
 - provisioner, and connection for taking extra actions after resource creation



