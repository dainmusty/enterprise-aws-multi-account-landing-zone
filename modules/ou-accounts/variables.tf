variable "accounts" {
  type = map(object({
    name  = string
    email = string
    ou_id = string
  }))
}