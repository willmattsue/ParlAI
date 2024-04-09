module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = var.bucket_name

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"
  expected_bucket_owner    = data.aws_caller_identity.current.account_id
  acl                      = "public-read"

  attach_policy = true
  #policy = file("./s3/bucketpolicy.json") 
  policy = data.aws_iam_policy_document.bucket_policy.json

  versioning = {
    status     = true
  }

  website = {
    index_document = "index.html"
    }
}


resource "aws_s3_object" "build" {
  for_each = fileset("../website/build/", "**")
  bucket = module.s3_bucket.s3_bucket_id
  key = each.value
  source = "../website/build/${each.value}"
  etag = filemd5("../website/build/${each.value}")
  acl    = "public-read"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
} 