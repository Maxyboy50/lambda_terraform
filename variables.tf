variable "event_source"{
    type = map(object({
        event_source_name = string
        event_source_arn = string
        starting_position = string

    })
)
}