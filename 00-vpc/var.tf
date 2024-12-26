variable "vpc" {
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
    default = {
        project = "expense"
        env = "dev"
    }
  
}


variable "enable_dns_hosts"{
    default = true
}

variable "public_cidr" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.11.0/24"]
  
}

variable "private_cidr" {
    type = list(string)
    default = ["10.0.21.0/24", "10.0.22.0/24"]
  
}

variable "database_cidr" {
    type = list(string)
    default = ["10.0.31.0/24", "10.0.33.0/24"]
  
}