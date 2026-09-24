output "aws_vpc"                     { value = aws_vpc.Vickie-VPC.id }
output "aws_subnet"                  { value = aws_subnet.Vickie_Subnet.id }
output "aws_internet_gateway"        { value = aws_internet_gateway.myapp-igw.id }
output "aws_route_table"             { value = aws_route_table.myapp-route-table.id }
output "aws_route_table_association" { value = aws_route_table_association.myapp-route-table-association.id }
output "aws_security_group"          { value = aws_security_group.myapp-sg.id }
output "server_public_ip"            { value = aws_instance.my_server.public_ip }
output "server_private_ip"           { value = aws_instance.my_server.private_ip }
