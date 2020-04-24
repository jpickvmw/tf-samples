/*
This is a Sample Simple AWS Template
*/
// this is comment
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

// variable "this is a comment and the parser should ignore it" {}

provider "aws" { // Comment to be ignored
  access_key = "var.access_key"
  secret_key = "var.secret_key" //comment ignore
  region = "var.aws_region"
}

data "aws_ami" "alx" {
  most_recent = true
  owners = ["amazon"]
  value = data.0
  value2 = data[0]
  filters {}
}

//parser should ignore
resource "aws_instance" "ex" { // comment here
  ami = "data.aws_ami.alx.id"
  instance_type = "t2.micro"
}

output "aws_public_ip" {
  value = "aws_instance.ex.public_dns"
}
