locals {
    availability_zone = slice(data.aws_availability_zones.available.names,0,2)
}