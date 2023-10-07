resource "aws_iam_role" "lambda_role" {
 name   = "terraform_aws_lambda_role"
 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy for logging from a lambda

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing AWS Lambda role"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*",
        Effect   = "Allow"
      },
      {
        Action   = "secretsmanager:GetSecretValue",
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}

# Policy Attachment on the role.

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

# Generates an archive from content, a file, or a directory of files.

data "archive_file" "zip_the_python_code" {
 type        = "zip"
 source_dir  = "${path.module}/python/"
 output_path = "${path.module}/python/lambda-demo.zip"
}

variable "lambda_function_name" {
  type    = string
  default = "test_lambda_func"
}

# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "test_lambda_func" {
  filename      = "${path.module}/python/lambda-demo.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "test_project.lambda_handler"
  runtime       = "python3.11"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  layers        = ["arn:aws:lambda:us-west-2:017000801446:layer:AWSLambdaPowertoolsPythonV2:40"]
}

resource "aws_lambda_permission" "allow_alb_invocation" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.test_TG.arn
}
