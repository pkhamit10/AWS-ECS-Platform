terraform {
  backend "s3" {
    bucket = "pk-ithead-korb"
    key    = "clariness-ecs-platform/dev/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
  }
}