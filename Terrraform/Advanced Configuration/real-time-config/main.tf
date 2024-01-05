##########################################################

# THIS IS THE main.tf FOR MENTIONING THE RESOURCES WE NEED

##########################################################



resource "aws_instance" "ec2" {
    
    ami = var.ami
    instance_type = var.instance-type
    subnet_id = var.subnet-id
    key_name = var.key-pair

    tags = {
      Name = var.instance-name
    }
  
}