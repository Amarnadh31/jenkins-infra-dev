data "aws_ssm_parameter" "vpc" {
  name = "/name/vpc_id"
}

data "aws_ssm_parameter" "private_subnet" {
    name = "/name/private_subnet_id"
  
}

data "aws_ssm_parameter" "eks_control_plane_id" {
    name  = "/${var.project_name}/${var.environment_name}/eks_control_plane_sg_id"
  
}

data "aws_ssm_parameter" "node_sg"{
    name  = "/${var.project_name}/${var.environment_name}/node_sg_id"
}


data "aws_ssm_parameter" "keypair"{
    name  = "/${var.project_name}/${var.environment_name}/keypair"
}