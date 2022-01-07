// IAM Role to allow EC2 access to S3 resources
resource "aws_iam_role" "S3AdminRole" {
  name = "S3AdminRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "S3AdminRole"
  }
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.S3AdminRole.name}"
}


resource "aws_iam_role_policy" "S3Policy" {
  name = "S3Policy"
  role =  "${aws_iam_role.S3AdminRole.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}