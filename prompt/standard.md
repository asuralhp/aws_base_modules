
	
	
required files :	
- data.tf
- locals.tf
- main.tf
- output.tf (Optional)
- variables.tf
  - description	
  - validation
  - // description and validation must be high detailed. refer to tencentcloud's one variables.tf (do not fully follow, because it is different cloud) 	
- version.tf
  - terraform {
      required_version = ">= 1.10.4"

      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 6.0.0"
        }
      }
    }
- tests/main.tftest.hcl
- README.md 
  - (please references samples/sample_README.md)
  - prompt used for this README """help me enrich and expand my readme explaining what the module does, how it works along with usage examples and if helpful, help the enduser understand what is created, and explain what is produced
  """
