provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0dba2cb6798deb6d8"
  instance_type = "t2.micro"
  subnet_id	= "subnet-081282d993d9346b0"
}
