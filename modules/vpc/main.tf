# Main VPC and Subnets Configuration
resource "aws_vpc" "main-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.tag_name}-vpc"
    Project_name = var.tag_name
  }
}

# Public Subnets Configuration
resource "aws_subnet" "subnet_nva_public" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.subnet_nva_public
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.tag_name}-subnet-nva-public"
    Project_name = var.tag_name
  }
}
resource "aws_subnet" "subnet_nva_private" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.subnet_nva_private
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.tag_name}-subnet-nva-private"
    Project_name = var.tag_name
  }
}

resource "aws_subnet" "subnet_a_public" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.subnet_a_public
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.tag_name}-subnet-a-public"
    Project_name = var.tag_name
  }
}

resource "aws_subnet" "subnet_b_public" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.subnet_b_public
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.tag_name}-subnet-b-public"
    Project_name = var.tag_name
  }
}

resource "aws_subnet" "subnet_a_private" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.subnet_a_private
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.tag_name}-subnet-a-private"
    Project_name = var.tag_name
  }
}

# Private Subnets Configurations

resource "aws_subnet" "subnet_b_private" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.subnet_b_private
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.tag_name}-subnet-b-private"
    Project_name = var.tag_name
  }
}

# Internet gateway Configuration
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.tag_name}-igw"
    Project_name = var.tag_name
  }
}
# 5. Create Public Route Table and add IGW route
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.tag_name}-public-rt"
    Project_name = var.tag_name
  }
}

resource "aws_route" "public-rt-route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-igw.id
}

resource "aws_route_table_association" "subnet_nva_public-assoc" {
  subnet_id      = aws_subnet.subnet_nva_public.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "subnet_a_public-assoc" {
  subnet_id      = aws_subnet.subnet_a_public.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "subnet_b_public-assoc" {
  subnet_id      = aws_subnet.subnet_b_public.id
  route_table_id = aws_route_table.public-rt.id
}

# Private Route Table and Associations
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.tag_name}-private-rt"
    Project_name = var.tag_name
  }
}

resource "aws_route_table_association" "subnet_nva_private-assoc" {
  subnet_id      = aws_subnet.subnet_nva_private.id
  route_table_id = aws_route_table.private-rt.id
}


resource "aws_route_table_association" "subnet_a_private-assoc" {
  subnet_id      = aws_subnet.subnet_a_private.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "subnet_b_private-assoc" {
  subnet_id      = aws_subnet.subnet_b_private.id
  route_table_id = aws_route_table.private-rt.id
}