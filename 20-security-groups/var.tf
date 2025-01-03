variable "project_name" {
    default = "expense"
}

variable "environment_name" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = true 
    }
}

variable "sg_tags" {
    default = {}
}

variable "mysql_sg_tags" {
    default = {
        component = "mysql"
    }
}