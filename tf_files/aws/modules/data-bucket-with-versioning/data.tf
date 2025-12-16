## Policies data 

data "aws_iam_policy_document" "data_bucket_with_versioning_reader" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]

    effect    = "Allow"
    resources = ["${aws_s3_bucket.data_bucket.arn}", "${aws_s3_bucket.data_bucket.arn}/*"]
  }
}

data "aws_iam_policy_document" "data_bucket_with_versioning_writer" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    effect    = "Allow"
    resources = ["${aws_s3_bucket.data_bucket.arn}", "${aws_s3_bucket.data_bucket.arn}/*"]
  }
}