base_name = "terraform-aws-base-module"
resource_name = "ec2_subnet_cidr_reservation"
resource_link = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_subnet_cidr_reservation"
folder_name = base_name + "-" + resource_name


- create folder with name folder_name
- reference how samples work from ./samples/
- following the standard from ./prompt/standard.md
- start to write tf files and others for aws base module of full resource_name
- create folder "tests" inside folder_name
- write main.tftest.hcl for unit test like other base module does
- the resouce link : resource_link
