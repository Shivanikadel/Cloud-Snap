# Assignment 2 - FIT5225 - Clayton Group 44 (CloudSnap)
The source directory, containing Clayton Group 44 infrastructure as code and application source code.

## Assignment Application Source Code
The source of this project is primarily organised into main and terraform directories. Inside the terraform directory is the collection of infrastructure as code underlying much of the project (although the team intends that some of the front-end code may be added to S3 independently). Inside main is application code (e.g. for AWS Lambda functions).

## Assignment Infrastructure as Code
This project uses Terraform for provisioning infrastructure in the AWS cloud. To get started with Terraform, refer to the following resources:

  - Installation of the AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
  - Installation of HashiCorp Terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
  - Setup: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
  - Specifying Terraform variables: https://developer.hashicorp.com/terraform/language/values/variables#variables-on-the-command-line

To use Terraform with AWS Academy, access the "Learner Lab" landing page (modules section) and select "AWS Details" in the top right. Once this loads, you'll be able to access AWS CLI credentials, which are what Terraform uses to make changes in your account. When you reveal the AWS CLI credentials in the Learner Lab, it provides directions to copy these into `~/.aws/credentials`; after doing this, you should be able to access AWS from your laptop, which you can verify by running, for example,

```
aws ec2 describe-instances
```

Unfortunately, because we cannot create IAM roles, you'll need to specify the ARN of the LabRole IAM role as a variable (you can find this by navigating to IAM in the AWS management console, clicking on "Roles", and searching for "LabRole"). You'll need to fetch this ARN, and specify it in a .tfvars file. For example, under `src/terraform/variables.tfvars`, list

```
lab_role_arn = "${LAB_ROLE_ARN}"
ssh_public_key = "${YOUR_SSH_PUBLIC_KEY}"
code_bucket_suffix = "${SOME_ARBITRARY_SHORT_STRING}"
domain_suffix = "${SOME_ARBITRARY_SHORT_STRING}"
```

Once you have your variables.tfvars file set up, you can plan changes using

```
terraform plan -var-file=variables.tfvars
```

To get started with Terraform, navigate so that the current working directory is src/terraform, and be sure to run

```
terraform init
```

To make the planned changes take effect, you can use

```
terraform apply -var-file="variables.tfvars"
```

One should take care with this, because it can result in the creation of resources which incur charges. To tear down the created resources, you can try

```
terraform destroy -var-file="variables.tfvars"
```

