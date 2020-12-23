data "aws_iam_user" "github_actions_deploy_user" {
  user_name = "Github-Actions"
}

data "aws_iam_policy_document" "ga_upload_lambda_source_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.lambda_assets_bucket.arn,
      "${aws_s3_buket.lambda_assets_bucket.arn}/lambda.zip"
    ]
  }
}


resource "aws_iam_policy" "ga_upload_lambda_source" {
  name   = "ga-sra-upload-lambda-source"
  policy = data.aws_iam_policy.ga_upload_lambda_source_policy.json
}
