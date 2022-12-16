variable "event_source"{
    type = list(object({
        event_source_name = string
        event_source_arn = string
        starting_position = string

    })
)
}