provider "aws" {
  region = "us-east-2"
}
#data "archive_file" "default" {
#  type        = "zip"
#  source_dir  = "${path.module}/builds/"
#  output_path = "${path.module}/builds/python.zip"
#}
locals {
  timestamp = timestamp()
}

resource "aws_kinesis_stream" "this"{
  name = "kinesis_stream_test"
  shard_count = 1
}

module "lambda" {
  source                  = "terraform-aws-modules/lambda/aws"
  version                 = "4.7.1"
  function_name           = "test-lambda"
  lambda_role             = "arn:aws:iam::912434042761:role/lambda_terraform_role"
  create_role             = false
  handler                 = "index.lambda_handler"
  runtime                 = "python3.8"
  create_package          = false
  local_existing_package  = "${path.module}/builds/python.zip"
  ignore_source_code_hash = true
  use_existing_cloudwatch_log_group = true
    }
resource "aws_lambda_event_source_mapping" "remind_me"{
  event_source_arn = aws_kinesis_stream.this.arn
  function_name = module.lambda.lambda_function_arn
  starting_position = "LATEST"
  filter_criteria {
    filter{
      pattern = jsonencode({
        "data" : {
          "_doc": {
            "dcmntRqst": {
              "dcmntSendDt": [{"numeric":[">", "${tonumber(time_static.test_value.unix)-5616000}"]}]
            }
          }
        }
        
      })
    }
    filter {
      pattern = jsonencode({
        "location": [{"anything-but":["rainy_day"]}]
        "Price": [ { "numeric": [ "<=", 100 ] } ]
      })
    }
  }
}

resource "time_static" "test_value"{
  triggers = {
    lambda_modified = local.timestamp
}
}

output "unix" {
  value = time_static.test_value.unix  
}
output "record_window"{
  value = timeadd(time_static.test_value.rfc3339, "-1560h")
}