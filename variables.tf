variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "domain name to use"
  default     = "spotify-recently-added-playlist-lambda-source"
}
