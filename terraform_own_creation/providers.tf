terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }


    linode = {
      source  = "linode/linode"
      version = "2.9.5"
    }

  }
}
