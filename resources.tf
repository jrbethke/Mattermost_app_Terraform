resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        name = "Production"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
  
}

resource "aws_route_table" "prod_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    route {
        ipv6_cidr_block = "::/0"
        egress_only_gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
      name = "Production"
    }
}

resource "aws_subnet" "public_1_sub" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    name = "Production_public_subnet"
  }
}

resource "aws_subnet" "private_1_sub" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
  
  tags = {
    name = "Production_private_subnet"
  }
}

resource "aws_route_table_association" "rt_a" {
    subnet_id = aws_subnet.public_1_sub.id
    route_table_id = aws_route_table.prod_rt.id
}

# Start HTTP and HTTPS SG 
resource "aws_security_group_" "sg_http_https" {
    name = "allow_inbound_traffic"
    description = "Allow Web traffic"
    vpc_id = aws_vpc.main.id

    tags = {
        name = "Allow_HTTP_HTTPS"
    }
}
resource "aws_vpc_security_group_ingress_rule" "https_ipv4" {
    security_group_id = aws_security_group_.sg_http_https.id
    cidr_ipv4 = aws_vpc.main.cidr_block
    ip_protocol = "tcp"
    from_port = 443
    to_port   = 443 
}
resource "aws_vpc_security_group_ingress_rule" "https_ipv6" {
    security_group_id = aws_security_group_.sg_http_https.id
    cidr_ipv4 = aws_vpc.main.ipv6_cidr_block
    ip_protocol = "tcp"
    from_port = 443
    to_port   = 443 
}
resource "aws_vpc_security_group_ingress_rule" "http_ipv4" {
    security_group_id = aws_security_group_.sg_http_https.id
    cidr_ipv4 = aws_vpc.main.cidr_block
    ip_protocol = "tcp"
    from_port = 80
    to_port   = 80 
}
resource "aws_vpc_security_group_ingress_rule" "https_ipv6" {
    security_group_id = aws_security_group_.sg_http_https.id
    cidr_ipv4 = aws_vpc.main.ipv6_cidr_block
    ip_protocol = "tcp"
    from_port = 80
    to_port   = 80 
}
# Finished

# Start mySQL SG
resource "aws_security_group_" "sg_mySQL" {
    name = "allow_mySQL_traffic"
    description = "For mySQL data depo"
    vpc_id = aws_vpc.main.id

    tags = {
        name = "mySQL_Traffic"
    }
}
resource "aws_vpc_security_group_ingress_rule" "mySQL_ipv4" {
    security_group_id = aws_security_group_.sg_mySQL.id
    cidr_ipv4 = aws_vpc.main.cidr_block
    ip_protocol = "tcp"
    from_port = 3306
    to_port   = 3306
}
resource "aws_vpc_security_group_ingress_rule" "mySQL_ipv6" {
    security_group_id = aws_security_group_.sg_mySQL.id
    cidr_ipv4 = aws_vpc.main.ipv6_cidr_block
    ip_protocol = "tcp"
    from_port = 3306
    to_port   = 3306 
}
# Finish

# Start ssh SG
resource "aws_security_group_" "sg_ssh" {
    name = "allow_ssh_traffic"
    description = "Secure Shell"
    vpc_id = aws_vpc.main.id

    tags = {
        name = "ssh_Traffic"
    }
}
resource "aws_vpc_security_group_ingress_rule" "ssh_ipv4" {
    security_group_id = aws_security_group_.sg_ssh.id
    cidr_ipv4 = aws_vpc.main.cidr_block
    ip_protocol = "tcp"
    from_port = 22
    to_port   = 22
}
resource "aws_vpc_security_group_ingress_rule" "ssh_ipv6" {
    security_group_id = aws_security_group_.sg_ssh.id
    cidr_ipv4 = aws_vpc.main.ipv6_cidr_block
    ip_protocol = "tcp"
    from_port = 22
    to_port   = 22 
}
# Finish

# Start Egress
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
# Finish

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

  
}