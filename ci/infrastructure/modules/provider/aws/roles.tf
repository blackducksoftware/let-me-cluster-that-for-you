//  Create a role which cluster instances will assume.
//  This role has a policy saying it can be assumed by ec2
//  instances.
resource "aws_iam_role" "cluster-instance-role" {
  name = "${var.prefix}-cluster-instance-role"
  count = "${var.is_enabled == "true" ? "1" : "0"}"

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
}

//  This policy allows an instance to forward logs to CloudWatch, and
//  create the Log Stream or Log Group if it doesn't exist.
resource "aws_iam_policy" "cluster-policy-forward-logs" {
  name = "${var.prefix}-cluster-instance-forward-logs"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  path = "/"
  description = "Allows an instance to forward logs to CloudWatch"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
  }
 ]
}
EOF
}


//  Attach the policies to the role.
resource "aws_iam_policy_attachment" "cluster-attachment-forward-logs" {
  name = "${var.prefix}-cluster-attachment-forward-logs"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  roles = ["${aws_iam_role.cluster-instance-role.name}"]
  policy_arn = "${aws_iam_policy.cluster-policy-forward-logs.arn}"
}

//  Create a instance profile for the role.
resource "aws_iam_instance_profile" "cluster-instance-profile" {
  name = "${var.prefix}-cluster-instance-profile"
  count = "${var.is_enabled == "true" ? "1" : "0"}"
  role = "${aws_iam_role.cluster-instance-role.name}"
}

