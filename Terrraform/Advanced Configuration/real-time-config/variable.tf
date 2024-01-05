###############################################################################

# IN THIS variable.tf IS USED TO SPECIFIC VALUES OF INPUT VARIABLES IN main.tf 

###############################################################################

variable "ami" {
    description = "this is for ec2 ami id.."
    type = string

}

variable "instance-type" {
    description = "this is for ec2 instance type.."
    type = string
    default = "t2.micro"
  
}

variable "key-pair" {
    description = "this is for ec2 key pair file"
    type = string

}

variable "subnet-id" {
    description = "this is for ec2 subnet-id"
    type = string
  
}

variable "instance-name" {
    description = "this is for name of the ec2 instance"
    type = string
    default = "ec2-user"
  
}