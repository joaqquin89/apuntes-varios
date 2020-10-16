provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}

resource "aws_iam_user" "lb" {
   name = var.usernumber
   path = "/system/"
}
