###############################################################################

# THIS outputs.tf IS FOR DISPLAYING THE INFORMATION WHICH FETCH FROM THE CLOUD

###############################################################################

output "public-ip" {
    description = "this will show the public ip address of the ec2 instances"
  value = aws_instance.ec2.public_ip
}