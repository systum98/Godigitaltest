terraform{
      required_providers{
       aws={
       source ="hashicorp/aws"
       version ="~>5.47.0"
}
}
      required_version = "~>1.8.2"
}
provider "aws" {
  region = "us-east-1"  
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "godigital"
 
  tags = {
    Name = "shubhamtest"
  }
}       
resource "aws_s3_object" "my_object" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "shubhamtest"
  source = "/home/shubham/shubhamtest.html"
}

# Define VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Define Subnets
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
}

# Define Security Group
resource "aws_security_group" "db" {
  name        = "db_security_group"
  description = "Security group for the RDS database"

  # Allow inbound MySQL traffic from anywhere
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "my_database" {
  identifier       = "my-db"
  allocated_storage    = 20
  storage_type     = "gp2"
  engine           = "mysql"
  engine_version   = "5.7"
  instance_class   = "db.t3.micro"
 
  username         = "admin"
  password         = "shubham123"  
  skip_final_snapshot = false
  final_snapshot_identifier = "my-final-snapshot"

   
  # Security group settings
  vpc_security_group_ids     = [aws_security_group.db.id]




  # Publicly accessible
  publicly_accessible        = true
}

# Define RDS Subnet Group
resource "aws_db_subnet_group" "db" {
  name        = "db_subnet_group"
  description = "Subnet group for the RDS database"

  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}


resource "aws_ecr_repository" "my_ecr_repo" {
  name = "my-ecr-repo"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.my_ecr_repo.repository_url
}




