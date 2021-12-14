variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_TOKEN_SESSION" {}
variable "AWS_REGION" { 
default = "us-east-1" 
}
variable "WIN_AMIS" {
type = map
default = { 
us-east-1 = "ami-0b17e49efb8d755c3"
us-west-2 = "ami-9f5efbff"
eu-west-1 = "ami-0f26101934dec146b" 
} 
} 
variable "PATH_TO_PRIVATE_KEY" { default = "mykey" } 
variable "PATH_TO_PUBLIC_KEY" { default = "mykey.pub" }
variable "INSTANCE_USERNAME" { default = "admin" } 
variable "INSTANCE_PASSWORD" { }