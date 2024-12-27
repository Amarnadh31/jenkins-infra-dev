data "aws_cloudfront_cache_policy" "noCache" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "web_acm" {
  name  = "/${var.project_name}/${var.environment_name}/web_acm"
}