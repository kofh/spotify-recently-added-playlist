variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "labmda_source_bucket_name" {
  description = "S3 Bucket name for Lambda Source"
  default     = "spotify-recently-added-playlist-lambda-source"
}

variable "github_actions_username" {
  description = "Username of the IAM User that assumes the deploy role"
  default     = "Github-Actions"
}

variable "github_actions_upload_lambda_source_role_name" {
  description = "Name of the role that will be used to upload the lambda source code to S3"
  default     = "ga-sra-upload-lambda-source"
}
