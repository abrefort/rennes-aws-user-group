resource "aws_dynamodb_table" "demo" {
  name           = "waf"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "IP"

  attribute {
    name = "IP"
    type = "S"
  }

  tags {
    Name        = "waf"
    environment = "demo"
  }
}
