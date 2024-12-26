locals {
  private_subnet = split(",", data.aws_ssm_parameter.private_subnet.value)
  eks_control_plane_sg_id = data.aws_ssm_parameter.eks_control_plane_id.value
  node_sg_id = data.aws_ssm_parameter.node_sg.value
}