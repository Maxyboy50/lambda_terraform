event_source = {
  "kinesis-stream" = {
    event_source_name = "sms-stream-dev"
    event_source_arn  = "asdfasdf"
    starting_position = "LATEST"
  }
  "sms-stream" = {
    event_source_name = "kinesis-stream-dev"
    event_source_arn  = "asdfasdf"
    starting_position = "LATEST"
  }
}