variable "bucket_domain_name" { type = string }

resource "aws_cloudfront_distribution" "tf-cf-distribution" {
  origin {
    domain_name      = var.bucket_domain_name
    origin_id   = "S3-Origin"
  }

  #aliases = ["www.supplied-domain-name"]

  enabled = true
    default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Origin"

    viewer_protocol_policy = "redirect-to-https"

    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

  }


  viewer_certificate {
    cloudfront_default_certificate = true
    
    #acm_certificate_arn = aws_acm_certificate.parl-website-cert.arn
    #ssl_support_method = "sni-only"
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

 /*  depends_on = [
    aws_acm_certificate.parl-website-cert,
  ] */
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.tf-cf-distribution.domain_name
}