
resource "aws_s3_bucket" "frontend" {
    bucket_prefix = "cloudy-testing.jukkaa.xyz"
    force_destroy = true
    versioning {
        enabled = false
    }
    website {
        index_document = "index.html"
    }
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend_bucket.json
}

data "aws_iam_policy_document" "frontend_bucket" {
  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.frontend.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

output "bucket-domain-name" {
  value = aws_s3_bucket.frontend.bucket_domain_name
}

output "bucket_url" {
    value = "s3://${aws_s3_bucket.frontend.id}"
}
