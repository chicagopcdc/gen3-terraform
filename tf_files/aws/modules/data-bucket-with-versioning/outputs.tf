output "data-bucket-with-versioning_name" {
  value = "${aws_s3_bucket.data_bucket.id}"
}

output "log_bucket-with-versioning_name" {
  value = aws_s3_bucket.log_bucket.id
}