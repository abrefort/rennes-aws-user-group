resource "aws_waf_ipset" "demo" {
  name = "demo"
}

resource "aws_waf_rule" "demo" {
  name        = "demo"
  metric_name = "demo"

  predicates {
    data_id = "${aws_waf_ipset.demo.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "demo" {
  name        = "demo"
  metric_name = "demo"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = "${aws_waf_rule.demo.id}"
  }
}
