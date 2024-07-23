# 1- local resource + provider aws 
# 2- security groups
# 3- remote-exec

locals {
    vpc_id              = "vpc-06955dff58950eef3"
    ssh_user            = "ubuntu"
    key_name            = "cloud1project"
    private_key_path    = "/Users/waseemnaseeven/Desktop/42_DevSecOps/24_CLOUD-1/cloud1project.pem" # To change
}

provider "aws" {
    region = "eu-west-3"
}

resource "aws_security_group" "wordpress" {
    name    = "wordpress_security_access"
    vpc_id  = local.vpc_id

    ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means every protocol
    cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_instance" "wordpress" {
    ami             = "ami-09d83d8d719da9808"
    instance_type   = "t2.micro"
    key_name        = local.key_name
    security_groups = [aws_security_group.wordpress.name]


    provisioner "remote-exec" {
        inline = [
            "mkdir /home/ubuntu/app",
        ]

    connection {
            type        = "ssh"
            user        = local.ssh_user
            private_key = file(local.private_key_path)
            host        = self.public_ip
        }
    }

    # Deplacement du projet a deployer
    provisioner "file" {
        source      = "/Users/waseemnaseeven/Desktop/42_DevSecOps/24_CLOUD-1/inception/" # Update path if needed
        destination = "/home/${local.ssh_user}/app"

    connection {
            type        = "ssh"
            user        = local.ssh_user
            private_key = file(local.private_key_path)
            host        = self.public_ip
        }   
    }

    # Install docker, docker-compose
    provisioner "remote-exec" {
        inline = [
                "sudo apt-get update",
                "sudo apt-get install -y ca-certificates curl gnupg",
                "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh",
                "sudo apt install -y make",
                "sudo usermod -aG docker ${local.ssh_user}",
        ]

        connection {
            type        = "ssh"
            user        = local.ssh_user
            private_key = file(local.private_key_path)
            host        = self.public_ip
        }
    }

    # Lancement du wordpress
    provisioner "remote-exec" {
        inline = [ 
            "cd /home/ubuntu/app",
            "sudo make"
        ]
    
        connection {
            type        = "ssh"
            user        = local.ssh_user
            private_key = file(local.private_key_path)
            host        = self.public_ip
        }
    }

    tags = {
        Name = "WordPress Website"
    }

}
