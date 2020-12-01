variable region {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable profile {
  description = "AWS Profile"
  type        = string
  default     = "ap"
}

# Get a list of existing instance ids from tags.
variable tag_name {
  description = "EC2 tag name"
  type        = string
  default     = "Stack"
}

variable tag_value {
  description = "EC2 tag value"
  type        = string
  default     = "Prod"
}

variable threshold_ec2_cpu {
  description = "CPU treshold to alarm"
  type        = string
  default     = "70"
}
variable threshold_ec2_disk {
  description = "Disk treshold to alarm"
  type        = string
  default     = "90"
}
variable threshold_ec2_mem {
  description = "Memory treshold to alarm"
  type        = string
  default     = "90"
}

variable alarm_actions {
  description = "Alarm action list"
  type        = list(string)
  default     = []
}