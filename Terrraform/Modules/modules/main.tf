
# WHILE USING MODULES WE ONLY NEED TO USE MAIN.TF AND PROVIDER.TF 

# NO NEED FOR SPECIFIC (VARIABLE.TF OUTPUTS.TF MAIN.TF) AND TERRAFORM.TFVARS
######################################################################################33


module "ec2-using-module-ec2" {

    
    # modules import from remote repo (eg: github repo)
    #source = "github.com/yuva19102003/terraform-demo-practice-modules/ec2"
    
    # modules import from the local repo
    source = "./modules/ec2"


    instance-name = "ec2-terraform-module"
    ami = "ami-0c7217cdde317cfec"
    instance-type = "t2.micro"
    key-pair = "demo"
    subnet-id = "subnet-00ebce3e294ab5556"
    
}

output "public-ip" {
    value = module.ec2-using-module-ec2.public-ip 
}

output "instance-id" {
  value = module.ec2-using-module-ec2.instance-id
}