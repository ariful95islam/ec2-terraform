variable vpc_cidr_block {
    description = "The CIDR block for the VPC"
    default = "10.0.0.0/16"
}
variable subnet_cidr_block {
    description = "The CIDR block for the subnet"
    default = "10.0.10.0/24"
}
variable avail_zone {
    description = "The availability zone for the subnet"
    default = "eu-west-2a"
}
variable env_prefix {
    description = "The prefix for the environment"
    default = "dev"
}
variable my_ip {
    description = "The IP address to allow SSH access from"
    default = "0.0.0.0/24"
}
variable instance_type {
    description = "The instance type to use"
    default = "t2.micro"
}
variable public_key_string {
    description = "The string of the public key to use"
    type = "string"
    default = ""
}