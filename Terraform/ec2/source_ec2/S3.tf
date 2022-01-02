resource "aws_s3_bucket" "bucket_name" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket_name.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.source_account, var.target_account]
    }

    actions = ["s3:*"]

    resources = [
      "${aws_s3_bucket.bucket_name.arn}",
      "${aws_s3_bucket.bucket_name.arn}/*",
    ]
  }
}