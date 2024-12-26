data "aws_ssm_parameter" "ingress_alb" {
  name  = "/${var.project_name}/${var.environment_name}/ingress_alb"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/name/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/name/public_subnet_id"
}

data "aws_ssm_parameter" "web_acm" {
  name = "/${var.project_name}/${var.environment_name}/web_acm"
}

