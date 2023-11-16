resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-296836-t"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}