variable "accounts" {
  type = map(object({
    name            = string
    email           = string
    ou              = string
    owner           = string
    environment     = string
    group           = string
    permission_sets = list(string)
  }))
}