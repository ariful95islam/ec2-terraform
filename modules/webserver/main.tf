resource "aws_security_group" "myapp_sg" {
	name = "myapp_sg"
	vpc_id = var.vpc_id

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
	public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp_server" {
	ami = data.aws_ami.latest_amazon_linux_image.id
	instance_type = var.instance_type

	// These are optional. If empty then default configuration will be used.
	subnet_id = var.subnet_id
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