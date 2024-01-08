provider "aws" {
    region = "us-east-1"
}

provider "vault" {
    address = "http://18.208.203.97:8200"
    skip_child_token = true

    auth_login {
      path = "auth/approle/login"

      parameters = {
        role_id = "c5a2115a-a6a2-8fa3-73ef-52f8ead5f610"
        secret_id = "e7580980-675c-d106-6301-9e82146e9796"
      }
    }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

resource "aws_instance" "demo" {
    ami = "ami-0c7217cdde317cfec"
    instance_type = "t2.micro"
    key_name = "demo"
    subnet_id = "subnet-00ebce3e294ab5556"
    tags = {
      secret = data.vault_kv_secret_v2.example.data["api_key"]
    }

}