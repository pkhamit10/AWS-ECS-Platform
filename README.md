# AWS ECS Platform

The dev network spans two availability zones. Place the ALB in the public
subnets, ECS tasks in the private application subnets, and RDS in the isolated
database subnets. The database subnets have no default internet route.

Both application subnets share one NAT gateway to reduce cost. This incurs NAT
gateway and data processing charges and is an availability trade-off: if the
NAT gateway or its availability zone fails, outbound internet access from both
application subnets is affected. Traffic from the other availability zone can
also incur cross-AZ data transfer charges.

To check and deploy the dev network:

```sh
cd terraform/environments/dev
terraform init
terraform validate
terraform test  # Terraform 1.7 or later; uses a mock AWS provider
terraform plan -out=dev.tfplan
terraform apply dev.tfplan
```

The AWS identity and its permissions boundary must allow the required EC2
networking and RDS subnet group operations, as well as access to the S3 state
backend. Review the plan before applying; creating a NAT gateway incurs charges.