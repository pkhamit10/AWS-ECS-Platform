module "networking" {
  source = "../../modules/networking"

  name = "${var.project_name}-${var.environment}"
}

module "security" {
  source = "../../modules/security"

  name   = "${var.project_name}-${var.environment}"
  vpc_id = module.networking.vpc_id
}

module "ecr" {
  source = "../../modules/ecr"

  name = "${var.project_name}-${var.environment}"
}

module "alb" {
  source = "../../modules/alb"

  name              = "${var.project_name}-${var.environment}"
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "application_subnet_ids" {
  value = module.networking.application_subnet_ids
}

output "database_subnet_ids" {
  value = module.networking.database_subnet_ids
}

output "db_subnet_group_name" {
  value = module.networking.db_subnet_group_name
}

output "alb_security_group_id" {
  value = module.security.alb_security_group_id
}

output "ecs_security_group_id" {
  value = module.security.ecs_security_group_id
}

output "rds_security_group_id" {
  value = module.security.rds_security_group_id
}
