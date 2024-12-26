resource "aws_instance" "k8s" {

  instance_type          = "t2.micro"
  ami = data.aws_ami.sebastian_ami.id
  vpc_security_group_ids = [data.aws_ssm_parameter.sebastian_sg_id.value]
  subnet_id              = local.public_subnet_id
  associate_public_ip_address = true

  tags = merge(
    var.common_tags,
    {
      Name= local.resource_name
    }
  )
}

resource "null_resource" "k8s_scripts" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = aws_instance.k8s.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = aws_instance.k8s.public_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "k8-script.sh"
    destination = "/tmp/k8-script.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo chmod +x /tmp/k8-script.sh",
      "sudo sh /tmp/k8-script.sh"
    ]
  }
}
