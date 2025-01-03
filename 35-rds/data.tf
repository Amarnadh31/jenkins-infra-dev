data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project_name}/${var.environment_name}/mysql_sg_id"
}

# data "aws_ssm_parameter" "public_subnet_ids" {
#   name = "/${var.project_name}/${var.environment_name}/public_subnet_ids"
# }

data "aws_ssm_parameter" "database_group_name" {
  name  = "/name/database_group_name"
}

# data "aws_ami" "sebastian_ami"{
#     most_recent = true
#     owners = ["973714476881"]

#     filter {
#         name = "name"
#         values = ["RHEL-9-DevOps-Practice"]
#     }
#     filter {
#         name = "root-device-type"
#         values = ["ebs"]
#     }
# }