provider "aws" {
  region = "us-east-2"
}
#data "archive_file" "default" {
#  type        = "zip"
#  source_dir  = "${path.module}/builds/"
#  output_path = "${path.module}/builds/python.zip"
#}
module "lambda" {
  source                  = "terraform-aws-modules/lambda/aws"
  version                 = "4.7.1"
  function_name           = "test-lambda"
  #lambda_role             = "arn:aws:iam::912434042761:role/lambda_terraform_role"
  #create_role             = false
  handler                 = "index.lambda_handle"
  runtime                 = "python3.8"
  create_package          = false
  local_existing_package  = "${path.module}/builds/python.zip"
  ignore_source_code_hash = true
  event_source_mapping ={for event in var.event_source:
      event["event_source_name"] => {
      event_source_arn = event["event_source_arn"]
    }

    }
}