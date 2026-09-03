resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Main"
  }
}
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


resource "aws_main_route_table_association" "example" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.example.id
}


resource "aws_security_group" "allow_ssh_ping" {
  name        = "allow_ssh_ping"
  description = "Allow SSH and Ping traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_ssh_ping"
  }
}

# =========================
# INBOUND - SSH
# =========================
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh_ping.id
  cidr_ipv4         = "0.0.0.0/0"

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# =========================
# INBOUND - PING
# =========================
resource "aws_vpc_security_group_ingress_rule" "allow_ping" {
  security_group_id = aws_security_group.allow_ssh_ping.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "icmp"
  from_port   = -1
  to_port     = -1
}

# =========================
# OUTBOUND - SSH
# =========================
resource "aws_vpc_security_group_egress_rule" "allow_ssh_out" {
  security_group_id = aws_security_group.allow_ssh_ping.id
  cidr_ipv4         = "0.0.0.0/0"

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# =========================
# OUTBOUND - PING
# =========================
resource "aws_vpc_security_group_egress_rule" "allow_ping_out" {
  security_group_id = aws_security_group.allow_ssh_ping.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "icmp"
  from_port   = -1
  to_port     = -1
}