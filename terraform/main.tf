
module "s3" {
    source = "./s3"
    bucket_name = var.s3_bucket
}


module "route" {
    source = "./cloudfront"
    bucket_domain_name = module.s3.s3_bucket_bucket_regional_domain_name
}



