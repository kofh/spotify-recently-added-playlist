resource "aws_s3_bucket" "lambda-assets-bucket" {
  bucket = var.bucket_name
  acl    = "private"

  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    "Project" = "Spotify Recently Added Playlist"
  }
}
