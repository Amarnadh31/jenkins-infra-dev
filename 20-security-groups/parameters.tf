resource "aws_ssm_parameter" "sebastian_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/sebastian_sg_id"
  type  = "String"
  value = module.sebastian.sg_id
}

resource "aws_ssm_parameter" "eks_control_plane_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/eks_control_plane_sg_id"
  type  = "String"
  value = module.eks_control_plane.sg_id
}

resource "aws_ssm_parameter" "node_sg_id" {
  name  = "/${var.project_name}/${var.environment_name}/node_sg_id"
  type  = "String"
  value = module.node.sg_id
}

resource "aws_ssm_parameter" "ingress_alb" {
  name  = "/${var.project_name}/${var.environment_name}/ingress_alb"
  type  = "String"
  value = module.ingress_alb.sg_id
}