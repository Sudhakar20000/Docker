resource "aws_security_group" "web_sg" {
  name        = "docker-sg"
   vpc_id      = data.aws_vpc.default.id 
 # Links to your VPC

  tags = {
    Name = "Docker-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # "-1" maps to all protocols
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.joindevops.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true
  user_data = templatefile("${path.module}/docker.sh.tftpl", {
    partition_number = 4
    extend_size = 30
  })
   root_block_device {
    volume_size           = 50      # Size of the volume in GiB
    volume_type           = "gp3"   # General Purpose SSD (gp3 is recommended)

    tags = {
            Name = "Docker"
  }
   }

  tags = {
    
        Name = "Docker"
  }
    
}


