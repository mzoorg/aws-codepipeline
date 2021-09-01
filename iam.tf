resource "aws_iam_role" "tf-cicd-pipeline-role" {
  name = "tf-cicd-pipeline-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf-cicd-pipeline-role-statement" {
  statement {
    actions   = ["codestar-connections:UseConnection", "cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "tf-cicd-pipeline-role-policy" {
    name = "tf-cicd-pipeline-role-policy"
    description = "pipeline policy"
    policy = data.aws_iam_policy_document.tf-cicd-pipeline-role-statement.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-role-attach" {
    policy_arn = aws_iam_policy.tf-cicd-pipeline-role-policy.arn
    role = aws_iam_role.tf-cicd-pipeline-role.id
}

resource "aws_iam_role" "tf-cicd-codebuild-role" {
  name = "tf-cicd-codebuild-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf-cicd-codebuild-role-statement" {
  statement {
    actions   = ["logs:*", "secretmanager:*", "iam:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "tf-cicd-codebuild-role-policy" {
    name = "tf-cicd-codebuild-role-policy"
    description = "codebuild policy"
    policy = data.aws_iam_policy_document.tf-cicd-codebuild-role-statement.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-role-attach" {
    policy_arn = aws_iam_policy.tf-cicd-codebuild-role-policy.arn
    role = aws_iam_role.tf-cicd-codebuild-role.id
}

resource "aws_iam_role" "tf-cicd-codedeploy-role" {
  name = "tf-cicd-codedeploy-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
}

/*
data "aws_iam_policy_document" "tf-cicd-codedeploy-role-statement" {
  statement {
    actions   = ["logs:*", "secretmanager:*", "iam:*", "s3:*", "codedeploy:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "tf-cicd-codedeploy-role-policy" {
    name = "tf-cicd-codedeploy-role-policy"
    description = "codedeploy policy"
    policy = data.aws_iam_policy_document.tf-cicd-codedeploy-role-statement.json
}
*/

resource "aws_iam_role_policy_attachment" "tf-cicd-codedeploy-role-attach" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
    role = aws_iam_role.tf-cicd-codedeploy-role.id
}
