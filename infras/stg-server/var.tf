variable "project_name" {
  description = "Name of product"
  default     = "datalake"
}

variable "stage" {
  description = "Stage of product"
  default     = "stg-server"
}

variable "region" {
  description = "The AWS region to create resources in."
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "CIDR Block for Stg VPC"
  default     = "172.16.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "172.16.0.0/20"
}

variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "172.16.16.0/20"
}

variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "172.16.32.0/20"
}

variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "172.16.48.0/20"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/health-check"
}

variable "app_port" {
  description = "Port on which the app is running"
  default     = 3001
}

variable "image_tag" {
}

# variable "rds_db_name" {
# }
# variable "rds_username" {
# }
# variable "rds_password" {
# }

# variable "access_key" {
# }
# variable "secret_key" {
# }
# variable "token" {
# }



