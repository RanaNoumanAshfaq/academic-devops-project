# 1. DB Subnet Group: Tells RDS "You must live in these specific subnets"
resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnets # Crucial: Put DB in private network

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

# 2. Security Group: The Firewall for the DB
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow inbound traffic from App only"
  vpc_id      = var.vpc_id

  # Allow traffic only on port 3306 (MySQL)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow traffic from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. The Database Instance (Optimized for Free Tier)
resource "aws_db_instance" "default" {
  allocated_storage      = 20               # Max 20GB for Free Tier
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"            # Use a stable version
  instance_class         = "db.t3.micro"    # Free Tier eligible
  identifier             = "${var.project_name}-db"
  username               = "adminuser"
  password               = "adminpassword123" # In production, use Secrets Manager!
  
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  skip_final_snapshot    = true             # IMPORTANT: Prevents hang on destroy
  publicly_accessible    = false            # Security: No internet access
  multi_az               = false            # False = Free Tier (True costs $$)
}