# This file provides information for the private subnet that the database server will be located in
# created 2/28/24
# last modified 2/28/24
#
# Private
resource "aws_subnet" "private_sub" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.availability_zone}"
  tags = {
    name = "Production_private_subnet"
  }
}
