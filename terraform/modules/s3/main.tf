
resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.project_name}-${var.bucket_name}"

}
