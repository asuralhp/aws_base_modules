<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | ~> 1.82.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | ~> 1.82.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_subnet.this](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_availability_zone"></a> [subnet\_availability\_zone](#input\_subnet\_availability\_zone) | (Required) The availability zone where the subnet resides.<br/><br/>Requirements:<br/>- Must be a valid availability zone string in the region.<br/>- Should be chosen based on your service deployment strategy.<br/>- Cannot be changed after creation (ForceNew).<br/>- Used to specify the geographic location for the subnet.<br/>- ap-guangzhou-3, ap-guangzhou-6, ap-guangzhou-7, ap-hongkong-1, ap-hongkong-2, ap-hongkong-3 are supported zones.<br/><br/>Example: "ap-guangzhou-3" | `string` | n/a | yes |
| <a name="input_subnet_cdc_id"></a> [subnet\_cdc\_id](#input\_subnet\_cdc\_id) | (Optional) The CDC instance ID.<br/><br/>Requirements:<br/>- Can be null or a valid CDC instance ID string.<br/>- Should reference an existing CDC instance in your account.<br/>- Cannot be changed after creation (ForceNew).<br/>- Used to associate the subnet with a specific CDC instance.<br/><br/>Example: "cdc-12345678" | `string` | `null` | no |
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | (Required) The network CIDR block of the subnet.<br/><br/>Requirements:<br/>- Must be a valid CIDR block within the VPC CIDR range.<br/>- Should not overlap with other subnets in the same VPC.<br/>- Cannot be changed after creation (ForceNew).<br/>- Used to define the IP address range for the subnet.<br/><br/>Example: "10.0.1.0/24" | `string` | n/a | yes |
| <a name="input_subnet_is_multicast"></a> [subnet\_is\_multicast](#input\_subnet\_is\_multicast) | (Optional) Whether to enable multicast functionality.<br/><br/>Requirements:<br/>- Must be a boolean value.<br/>- When true, multicast functionality is enabled for the subnet.<br/>- When false, multicast functionality is disabled for the subnet.<br/>- Used to control multicast traffic within the subnet.<br/><br/>Example: true | `bool` | `true` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | (Required) The name of the subnet to be created.<br/><br/>Requirements:<br/>- Must be a valid subnet name string.<br/>- Should be descriptive and meaningful for identification.<br/>- Used to identify and reference the subnet in Tencent Cloud.<br/>- Must follow the naming pattern: only lowercase letters, numbers, and hyphens ([a-z0-9-]).<br/><br/>Example: "prod-web-subnet" | `string` | n/a | yes |
| <a name="input_subnet_route_table_id"></a> [subnet\_route\_table\_id](#input\_subnet\_route\_table\_id) | (Optional) The route table ID that the subnet should be associated with.<br/><br/>Requirements:<br/>- Can be null or a valid route table ID string.<br/>- Should reference an existing route table in your account.<br/>- If not provided, the default route table will be used.<br/>- Used to control routing behavior for the subnet.<br/><br/>Example: "rtb-12345678" | `string` | `null` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | (Requried) Key-value pairs for categorizing and organizing resources.<br/><br/>Requirements:<br/>- Must be a map of string key-value pairs.<br/>- Useful for resource management, cost allocation, and access control.<br/>- Default subnet\_tags include department, project, and owner information.<br/><br/>Example: {<br/>  hkjc:account-name = "finance-team-member"<br/>  hkjc:cost-centre = "546.000.626.00"<br/>} | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) The ID of the associated VPC.<br/><br/>Requirements:<br/>- Must be a valid VPC ID string.<br/>- Should reference an existing VPC in your account.<br/>- Cannot be changed after creation (ForceNew).<br/>- Used to specify which VPC the subnet belongs to.<br/><br/>Example: "vpc-12345678" | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_availability_zone"></a> [subnet\_availability\_zone](#output\_subnet\_availability\_zone) | Availability zone where the subnet resides |
| <a name="output_subnet_cidr_block"></a> [subnet\_cidr\_block](#output\_subnet\_cidr\_block) | Subnet CIDR block |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | Subnet ID |
| <a name="output_subnet_is_multicast"></a> [subnet\_is\_multicast](#output\_subnet\_is\_multicast) | Whether subnet multicast is enabled |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Subnet name |
<!-- END_TF_DOCS -->