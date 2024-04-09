data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
     principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }
}

variable "bucket_name" { type = string }

locals {
    mime_types = {
      ".html" = "text/html"
      ".png"  = "image/png"
      ".jpg"  = "image/jpeg"
      ".gif"  = "image/gif"
      ".css"  = "text/css"
      ".js"   = "application/javascript"
    }
}
