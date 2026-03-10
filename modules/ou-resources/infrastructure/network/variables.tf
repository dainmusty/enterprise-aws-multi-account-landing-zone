# variable "flow_logs_role_arn" {
#   type = string
#   description = "flow logs role arn"
# }

variable "central_log_bucket_arn" {
  type = string
  description = "central log bucket arn"
}

variable "dev_account_id" {
  type = string
  description = "dev account id"
} 

variable "dev_vpc_id" {
  type = string
  description = "dev vpc id"
}
