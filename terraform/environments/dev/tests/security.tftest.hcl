mock_provider "aws" {}

run "security_group_rules" {
  command = apply

  module {
    source = "../../modules/security"
  }

  variables {
    name   = "test"
    vpc_id = "vpc-test"
  }

  assert {
    condition = (
      aws_security_group.alb.vpc_id == var.vpc_id &&
      aws_security_group.ecs.vpc_id == var.vpc_id &&
      aws_security_group.rds.vpc_id == var.vpc_id
    )
    error_message = "All security groups must belong to the supplied VPC."
  }

  assert {
    condition = (
      aws_vpc_security_group_ingress_rule.alb_http.security_group_id == aws_security_group.alb.id &&
      aws_vpc_security_group_ingress_rule.alb_http.cidr_ipv4 == "0.0.0.0/0" &&
      aws_vpc_security_group_ingress_rule.alb_http.ip_protocol == "tcp" &&
      aws_vpc_security_group_ingress_rule.alb_http.from_port == 80 &&
      aws_vpc_security_group_ingress_rule.alb_http.to_port == 80
    )
    error_message = "Only HTTP on port 80 should be allowed from the public IPv4 CIDR."
  }

  assert {
    condition = (
      aws_vpc_security_group_ingress_rule.ecs_from_alb.security_group_id == aws_security_group.ecs.id &&
      aws_vpc_security_group_ingress_rule.ecs_from_alb.referenced_security_group_id == aws_security_group.alb.id &&
      aws_vpc_security_group_ingress_rule.ecs_from_alb.ip_protocol == "tcp" &&
      aws_vpc_security_group_ingress_rule.ecs_from_alb.from_port == 5000 &&
      aws_vpc_security_group_ingress_rule.ecs_from_alb.to_port == 5000 &&
      aws_vpc_security_group_ingress_rule.rds_from_ecs.security_group_id == aws_security_group.rds.id &&
      aws_vpc_security_group_ingress_rule.rds_from_ecs.referenced_security_group_id == aws_security_group.ecs.id &&
      aws_vpc_security_group_ingress_rule.rds_from_ecs.ip_protocol == "tcp" &&
      aws_vpc_security_group_ingress_rule.rds_from_ecs.from_port == 5432 &&
      aws_vpc_security_group_ingress_rule.rds_from_ecs.to_port == 5432
    )
    error_message = "ECS and RDS ingress must use the specified source security groups and ports."
  }

  assert {
    condition = (
      aws_vpc_security_group_egress_rule.alb_to_ecs.security_group_id == aws_security_group.alb.id &&
      aws_vpc_security_group_egress_rule.alb_to_ecs.referenced_security_group_id == aws_security_group.ecs.id &&
      aws_vpc_security_group_egress_rule.alb_to_ecs.ip_protocol == "tcp" &&
      aws_vpc_security_group_egress_rule.alb_to_ecs.from_port == 5000 &&
      aws_vpc_security_group_egress_rule.alb_to_ecs.to_port == 5000 &&
      aws_vpc_security_group_egress_rule.ecs_ipv4.security_group_id == aws_security_group.ecs.id &&
      aws_vpc_security_group_egress_rule.ecs_ipv4.cidr_ipv4 == "0.0.0.0/0" &&
      aws_vpc_security_group_egress_rule.ecs_ipv4.ip_protocol == "-1"
    )
    error_message = "ALB and ECS egress must match the intended destinations."
  }

  assert {
    condition = (
      output.alb_security_group_id == aws_security_group.alb.id &&
      output.ecs_security_group_id == aws_security_group.ecs.id &&
      output.rds_security_group_id == aws_security_group.rds.id
    )
    error_message = "The module must expose all three security group IDs."
  }
}
