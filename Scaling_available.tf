# This .tf file contains the compenents for ASG, LT, and ALB
# Allows for better scaling, determining amount of available resources, and resource health
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
resource "aws_lb" "test" {
  name               = "app-lb-tf"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [vpc_security_group_ids.sg_http_https.id]
  subnets            = aws_subnet.public_sub.id

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "app-lb"
    enabled = true
  }
  tags = {
    Environment = "Application server load balancer"
  }
}

resource "aws_s3_bucket" "lb_logs" {
  bucket = "Application LB Logs"
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
