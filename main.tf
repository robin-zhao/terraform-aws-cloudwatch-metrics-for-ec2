terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.14.1"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

data "aws_instances" "instances_list" {
  instance_tags = {
    (var.tag_name) = var.tag_value
  }
}

module instance_names {
  for_each    = toset(data.aws_instances.instances_list.ids)
  source      = "./ec2_alarm"
  instance_id = each.key

  region             = var.region
  tag_name           = var.tag_name
  tag_value          = var.tag_value
  threshold_ec2_cpu  = var.threshold_ec2_cpu
  threshold_ec2_disk = var.threshold_ec2_disk
  threshold_ec2_mem  = var.threshold_ec2_mem
  alarm_actions      = var.alarm_actions
}

