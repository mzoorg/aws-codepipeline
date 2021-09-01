resource "aws_codebuild_project" "tf-build" {
    name = "tf-build"
    description = "pipeline for boxfuse"
    service_role = aws_iam_role.tf-cicd-codebuild-role.arn

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/standard:1.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"
    }

    source {
        type = "CODEPIPELINE"
        buildspec = file("buildspec/mybuildspec.yml")
    }
}

resource "aws_codepipeline" "tf-main-codepipeline" {
  name     = "tf-main-codepipeline"
  role_arn = aws_iam_role.tf-cicd-pipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.b.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connectro_credentials
        FullRepositoryId = "mzoorg/boxfuse-orig"
        BranchName       = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "tf-build"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName =  "my-application"
        DeploymentGroupName = "my-deployment-group"
        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName      = "MyStack"
        TemplatePath   = "build_output::sam-templated.yaml"
      }
    }
  }
}