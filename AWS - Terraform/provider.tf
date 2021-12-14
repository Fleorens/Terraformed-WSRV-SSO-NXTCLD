provider "aws" { 
access_key = "${var.AWS_ACCESS_KEY}"
secret_key = "${var.AWS_SECRET_KEY}"
token = "${var.AWS_TOKEN_SESSION}"
region = "${var.AWS_REGION}" 
}
 
terraform {
  required_version = ">= 0.12"
}