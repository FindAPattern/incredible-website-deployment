resource "aws_s3_bucket" "artifacts" {
  bucket = "private-website-artifacts"
  acl    = "private"
}

resource "aws_codebuild_project" "build" {
  name = "incredible-website-project"
  description = "Builds the client files for the incredible-website environment."
  build_timeout = "5"
  service_role = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:2.0"
    type = "LINUX_CONTAINER"

    environment_variable {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.artifacts.bucket
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}
