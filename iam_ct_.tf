/* Commented out until more is learned about IAM/Flow Logs/API Calls
# IAM Role 
resource "aws_iam_role" "instance_role" {
    name = "ec2-instance-role"
    assume_role_policy = <<EOF
    {
    "Version": "Your_creation_Date_here",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        }
        }
    ]
    }
    EOF
}

resource "aws_iam_policy_attachment" "iam_attachment" {

    name = "readOnlyaccess"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"

}

resource "aws_iam_instance_profile" "T2_micro" {
    name = "service_account_profile"

    roles = [aws_iam_role.instance_role.name]
}

resource "aws_flow_log" "trylink_trail" {
    depends_on = [aws_subnet.public]
    iam_role_arn = aws_iam_role.instance_role.arn
    log_destination = "arn:aws:logs:your_aws_region:T2_micro:log-group:/resistance-logs"
    traffic_type = "ALL"
    log_format = "PLAINTEXT"
    max_aggregation_interval = 60
    subnet_id = aws_subnet.public.id
}

//Enable CloudTrail for AWS API call logging 
resource "aws_cloudtrail" "trylink" {
    name = "trylink-cloudtrail"
    s3_bucket_name = "s3_trylink"
}
*/