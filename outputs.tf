//Has to have the resource name 
//This allows us to see the values
//Use terraform refresh to view the output or terraform output
output "instance_ip_addr" {
  value = aws_instance.my_server.public_ip
}