
#Private
resource "aws_subnet" "private_1_sub" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    
  tags = {
    name = "Production_private_subnet"
  }
}
