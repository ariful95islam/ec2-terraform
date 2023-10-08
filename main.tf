provider "aws" {
	region = "eu-west-2"
}

resource "aws_vpc" "myapp_vpc" {
	cidr_block = var.vpc_cidr_block
	tags = {
		Name: "${var.env_prefix}-vpc"
	}
}

module "myapp_subnet" {
	source = "./modules/subnet"
	subnet_cidr_block = var.subnet_cidr_block
	avail_zone = var.avail_zone
	env_prefix = var.env_prefix
	vpc_id = aws_vpc.myapp_vpc.id
}

module "myapp_server" {
	source = "./modules/webserver"
	vpc_id = aws_vpc.myapp_vpc.id
	my_ip = var.my_ip	
	env_prefix = var.env_prefix
	public_key_location = var.public_key_location
	instance_type = var.instance_type
	avail_zone = var.avail_zone
	subnet_id = module.myapp_subnet.subnet.id
}