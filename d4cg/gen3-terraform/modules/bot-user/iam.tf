# bot

## bot user
resource "aws_iam_user" "bot" {
  name = "${var.vpc_name}_${var.bot_name}-bot"
}

## bot key/secret
resource "aws_iam_access_key" "bot_user_key" {
  user = aws_iam_user.bot.name
}

## bot access policy
resource "aws_iam_user_policy" "bot_policy" {
  name   = "${var.vpc_name}_${var.bot_name}-bot_policy"
  user   = aws_iam_user.bot.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": ["${data.aws_s3_bucket.data-bucket.arn}/*"]
    },
    {
      "Action": [
        "s3:List*",
        "s3:Get*"
      ],
      "Effect": "Allow",
      "Resource": ["${data.aws_s3_bucket.data-bucket.arn}/*", "${data.aws_s3_bucket.data-bucket.arn}"]
    }
  ]
}
EOF

  lifecycle {
    ignore_changes = [policy]
  }
}

resource "aws_iam_user_policy" "bot_extra_policy" {
  count = length(var.bucket_access_arns)
  name  = "${var.vpc_name}_${var.bot_name}-bot_policy_${count.index}"
  user  = aws_iam_user.bot.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": ["${var.bucket_access_arns[count.index]}/*"]
    },
    {
      "Action": [
        "s3:List*",
        "s3:Get*"
      ],
      "Effect": "Allow",
      "Resource": ["${var.bucket_access_arns[count.index]}/*", "${var.bucket_access_arns[count.index]}"]
    }
  ]
}
EOF
}

resource "aws_iam_user_policy" "gearbox_bot_assume_prod" {
  count = "${var.is_gearbox_staging ? 1 : 0}"

  name = "${var.vpc_name}-assume-prod-role"
  user = "${aws_iam_user.bot.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${var.prod_promotion_role_arn}"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "staging_promotion_role" {
  count = "${var.is_gearbox_prod ? 1 : 0}"

  name = "${var.vpc_name}-staging-promote-to-prod-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.staging_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_policy" "staging_promotion_policy" {
  count = "${var.is_gearbox_prod ? 1 : 0}"

  name = "${var.vpc_name}-staging-promote-to-prod-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "arn:aws:s3:::${var.bucket_name}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach_promote_policy" {
  count = "${var.is_gearbox_prod ? 1 : 0}"

  role       = "${element(aws_iam_role.staging_promotion_role.*.name, 0)}"
  policy_arn = "${element(aws_iam_policy.staging_promotion_policy.*.arn, 0)}"
}

