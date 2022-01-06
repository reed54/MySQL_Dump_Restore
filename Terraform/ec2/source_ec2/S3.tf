
resource "aws_s3_bucket" "dump-restore" {
  bucket_prefix = var.bucket_prefix
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.dump-restore.id
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
      "${aws_s3_bucket.dump-restore.arn}",
      "${aws_s3_bucket.dump-restore.arn}/*",
    ]
  }
}

resource "local_file" "bucket_id" {
  content  = "export DUMP_RESTORE_BUCKET=${aws_s3_bucket.dump-restore.id}"
  filename = "/tmp/bucket_id"
}
