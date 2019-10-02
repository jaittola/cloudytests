resource "aws_vpc" "mainvpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_subnet" "public_subnets" {
    count = var.availability_zone_count
    vpc_id = aws_vpc.mainvpc.id
    cidr_block = cidrsubnet(aws_vpc.mainvpc.cidr_block, 8, count.index + 1)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    # map_public_ip_on_launch = true
}

resource "aws_subnet" "db_subnets" {
    count = var.availability_zone_count
    vpc_id = aws_vpc.mainvpc.id
    cidr_block = cidrsubnet(aws_vpc.mainvpc.cidr_block, 8, count.index + 1 + var.availability_zone_count)
    availability_zone = data.aws_availability_zones.available.names[count.index]
}


resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.mainvpc.id
}

resource "aws_route_table" "rtb_public" {
    vpc_id = aws_vpc.mainvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_route_table_association" "rta_public_subnet" {
    count = var.availability_zone_count
    subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "rta_db_subnets" {
    count = var.availability_zone_count
    subnet_id = element(aws_subnet.db_subnets.*.id, count.index)
    route_table_id = aws_route_table.rtb_public.id
}
