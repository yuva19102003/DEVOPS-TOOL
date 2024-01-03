provider "aws" {
    region = "us-east-1"
  
}

resource "aws_instance" "demo" {
    ami = "ami-0c7217cdde317cfec"
    instance_type = "t2.micro"
    key_name = "demo"
    subnet_id = "subnet-00ebce3e294ab5556"
    tags = {
      Name = "terraform-demo"
    }
  
}