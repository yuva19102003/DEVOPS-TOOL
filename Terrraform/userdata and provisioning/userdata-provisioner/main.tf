provider "aws" {
    region = "us-east-1"
}


resource "aws_instance" "example" {

    # ubuntu ec2 ami id
    ami = "ami-0c7217cdde317cfec"
    
    # t2.micro instance type for ec2
    instance_type = "t2.micro"
    
    #key pair for the ec2
    key_name = "demo"

    #subnet for the ec2
    subnet_id = "subnet-00ebce3e294ab5556" 
    
    #userdata for the ec2
    /*user_data = file("userdata.sh")*/
    

    # name of the instance
    tags = {
      Name = "userdata-method"
    }

    connection {
      type = "ssh"
      user = "ubuntu"
      password = ""
      private_key = file("demo.pem")
      host = self.public_ip
    }

    provisioner "file" {
        source = "userdata.sh"
        destination = "/home/ubuntu/userdata.sh" 
      
    }

    provisioner "remote-exec" {
      inline = [
        "sudo apt update -y",
        "sudo apt install docker.io -y",
        "cd /home/ubuntu",
        "sudo docker pull yuva19102003/apache:latest",
        "sudo docker run -d -p 8080:80 --name web_server yuva19102003/apache:latest"

       ]
    
    }
    provisioner "local-exec" {
            command = "echo http://${self.public_ip}:8080 >> website-link.txt"

      
    }

    
}
/*
output "website" {
  value = aws_instance.example.public_ip
  
}
*/


