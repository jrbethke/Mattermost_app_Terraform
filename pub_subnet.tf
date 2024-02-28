# This file provides information for the private subnet that the application server will be located in
# created 2/28/24
# last modified 2/28/24
# Public
resource "aws_subnet" "public_sub" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.availability_zone}"
  # add in mapping in public ip here 
  # map_public_ip_on_launch = true

  tags = {
    name = "Production_public_subnet"
  }
}
