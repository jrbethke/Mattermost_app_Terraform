# subnets
# Public
resource "aws_subnet" "public_1_sub" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  # add in mapping in public ip here 
  # map_public_ip_on_launch = true

  tags = {
    name = "Production_public_subnet"
  }
}
