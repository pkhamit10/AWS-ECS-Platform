module "networking" {
  source = "../../modules/networking"

  name = "${var.project_name}-${var.environment}"
}

module "security" {
  source = "../../modules/security"

  name   = "${var.project_name}-${var.environment}"
  vpc_id = module.networking.vpc_id
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
