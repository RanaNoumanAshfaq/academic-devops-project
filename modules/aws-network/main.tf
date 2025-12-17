# 1. The Virtual Private Cloud (The "House")
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "${var.project_name}-vpc" }
}

# 2. Internet Gateway (The "Front Door" for Public Subnets)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-igw" }
}

# 3. Public Subnets (For Load Balancers / Things that need direct internet)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1) # e.g., 10.0.1.0/24
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${var.project_name}-public-1"
    "kubernetes.io/role/elb" = "1" # Required for EKS to find this subnet
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 2) # e.g., 10.0.2.0/24
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${var.project_name}-public-2"
    "kubernetes.io/role/elb" = "1"
  }
}

# 4. Private Subnets (For Worker Nodes / Database - Safer!)
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 3) # e.g., 10.0.3.0/24
  availability_zone       = "us-east-1a"
  tags = {
    Name                              = "${var.project_name}-private-1"
    "kubernetes.io/role/internal-elb" = "1" # Required for EKS internal LBs
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 4) # e.g., 10.0.4.0/24
  availability_zone       = "us-east-1b"
  tags = {
    Name                              = "${var.project_name}-private-2"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# 5. Route Table for Public Subnets (Direct traffic to Internet Gateway)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project_name}-public-rt" }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# 6. Route Table for Private Subnets (Local traffic only for now)
# NOTE: In production, you would add a "NAT Gateway" here so private nodes 
# can download updates without being exposed. We omit it to save costs.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-private-rt" }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}