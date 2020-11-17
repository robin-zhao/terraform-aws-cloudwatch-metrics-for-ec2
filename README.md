# CloudWatch Alarms

This Terraform scirpt creates following Alarms to tagged EC2 instances.

- CPUUtilization
- mem_used_percent
- disk_used_percent

## Prerequisite

1. Proper AWS CLI permissions to run Terraform (EC2, CloudWatch, SNS)

2. A bunch of running EC2 instances with at least following tags
   - Name:Value (Used to name the CloudWatch Metrics)
   - Stack:Value (Used to fetch instance list)

3. CloudWatch Agent Must be run to fetch metrics like mem_used_percent.

## Example command

   - `terraform init`

   - `terraform plan -var "profile=default" -var "region=us-east-1" -var "tag_name=Stack" -var "tag_value=Test"`
   `-var "threshold_ec2_cpu=70" -var "threshold_ec2_mem=90" -var "threshold_ec2_disk=90"`
   `-var 'sns_arn=["arn:aws:sns:us-east-1:000000000000:test"]'`

   - `terraform apply -var "profile=default" -var "region=us-east-1" -var "tag_name=Stack" -var "tag_value=Test"`
   `-var "threshold_ec2_cpu=70" -var "threshold_ec2_mem=90" -var "threshold_ec2_disk=90"`
   `-var 'sns_arn=["arn:aws:sns:us-east-1:000000000000:test"]'`
