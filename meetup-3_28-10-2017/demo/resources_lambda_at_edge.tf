data "archive_file" "lambda_edge" {
    type        = "zip"
    source_file = "${path.module}/sources/edge.js"
    output_path = "${path.module}/tmp/lambda_edge.zip"
}

resource "aws_lambda_function" "edge" {
  filename         = "${data.archive_file.lambda_edge.output_path}"
  function_name    = "waf_demo"
  role             = "${aws_iam_role.lambda_edge.arn}"
  handler          = "edge.handler"
  source_code_hash = "${data.archive_file.lambda_edge.output_base64sha256}"
  runtime          = "nodejs6.10"
  publish          = "true"
}

resource "aws_iam_role" "lambda_edge" {
  name = "lambda_edge"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_edge_basic" {
  role = "${aws_iam_role.lambda_edge.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_edge_dynamodb" {
  name = "lambda_edge_dynamodb"
  role = "${aws_iam_role.lambda_edge.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "dynamodb:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
