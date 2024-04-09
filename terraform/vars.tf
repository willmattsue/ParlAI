


# Terraform backend s3 bucket; run once, do not destroy
/* variable "s3_bucket" {
  type = string
  default = "sw-parlai-backend-s3-bucket"
} */

# Host website files
variable "s3_bucket" {
  type = string
  default = "sw-parlai-website-s3-bucket"
}
