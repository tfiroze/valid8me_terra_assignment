provider "aws" {
  region = "eu-west-1"  
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" 
}

resource "aws_security_group" "terrasecurity" {
  name        = "terrasecurity"
  description = "Security group for SSH and HTTP access"
  vpc_id            = aws_vpc.my_vpc.id

  // Inbound rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  // Inbound rule for HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }

  // Outbound rule (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"  
  availability_zone = "eu-west-1a"   
  map_public_ip_on_launch = true  # Enable public IP assignment
  tags = {
    Name = "public-subnet-1"
  }
  
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"  
  availability_zone = "eu-west-1a"   
  map_public_ip_on_launch = true  # Enable public IP assignment
  tags = {
    Name = "public-subnet-2"
  }
}

# private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24" 
  availability_zone = "eu-west-1a"   
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24" 
  availability_zone = "eu-west-1a"   
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.my_vpc.id}"
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.my_vpc.id}"
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_instance" "valid8me_instance" {
  ami             = "ami-0323d48d3a525fd18"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.terrasecurity.id]
  key_name        = "terraformaws"

  user_data = <<-EOF
            #!/bin/bash
            # Update package index and install nginx
            sudo yum update -y
            sudo amazon-linux-extras install nginx1.12 -y

            # Start nginx and enable it to start on boot
            sudo systemctl start nginx
            sudo systemctl enable nginx
            EOF

}
output "instance_public_ip" {
    value = aws_instance.valid8me_instance.public_ip
}

# output "terraform_errors" {
#   value = jsondecode(file("${path.module}/terraform.tfstate")).errors
# }


# output "instance_logs" {
#   value = aws_instance.valid8me_instance.user_data # Or any other relevant information
# }