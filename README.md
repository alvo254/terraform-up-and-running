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
 - 

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

