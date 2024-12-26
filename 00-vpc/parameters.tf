resource "aws_ssm_parameter" "vpc" {
  name = "/name/vpc_id"
  type = "String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "public_subnet" {
  name = "/name/public_subnet_id"
  type = "StringList"
  value = join(",", aws_subnet.public_sub[*].id)
  # overwrite = true
  
}

resource "aws_ssm_parameter" "private_subnet" {
    count = length(aws_subnet.private_sub)
  name = "/name/private_subnet_id"
  type = "StringList"
  value = join(",", aws_subnet.private_sub[*].id)
  # overwrite = true
}


resource "aws_ssm_parameter" "database_subnet" {
    count = length(aws_subnet.database_sub)
  name = "/name/database_subnet_id"
  type = "StringList"
  value = join(",", aws_subnet.public_sub[*].id)
  # overwrite = true
}