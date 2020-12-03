variable instance_id {}
variable tag_name {}
variable tag_value {}
variable threshold_ec2_cpu {}
variable threshold_ec2_disk {}
variable threshold_ec2_mem {}
variable alarm_actions {}
variable region {}
variable profile {}

data "aws_instance" "each_instance" {
  instance_id = var.instance_id
}

data "external" "disk_dimensions" {
  program = ["bash", "${path.module}/disk_dimensions.sh"]
  query = {
    profile = var.profile
    region = var.region
    instance_id = var.instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name = join("|", [
    "Alarm", 
    var.region, 
    "EC2", 
    data.aws_instance.each_instance.tags.Name,
    "CPUUtilization"
  ])

  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = var.threshold_ec2_cpu
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions             = var.alarm_actions

  dimensions = {
    InstanceId = var.instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "mem_used_percent_alarm" {
  alarm_name = join("|", [
    "Alarm", 
    var.region, 
    "EC2", 
    data.aws_instance.each_instance.tags.Name,
    "mem_used_percent"
  ])

  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "mem_used_percent"
  namespace                 = "CWAgent"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = var.threshold_ec2_mem
  alarm_description         = "This metric monitors ec2 memory utilization"
  insufficient_data_actions = []
  alarm_actions             = var.alarm_actions

  dimensions = {
    InstanceId = var.instance_id
    ImageId = data.aws_instance.each_instance.ami
    InstanceType = data.aws_instance.each_instance.instance_type
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_used_percent_alarm" {
  alarm_name = join("|", [
    "Alarm", 
    var.region, 
    "EC2", 
    data.aws_instance.each_instance.tags.Name,
    "disk_used_percent"
  ])

  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "disk_used_percent"
  namespace                 = "CWAgent"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = var.threshold_ec2_disk
  alarm_description         = "This metric monitors ec2 disk utilization"
  insufficient_data_actions = []
  alarm_actions             = var.alarm_actions

  dimensions = {
    InstanceId = data.external.disk_dimensions.result.InstanceId
    path = data.external.disk_dimensions.result.path
    ImageId = data.external.disk_dimensions.result.ImageId
    InstanceType = data.external.disk_dimensions.result.InstanceType
    device = data.external.disk_dimensions.result.device
    fstype = data.external.disk_dimensions.result.fstype
  }
}