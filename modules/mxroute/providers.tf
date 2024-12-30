terraform {
  #backend "s3" {
  #encrypt = true
  ## details are provided in the backend.hcl file; use `init
  ## -backend-condig backend.hcl` to initialize
  #}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}


