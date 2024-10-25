# Data source to fetch Debian 10 AMI
data "aws_ami" "debian10" {
  most_recent = true
  owners      = ["136693071363"] # Debian AMI owner ID

  filter {
    name   = "name"
    values = ["debian-10-amd64-*"]
  }
}

# Generate SSH key pair
resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-generated-key"
  public_key = tls_private_key.generated_key.public_key_openssh
}

# g3.4xlarge instance
resource "aws_instance" "g3_instance" {
  ami               = data.aws_ami.debian10.id
  instance_type     = "g3.4xlarge"
  availability_zone = var.availability_zone
  key_name          = aws_key_pair.generated_key.key_name

  tags = {
    Name = "g3-4xlarge-instance"
  }
}

# p3.2xlarge instance
resource "aws_instance" "p3_instance" {
  ami               = data.aws_ami.debian10.id
  instance_type     = "p3.2xlarge"
  availability_zone = var.availability_zone
  key_name          = aws_key_pair.generated_key.key_name

  tags = {
    Name = "p3-2xlarge-instance"
  }
}

# p3.2xlarge spot instance (using instance_market_options)
resource "aws_instance" "p3_spot_instance" {
  ami               = data.aws_ami.debian10.id
  instance_type     = "p3.2xlarge"
  availability_zone = var.availability_zone
  key_name          = aws_key_pair.generated_key.key_name

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price = var.spot_price
    }
  }

  tags = {
    Name = "p3-2xlarge-spot-instance"
  }
}
