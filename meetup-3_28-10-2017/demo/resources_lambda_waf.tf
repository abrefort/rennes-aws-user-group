data "archive_file" "lambda_waf" {
    type        = "zip"
    source_file = "${path.module}/sources/waf.py"
    output_path = "${path.module}/tmp/waf.zip"
}

resource "aws_lambda_function" "waf" {
  filename         = "${data.archive_file.lambda_waf.output_path}"
  function_name    = "update_waf"
  role             = "${aws_iam_role.lambda_waf.arn}"
  handler          = "waf.update_waf"
  source_code_hash = "${data.archive_file.lambda_waf.output_base64sha256}"
  runtime          = "python3.6"
  publish          = "true"

  environment {
    variables = {
      ip_set = "${aws_waf_ipset.demo.id}"
    }
  }
}

resource "aws_iam_role" "lambda_waf" {
  name = "lambda_waf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_waf_basic" {
  role = "${aws_iam_role.lambda_waf.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_waf_dynamodb" {
  name = "lambda_waf_dynamodb"
  role = "${aws_iam_role.lambda_waf.name}"

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

resource "aws_iam_role_policy" "lambda_waf_waf" {
  name = "lambda_waf_waf"
  role = "${aws_iam_role.lambda_waf.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "waf:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "waf_cron" {
  statement_id  = "WafCron"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.waf.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.waf_cron.arn}"

  count = "${var.cron == "" ? 0 : 1}"
}

resource "aws_cloudwatch_event_rule" "waf_cron" {
  name                = "waf_cron"
  schedule_expression = "cron(${var.cron})"

  count = "${var.cron == "" ? 0 : 1}"
}

resource "aws_cloudwatch_event_target" "waf_cron" {
  rule = "${aws_cloudwatch_event_rule.waf_cron.name}"
  arn  = "${aws_lambda_function.waf.arn}"

  count = "${var.cron == "" ? 0 : 1}"
}
