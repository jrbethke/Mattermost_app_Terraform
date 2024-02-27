
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
  
}

resource "aws_route_table" "prod_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = aws_vpc.main.cidr_block
        gateway_id = aws_internet_gateway.gw.id
    }

    route {
        ipv6_cidr_block = "::/0"
        egress_only_gateway_id = aws_internet_gateway.gw.id
        # options for VPC endpoint or peering here.
    }

    tags = {
      name = "Public Route Table"
    }
}
# Start Network Interface
resource "aws_network_interface" "NIC" {
  subnet_id       = aws_subnet.public_1_sub.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.sg_http_https]

  attachment {
    instance     = aws_instance.test.id
    device_index = 1
  }
}

resource "aws_eip" "serv" {
    domain = "vpc"
    network_interface = aws_network_interface.NIC.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = [ aws_internet_gateway.gw ]
}

# launch Template
resource "aws_launch_configuration" "example" {
    name = "appServer-config"
    image_id = "ami-0c7217cdde317cfec" # change to match your desired AMI. this is Ubuntu 22.04 LTS
    instance_type = "t2.micro"
    key_name = "your_key_pair_name"
    security_groups = [aws_security_group.allow_ssh.id]
    iam_instance_profile = aws_iam_instance_profile.example.name
    user_data = <<-EOF
    EOF
}


# Auto scaling group
 resource "aws_autoscaling_group" "T800" {
	 desired_capacity = 2
	 max_size = 5
	 min_size = 1
	 vpc_zone_identifier = [aws_subnet.public.id]
	 health_check_type = "EC2"
	 health_check_grace_period = 300
	 force_delete = true
	 launch_configuration = aws_launch_configuration.example.id
   }


resource "aws_route_table_association" "rt_a" {
    subnet_id = aws_subnet.public_1_sub.id
    route_table_id = aws_route_table.prod_rt.id
}

resource "aws_instance" "appServer" {
  ami = "ami-0c7217cdde317cfec"     # Ubuntu 22.04 LTS
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"

  tags = {
    name = "appServer"
  }
}
