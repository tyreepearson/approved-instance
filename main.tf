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

provider "hcp" {}
provider "aws" {
  region = var.region
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
    Name = "HelloWorld1"
  }
}

data "hcp_packer_iteration" "ubuntu" {
  bucket_name = "learn-packer-ubuntu"
  channel     = "production"
}

data "hcp_packer_image" "ubuntu_us_east_2" {
  bucket_name    = "learn-packer-ubuntu"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.ubuntu.ulid
  region         = "us-east-2"
}

resource "aws_instance" "app_server" {
  ami           = data.hcp_packer_image.ubuntu_us_east_2.cloud_image_id
  instance_type = "t2.micro"
  tags = {
    Name = "Learn-HCP-Packer"
  }
}
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.1"
  name = "ecs-module-6"
  # insert required variables here
}
# module "s3-webapp" {
#   source  = "app.terraform.io/tyreepearson/s3-webapp/aws"
#   name    = var.name
#   region  = var.region
#   prefix  = var.prefix
#   version = "1.0.0"
# }