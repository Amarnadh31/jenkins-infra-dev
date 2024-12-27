module "mysql" {
    source = "git::https://github.com/Amarnadh31/terraform-security-group-module.git?ref=main"
    project_name = var.project_name
    sg_name = "mysql-sg"
    environment_name = var.environment_name
    vpc_id = data.aws_ssm_parameter.vpc.value
    common_tags = var.common_tags
    sg_tags = var.mysql_sg_tags
}

module "sebastian" {
    source = "git::https://github.com/Amarnadh31/terraform-security-group-module.git?ref=main"
    project_name = var.project_name
    sg_name = "sebastian-sg"
    environment_name = var.environment_name
    vpc_id = data.aws_ssm_parameter.vpc.value
    common_tags = var.common_tags

}

module "node" {
    source = "git::https://github.com/Amarnadh31/terraform-security-group-module.git?ref=main"
    project_name = var.project_name
    sg_name = "node-sg"
    environment_name = var.environment_name
    vpc_id = data.aws_ssm_parameter.vpc.value
    common_tags = var.common_tags

}

module "eks_control_plane" {
    source = "git::https://github.com/Amarnadh31/terraform-security-group-module.git?ref=main"
    project_name = var.project_name
    sg_name = "eks-control-plane-sg"
    environment_name = var.environment_name
    vpc_id = data.aws_ssm_parameter.vpc.value
    common_tags = var.common_tags

}

module "ingress_alb" {
    source = "git::https://github.com/Amarnadh31/terraform-security-group-module.git?ref=main"
    project_name = var.project_name
    sg_name = "ingress-alb-sg"
    environment_name = var.environment_name
    vpc_id = data.aws_ssm_parameter.vpc.value
    common_tags = var.common_tags

}

resource "aws_security_group_rule" "ingress_alp_http" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb.sg_id

}


resource "aws_security_group_rule" "ingress_node" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  source_security_group_id = module.ingress_alb.sg_id
  security_group_id = module.node.sg_id

}

resource "aws_security_group_rule" "node_eks_control_plane" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_control_plane.sg_id
  security_group_id = module.node.sg_id

}

resource "aws_security_group_rule" "eks_control_plane_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.node.sg_id
  security_group_id = module.eks_control_plane.sg_id

}

resource "aws_security_group_rule" "node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = module.node.sg_id

}

resource "aws_security_group_rule" "node_sebastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sebastian.sg_id
  security_group_id = module.node.sg_id

}

resource "aws_security_group_rule" "eks_control_plane_sebastian" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.sebastian.sg_id
  security_group_id = module.eks_control_plane.sg_id

}





resource "aws_security_group_rule" "mysql_node" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.node.sg_id
  security_group_id = module.mysql.sg_id

}


resource "aws_security_group_rule" "mysql_node" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.sebastian.sg_id
  security_group_id = module.mysql.sg_id

}

resource "aws_security_group_rule" "mysql_sebastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sebastian.sg_id
  security_group_id = module.mysql.sg_id

}


resource "aws_security_group_rule" "sebastian_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = module.sebastian.sg_id

}