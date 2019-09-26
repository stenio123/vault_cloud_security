provider "aws" {
  # AWS_ACCESS_KEY_ID
  # AWS_SECRET_ACCESS_KEY
  # AWS_DEFAULT_REGION
}

data "template_file" "vault_init" {
  template = file("${path.cwd}/vault_init.sh.tpl")
}

resource "aws_instance" "ubuntu" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  user_data         = data.template_file.vault_init.template
  key_name          = var.aws_key_name
  security_groups   = [aws_security_group.vault_sg.name]

  tags = {
    Name  = var.name
    ttl   = var.ttl
    owner = var.owner
  }
}

resource "aws_security_group" "vault_sg" {
  name        = "vault_sg"
  description = "Allow inbound traffic"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "vault_sg"
    ttl   = var.ttl
    owner = var.owner
  }
}

