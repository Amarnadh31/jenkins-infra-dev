resource "aws_vpc" "main" {
  cidr_block       = var.vpc
  enable_dns_hostnames = var.enable_dns_hosts

  tags= merge(
    var.vpc_tags,
    {
        Name = "eks-vpc"
    }

  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name= "eks-igw"
  }
}


resource "aws_subnet" "public_sub" { 
  count = length(var.public_cidr) 
  vpc_id     = aws_vpc.main.id
  availability_zone = local.availability_zone[count.index]
  cidr_block = var.public_cidr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public- ${local.availability_zone[count.index]}"
  }
}

resource "aws_subnet" "private_sub" { 
  count = length(var.private_cidr) 
  vpc_id     = aws_vpc.main.id
  availability_zone = local.availability_zone[count.index]
  cidr_block = var.private_cidr[count.index]

  tags = {
    Name = "Private-${local.availability_zone[count.index]}"
  }
}

resource "aws_subnet" "database_sub" { 
  count = length(var.database_cidr) 
  vpc_id     = aws_vpc.main.id
  availability_zone = local.availability_zone[count.index]
  cidr_block = var.database_cidr[count.index]

  tags = {
    Name = "database-${local.availability_zone[count.index]}"
  }
}

resource "aws_db_subnet_group" "db_group" {
  name       = "db_group"
  subnet_ids = aws_subnet.database_sub[*].id

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public_sub[0].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

   tags = {
    Name = "pub-route"
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

   tags = {
    Name = "private-route"
  }

}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

   tags = {
    Name = "db-route"
  }

}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}


resource "aws_route_table_association" "public" {
    count = length(var.public_cidr)
  subnet_id      = aws_subnet.public_sub[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_cidr)
  subnet_id      = aws_subnet.private_sub[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
    count = length(var.database_cidr)
  subnet_id      = aws_subnet.database_sub[count.index].id
  route_table_id = aws_route_table.database.id
}