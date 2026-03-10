resource "aws_wafv2_web_acl" "prod" {
  provider = aws.prod
  name     = "prod-waf"
  scope    = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "prodWebACL"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "wafCommon"
      sampled_requests_enabled   = true
    }
  }
}

# Install AWS Load Balancer Controller and attach WAF to the ALB