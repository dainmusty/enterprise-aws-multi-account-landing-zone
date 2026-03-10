# terraform {
#   backend "s3" {
#     bucket  = "your-bucket-name"
#     key     = "dev/terraform.tfstate" # Path within the bucket
#     region  = "us-east-1"
#     encrypt = true
#     #use_lockfile = true
#     # Native s3 locking!
#   }
# }
