


module "vpc_1" {
  source = "./modules/vpc"
  public_subnet = true
  vpc_cidr = var.vpc1_cidr
  subnet_cidr = var.subnet1_cidr
  az = "ap-south-1a"
 region = "ap-south-1"
}
  

  


module "vpc_2" {
  source = "./modules/vpc"
  public_subnet = false
  vpc_cidr = var.vpc2_cidr
  subnet_cidr = var.subnet2_cidr
  az = "us-esat-1a"
region = "us-esat-1"
   
}


resource "aws_vpc_peering_connection" "foo" {
  provider = aws.us-east-1    # 	Request
  peer_vpc_id   = module.vpc_1.vpc
  vpc_id        = module.vpc_2.vpc
  
  peer_region   = "ap-south-1"  
 

  tags = {
    Name = "VPC Peering"
  }
}
resource "aws_route" "vpc1" {
  route_table_id            = module.vpc_1.route_table
  destination_cidr_block    = var.vpc2_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
  provider = aws.ap-south-1
}

resource "aws_route" "vpc2" {
  route_table_id            = module.vpc_2.route_table
  destination_cidr_block    = var.vpc1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
  provider = aws.us-east-1
}

resource "aws_instance" "ap-south-1" {
  provider = aws.ap-south-1
  ami= var.ami-ap-south-1
  subnet_id = module.vpc_1.subnet
  instance_type = "t3.micro"
  security_groups = [module.vpc_1.sg]
  
  


   tags = {
    Name = "ap-south-1"
  }
  
}
resource "aws_instance" "us-east-1" {
  provider = aws.us-east-1
  ami = var.ami-us-east-1
  subnet_id = module.vpc_2.subnet
  instance_type = "t3.micro"
  
  security_groups = [module.vpc_2.sg]
   tags = {
    Name = "us-east-1"
  }
  
}