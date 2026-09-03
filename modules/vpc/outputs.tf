output "vpc" {
    value = aws_vpc.main.id
  
}
output "route_table" {
    
    value = aws_route_table.example.id
  
}
output "subnet" {
    value = aws_subnet.main.id
  
}
output "sg" {
    value =  aws_security_group.allow_ssh_ping.id
}