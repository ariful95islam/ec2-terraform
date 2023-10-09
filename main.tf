provider "aws" {
	region = "eu-west-2"
}

resource "aws_vpc" "myapp_vpc" {
	cidr_block = var.vpc_cidr_block
	tags = {
		Name: "${var.env_prefix}-vpc"
	}
}

resource "aws_subnet" "myapp_subnet_1" {
	vpc_id = aws_vpc.myapp_vpc.id
	cidr_block = var.subnet_cidr_block
	availability_zone = var.avail_zone
	tags = {
		Name: "${var.env_prefix}-subnet-1"
	}
}

// this will determine where traffic from subnet/gateway is directed
resource "aws_route_table" "my_app_route_table" {
	vpc_id = aws_vpc.myapp_vpc.id

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
	vpc_id = aws_vpc.myapp_vpc.id
	tags = {
		Name: "${var.env_prefix}-igw"
	}
}

resource "aws_route_table_association" "a_rtb_subnet" {
	subnet_id = aws_subnet.myapp_subnet_1.id
	route_table_id = aws_route_table.my_app_route_table.id
}

resource "aws_security_group" "myapp_sg" {
	name = "myapp_sg"
	vpc_id = aws_vpc.myapp_vpc.id

	// incoming traffic rules are configured via ingress
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = [var.my_ip]
	}

	ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	// outgoing traffic rules are configured via egress
	// below config will allow any traffic to leave instance
	egress {
		// 0 means any port
		from_port = 0
		to_port = 0
		// "-1" means any protocol
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		prefix_list_ids = []
	}
	
	tags = {
		Name: "${var.env_prefix}-sg"
	}
}

// This will allow us to always get the latest image
data "aws_ami" "latest_amazon_linux_image" {
	most_recent = true
	//go to aws ec2 in console and go to images for default or your own images
	owners = ["amazon"]
	// filters let you define constraints for the image
	filter {
		name = "name"
		// regex match on name * is everything in between
		values = ["amzn2-ami-*-gp2"]
	}
	filter {
		name = "virtualization-type"
		values = ["hvm"]
	}
}

// This will access the ssh public key file 
// this is generated by ssh keygen command in terminal
resource "aws_key_pair" "ssh_key" {
	key_name = "server-key"
	public_key = var.public_key_location
}

resource "aws_instance" "myapp_server" {
	ami = data.aws_ami.latest_amazon_linux_image.id
	instance_type = var.instance_type

	// These are optional. If empty then default configuration will be used.
	subnet_id = aws_subnet.myapp_subnet_1.id
	vpc_security_group_ids = [aws_security_group.myapp_sg.id]
	availability_zone = var.avail_zone

	// Will allow you to connect to instance 
	associate_public_ip_address = true
	
	key_name = aws_key_pair.ssh_key.key_name

    //user-data is used to input commands
    //will only work first time
    user_data = file("install_docker.sh")

	tags = {
		Name = "${var.env_prefix}-server"
	}  
}

// easy output of public ip to terminal
output "ec2_public_ip" {
	value = aws_instance.myapp_server.public_ip
}