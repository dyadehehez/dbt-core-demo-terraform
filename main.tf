provider "aws" {
  region = "ap-southeast-1"  # Replace with your desired region
  access_key = var.iam_access_key[0]
  secret_key = var.iam_access_key[1]
}

################################################################################
# S3
################################################################################

resource "aws_s3_bucket" "orderlogs_s3" {
  bucket = var.my_s3_bucket_name
  tags = {
    name = "rssl"
    }
}

################################################################################
# ARN Role Policy
################################################################################

/*
data "aws_iam_policy_document" "rssl_inline_policy" {
  statement {
    actions   = ["redshift:*"]
    resources = ["*"]
  }
}
*/
resource "aws_iam_role" "rssl_role" {
  name = "rssl_test_role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "redshift.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
 /* inline_policy {
    name   = "policy-for-rssl"
    policy = data.aws_iam_policy_document.rssl_inline_policy.json
  }*/
  tags = {
    tag-key = "rssl"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach-rssl" {
  role       = aws_iam_role.rssl_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess"
}
resource "aws_iam_role_policy_attachment" "test-attach-rssl2" {
  role       = aws_iam_role.rssl_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "test-attach-rssl3" {
  role       = aws_iam_role.rssl_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

################################################################################
# Redshift Setup
################################################################################

resource "aws_redshiftserverless_namespace" "rssl-namespace" {
  namespace_name = var.rssl_config[0]
  admin_user_password = var.rssl_config[1] #password of the administrator first db in namespace
  admin_username = var.rssl_config[2] #admin of the administrator first db in namespace'
  db_name = var.rssl_config[3] #database name
  iam_roles = [aws_iam_role.rssl_role.arn]
  default_iam_role_arn = aws_iam_role.rssl_role.arn

  tags = {
    name = "rssl"
    }
}

resource "aws_redshiftserverless_workgroup" "rssl-workgroup" {
  namespace_name = aws_redshiftserverless_namespace.rssl-namespace.namespace_name
  workgroup_name = "workgroup-rssl-test"
  base_capacity = var.rpu_capacity #rpu

  #security_group_ids
  #subnet_ids

  tags = {
    name = "rssl"
    }
}

