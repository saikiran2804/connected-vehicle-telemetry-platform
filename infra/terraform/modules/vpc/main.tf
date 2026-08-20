# =====================================================================
# VPC MODULE — a reusable network blueprint.
# Creates: 1 VPC, public + private subnets across N availability zones,
# an internet gateway, and route tables. NO NAT gateway (keeps cost $0).
# =====================================================================

# Look up which availability zones (physical data centers) exist in the
# chosen region, so we can spread subnets across them for resilience.
data "aws_availability_zones" "available" {
  state = "available"
}

# The VPC itself — our private network. enable_dns_* lets resources inside
# resolve DNS names (required by EKS later).
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "${var.name}-vpc" })
}

# The door to the internet for public subnets. Free.
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

# ------------------------- PUBLIC SUBNETS -------------------------
# One per AZ. map_public_ip_on_launch gives resources here a public IP.
# The kubernetes.io/role/elb tag lets EKS place public load balancers here.
resource "aws_subnet" "public" {
  count                   = var.az_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name                     = "${var.name}-public-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  })
}

# ------------------------- PRIVATE SUBNETS ------------------------
# One per AZ. No public IPs — this is where app/K8s nodes will live.
# internal-elb tag lets EKS place internal load balancers here.
resource "aws_subnet" "private" {
  count             = var.az_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name                              = "${var.name}-private-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

# ------------------------- ROUTING --------------------------------
# Public route table: send internet-bound traffic (0.0.0.0/0) to the IGW.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private route table: no internet route for now (no NAT = no cost).
# Private subnets can still talk within the VPC. We add outbound access
# later, only when EKS needs it.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-private-rt" })
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
