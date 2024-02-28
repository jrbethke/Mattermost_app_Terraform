# This .tf file contains the compenents for launching EC2 computing setup and distributing workload
# Launch Template, Load Balancer, ASG, and instances
# created 2/28/24
# last modified 2/28/24
#

# launch Template
resource "aws_launch_configuration" "example" {
    name = "appServer-config"
    image_id = "${var.ami-id}" # change to match your desired AMI. this is Ubuntu 22.04 LTS
    instance_type = "${var.instance_type}"
    security_groups = [aws_security_group.allow_ssh.id] # Provide SG information here
    iam_instance_profile = aws_iam_instance_profile.ec2_type.id
    
    user_data = <<-EOF
    EOF
}

# LB

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