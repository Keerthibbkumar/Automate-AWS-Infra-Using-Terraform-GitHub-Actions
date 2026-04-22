# terraform {
#   backend "s3" {
#     bucket = "mysupremo"
#     key = "terraform/state/main/terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "terraform-locks"
#   }
# }