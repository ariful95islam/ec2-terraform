// easy output of public ip to terminal
output "ec2_public_ip" {
	value = module.myapp_server.instance.public_ip
}