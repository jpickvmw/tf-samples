provider "aws" { // Comment to be ignored
  region = "us-west-1"
}

provider "aws" {
  alias = "aliasOne"
  region = "us-east-1"
}

provider "aws" {
  alias = "aliasTwo"
  region = "us-west-1"
}