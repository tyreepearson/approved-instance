terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
        random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  cloud {
    organization = "tyreepearson"
    workspaces {
      
      name = "standard-demo"
    }
  }

}

provider "aws" {
  region = var.region
}

module "module" {
  source  = "app.terraform.io/tyreepearson/module/aws"
  name    = var.name
  region  = var.region
  prefix  = var.prefix
  version = "1.0.0"
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type =var.instance_size

  tags = {
    Name = "HelloWorld"
  }
}
module "s3-webapp" {
  source  = "app.terraform.io/tyreepearson/s3-webapp/aws"
  name    = var.name
  region  = var.region
  prefix  = var.prefix
  version = "1.0.0"
}
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.1"
  name = "ecs-module-3"
  # insert required variables here
}