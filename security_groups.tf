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

# Start ssh SG. Traffic in is limited to your public IP. Traffic out can go anywhere
resource "aws_security_group_" "sg_ssh" {
    name = "allow_ssh_traffic"
    description = "Secure Shell"
    vpc_id = aws_vpc.main.id
    cidr_blocks = "<Your Public IP Address here>"
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
