packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1.0"
    }
  }
}

########################
# Docker Source
########################
source "docker" "nginx" {
  image  = "nginx:latest"
  commit = true
}

########################
# Build
########################
build {
  name    = "packer-learning-docker"
  sources = ["source.docker.nginx"]

  # Copy index.html into nginx container
  provisioner "file" {
    source      = "out/index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  # Optional validation
  provisioner "shell" {
    inline = [
      "nginx -v",
      "ls -l /usr/share/nginx/html/index.html"
    ]
  }

  ########################
  # Post Processors
  ########################
  post-processor "docker-tag" {
    repository = "packer-learning-docker"
    tag        = ["{{timestamp}}"]
  }

  post-processor "manifest" {
    output     = "output/manifest.json"
    strip_path = true
  }
}
