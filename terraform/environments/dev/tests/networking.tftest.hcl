mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = ["eu-west-2a", "eu-west-2b"]
    }
  }
}

run "network_topology" {
  command = apply

  module {
    source = "../../modules/networking"
  }

  variables {
    name = "test"
  }

  assert {
    condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
    error_message = "The VPC must use the requested CIDR."
  }

  assert {
    condition = (
      aws_subnet.public[*].cidr_block == ["10.0.1.0/24", "10.0.2.0/24"] &&
      aws_subnet.application[*].cidr_block == ["10.0.11.0/24", "10.0.12.0/24"] &&
      aws_subnet.database[*].cidr_block == ["10.0.21.0/24", "10.0.22.0/24"]
    )
    error_message = "Each subnet tier must use the requested CIDRs."
  }

  assert {
    condition = (
      aws_subnet.public[*].availability_zone == ["eu-west-2a", "eu-west-2b"] &&
      aws_subnet.application[*].availability_zone == ["eu-west-2a", "eu-west-2b"] &&
      aws_subnet.database[*].availability_zone == ["eu-west-2a", "eu-west-2b"]
    )
    error_message = "Each subnet tier must span both availability zones."
  }

  assert {
    condition = (
      one(aws_route_table.public.route).gateway_id == aws_internet_gateway.this.id &&
      one(aws_route_table.public.route).cidr_block == "0.0.0.0/0" &&
      one(aws_route_table.application.route).nat_gateway_id == aws_nat_gateway.this.id &&
      one(aws_route_table.application.route).cidr_block == "0.0.0.0/0" &&
      length(aws_route_table.database.route) == 0 &&
      aws_nat_gateway.this.subnet_id == aws_subnet.public[0].id
    )
    error_message = "Public, application, and database routes must use the intended gateways."
  }

  assert {
    condition = (
      alltrue([for i in range(2) : aws_route_table_association.public[i].subnet_id == aws_subnet.public[i].id && aws_route_table_association.public[i].route_table_id == aws_route_table.public.id]) &&
      alltrue([for i in range(2) : aws_route_table_association.application[i].subnet_id == aws_subnet.application[i].id && aws_route_table_association.application[i].route_table_id == aws_route_table.application.id]) &&
      alltrue([for i in range(2) : aws_route_table_association.database[i].subnet_id == aws_subnet.database[i].id && aws_route_table_association.database[i].route_table_id == aws_route_table.database.id]) &&
      toset(aws_db_subnet_group.this.subnet_ids) == toset(aws_subnet.database[*].id)
    )
    error_message = "Subnet associations and the database subnet group must use the correct subnets."
  }

  assert {
    condition = (
      output.vpc_id == aws_vpc.this.id &&
      output.public_subnet_ids == aws_subnet.public[*].id &&
      output.application_subnet_ids == aws_subnet.application[*].id &&
      output.database_subnet_ids == aws_subnet.database[*].id &&
      output.db_subnet_group_name == aws_db_subnet_group.this.name
    )
    error_message = "The module outputs must expose the created network resources."
  }
}
