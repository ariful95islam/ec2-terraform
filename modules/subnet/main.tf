resource "aws_subnet" "myapp_subnet_1" {
	vpc_id = var.vpc_id
	cidr_block = var.subnet_cidr_block
	availability_zone = var.avail_zone
	tags = {
		Name: "${var.env_prefix}-subnet-1"
	}
}

// this will determine where traffic from subnet/gateway is directed
resource "aws_route_table" "my_app_route_table" {
	vpc_id = var.vpc_id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.myapp_igw.id
	}
	tags = {
		Name: "${var.env_prefix}-rtb"
	}
}

// to give access to external connections
resource "aws_internet_gateway" "myapp_igw" {
	vpc_id = var.vpc_id
	tags = {
		Name: "${var.env_prefix}-igw"
	}
}

resource "aws_route_table_association" "a_rtb_subnet" {
	subnet_id = aws_subnet.myapp_subnet_1.id
	route_table_id = aws_route_table.my_app_route_table.id
}