# james0

automatic installation of k8s in aws platform

  1. make the script executable `chmod 755` *setup_env.sh*
  2. start the main program to install all dependencies necessary `./setup_env.sh`

if 2 steps above is complete then move to the next steps : 
#### Setup S3, VPC and Security Group using Terraform

  3. cd terraform-files 
  4. terraform init   -> to initialise the terraform and download the necessary dependecies 
  5. terraform plan   -> to see what about to be deployed
  6. terraform apply  -> to apply the plan ( deployment )
  7. make sure you already have ssh `~/.ssh/id.rsa.pub` if you havent had it create one wit `ssh-keygen` (there are lots of tuts for this)
  8. assuming the `~/.ssh/id.rsa.pub` is ready then move with the next step `kops create secret --name blog.cloudservices2go.com --state s3://k8.cloudservices2go.com sshpublickey admin -i ~/.ssh/id_rsa.pub`
