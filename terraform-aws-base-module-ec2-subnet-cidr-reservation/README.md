# terraform-aws-base-module-ec2_subnet_cidr_reservation

Module to manage `aws_ec2_subnet_cidr_reservation` resources.

Usage example:

```hcl
module "cidr_reservation" {
  source    = "./terraform-aws-base-module-ec2_subnet_cidr_reservation"

  subnet_id  = "subnet-0123456789abcdef0"
  cidr_block = "10.0.1.0/28"
  description = "reserved for test instances"

  tags = {
    Name = "test-reservation"
  }
}
```

Inputs
------
- `region` - (Optional) Region where resource should be managed. Defaults to provider region.
- `subnet_id` - (Required) Subnet id where CIDR is reserved.
- `cidr_block` - (Required) IPv4 CIDR to reserve in the subnet.
- `description` - (Optional) Human-readable description of the reservation.
- `tags` - (Optional) Map of tags to apply.

Outputs
-------
- `aws_ec2_subnet_cidr_reservation` - All attributes of the resource.
- `aws_ec2_subnet_cidr_reservation_id` - ID of the created reservation.

Notes
-----
- The module validates the CIDR value and the `subnet_id` format where possible, but
  cannot guarantee the CIDR will be accepted by AWS (it must be within the subnet range).
