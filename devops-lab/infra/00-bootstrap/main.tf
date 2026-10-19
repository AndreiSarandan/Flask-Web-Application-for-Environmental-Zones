data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  # account-regional namespace suffix: <account>-<region>-an
  state_bucket = "devops-lab-tfstate-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}-an"
}


resource "aws_s3_bucket" "tfstate" {
  bucket = local.state_bucket

  lifecycle {
    prevent_destroy = true # losing state = Terraform forgets everything it manages
  }
}


resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # SSE-S3: free, AWS-managed keys
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true # reject PUTs that carry public ACLs
  ignore_public_acls      = true # treat existing public ACLs as private
  block_public_policy     = true # reject bucket policies that grant public access
  restrict_public_buckets = true # even if a public policy exists, only AWS principals in this account get in
}
