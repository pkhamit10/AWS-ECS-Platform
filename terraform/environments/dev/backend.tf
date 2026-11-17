terraform {
  backend "s3" {
    bucket  = "clariness-bk"
    key     = "clariness-ecs-platform/dev/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}
