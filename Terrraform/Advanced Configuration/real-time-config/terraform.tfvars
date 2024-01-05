##############################################################################

# IN THIS terraform.tfvars WILL BE USED TO SPECFY THE VALUES FOR THE VARIABLES

##############################################################################

# name of the instance:
instance-name = "terraform-ec2"

# ami id for the ec2 instance:
ami = "ami-0c7217cdde317cfec"

# instance type for ec2
instance-type = "t2.micro"

# key pair fo the ec2
key-pair = "demo"

# subnet id of the vpc for the ec2
subnet-id = "subnet-00ebce3e294ab5556"