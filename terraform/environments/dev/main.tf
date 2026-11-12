module "networking" {
  source = "../../modules/networking"

  name = "${var.project_name}-${var.environment}"
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
