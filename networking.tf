# This file provides information for the Networking and routing intra and internet
# Contains the Internet Gateway, Route Table, Route Table Associations, NIC, and EIP assignments
# created 2/28/24
# last modified 2/28/24

# IGW
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
  
}

# Route Table and associations
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
resource "aws_route_table_association" "rt_a" {
    subnet_id = aws_subnet.public_1_sub.id
    route_table_id = aws_route_table.prod_rt.id
}

# Start Network Interface
resource "aws_network_interface" "NIC" {
  subnet_id       = aws_subnet.public_sub.id
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


