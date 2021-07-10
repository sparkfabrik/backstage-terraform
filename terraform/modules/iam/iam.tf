resource "aws_iam_policy" "ssm_policy" {
  name        = "${var.project}-ssm-policy"
  path        = "/"
  description = "Access to Parameter Store variables"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameters"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_policy" "logs_policy" {
  name        = "${var.project}-logs-policy"
  path        = "/"
  description = "Access to Cloudwatch"
  policy      = jsonencode({
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
          "arn:aws:logs:*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "${var.project}-ecr-policy"
  path        = "/"
  description = "Access to ECR"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ],
        "Resource": "*"
      }
    ]
  })
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backstage_role" {
  name               = "${var.project}-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

resource "aws_iam_role_policy_attachment" "backstage-ssm-policy-attach" {
  role       = aws_iam_role.backstage_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_role_policy_attachment" "backstage-logs-policy-attach" {
  role       = aws_iam_role.backstage_role.name
  policy_arn = aws_iam_policy.logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "backstage-ecr-policy-attach" {
  role       = aws_iam_role.backstage_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}
