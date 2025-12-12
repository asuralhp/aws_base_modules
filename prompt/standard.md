
	
	
required files :	
- data.tf (Optional)
- locals.tf (Optional)
- main.tf
- outputs.tf (Optional)
- variables.tf
  - description	
  - validation
  - // description and validation must be high detailed. refer to tencentcloud's one variables.tf (do not fully follow, because it is different cloud) 	
  - variable region Defaults to "ap-east-1"
  - hard code tags variable like this
    - ```
    variable "tags" {
      description = <<-EOT
      (Required) Key-value pairs for categorizing and organizing resources.
    
      Requirements:
      - Must be a map of string key-value pairs.
      - Useful for resource management, cost allocation, and access control.
      - Maximum 50 tags allowed.
    
      Example:
        tags = {
          Name    	= "my-vpc"
          Environment = "dev"
          Project 	= "website"
        }
      EOT
      type    	= map(string)
      validation {
      condition 	= length(keys(var.tags)) <= 50
      error_message = "The VPC tags must not exceed 50 tags."
      }
      validation {
      condition 	= contains(keys(var.tags), "Name")
      error_message = "A 'Name' tag must be set in the tags map."
      }
    }
    ```
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
  - (please references ./sample_README.md)
  - prompt used for this README """help me enrich and expand my readme explaining what the module does, how it works along with usage examples and if helpful, help the enduser understand what is created, and explain what is produced"""
  - (if not applicable, then skip it)
  - ```
    ## What Does This Module Do?
    ## How It Works
    ### Step-by-Step Flow
    ## Resources Created
    ## Usage Examples
    ## What Is Produced
    ## Inputs Explained
    ## Outputs Explained
    ## Requirements
    ## Provider Configuration
    ## Requirements
    ## Providers
    ## Modules
    ## Resources
    ## Inputs
    ```

