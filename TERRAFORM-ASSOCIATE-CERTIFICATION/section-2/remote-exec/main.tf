provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = "i"
}

resource "aws_instance" "myec2" {
   ami = "ami-082b5a644766e0e6f"
   instance_type = "t2.micro"

   provisioner "remote-exec" {
      inline  = [
          "sudo amazon-linux-extras install -y nginx1.12",
          "sudo systemctl start nginx"
      ]
   }

   connection {
       type = "ssh"
       user = "ec2-user"
       private_key = file()

   }
}

resource "aws_eip" "lb" {
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}


resource "aws_security_group" "allow_tls" {
  name        = "kplabs-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.lb.public_ip}/32"]

#    cidr_blocks = [aws_eip.lb.public_ip/32]
  }
}