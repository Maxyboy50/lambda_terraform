provider "aws" {
  region = "us-east-1"
}
#data "archive_file" "default" {
#  type        = "zip"
#  source_dir  = "${path.module}/builds/"
#  output_path = "${path.module}/builds/python.zip"
#}
module "lambda" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "4.7.1"
  function_name          = "test-lambda"
  handler                = "index.lambda_handler"
  runtime                = "python3.8"
  create_package         = false
  local_existing_package = "${path.module}/builds/python.zip"
}

