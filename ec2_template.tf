# This .tf file contains the compenents for EC2 Instances
# Launch one application server and one database server
# created 2/28/24
# last modified 2/28/24
#
resource "aws_instance" "app_Server" {
  ami = "${var.ami-id}"
  instance_type = "${var.instance_type}"
  subnet_id = aws_subnet.public_sub.id
  security_groups = [vpc_security_group_ids.sg_http_https.id, vpc_security_group_ids.sg_ssh.id]
  tags = {
    name = "appServer"
  }
}
# Check on how to tie to subnets
resource "aws_instance" "DB_Server" {
  ami = "${var.ami-id}"
  instance_type = "${var.instance_type}"
  subnet_id = aws_subnet.private_sub.id
  security_groups = [vpc_security_group_ids.sg_ssh.id, vpc_security_group_ids.mySQL]

  tags = {
    name = "DB_Server"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.DB_Server.id
}

resource "aws_ebs_volume" "example" {
  availability_zone = "${var.availability_zone}"
  size              = 1
}