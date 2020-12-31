data "aws_iam_user" "github_actions_deploy_user" {
  user_name = "Github-Actions"
}

data "aws_iam_policy_document" "ga_upload_lambda_source_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.lambda_assets_bucket.arn,
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.lambda_assets_bucket.arn}/*"
    ]
  }
}


resource "aws_iam_policy" "ga_upload_lambda_source" {
  name   = "sra-ga-upload-lambda-source"
  policy = data.aws_iam_policy_document.ga_upload_lambda_source_policy.json
}

data "aws_iam_policy_document" "ga_upload_lambda_source_role_trust_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_user.github_actions_deploy_user.arn]
    }
  }
}

resource "aws_iam_role" "ga_upload_lambda_source" {
  name               = "sra-ga-upload-lambda-source"
  assume_role_policy = data.aws_iam_policy_document.ga_upload_lambda_source_role_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "ga_upload_lambda_source_attachment" {
  role       = aws_iam_role.ga_upload_lambda_source.name
  policy_arn = aws_iam_policy.ga_upload_lambda_source.arn
}
