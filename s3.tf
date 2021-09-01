resource "aws_s3_bucket" "b" {
  bucket = "myapp-artifacts-bucket"
  acl    = "public-read"
}