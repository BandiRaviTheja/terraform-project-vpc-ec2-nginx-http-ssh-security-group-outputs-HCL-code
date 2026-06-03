
output "instance_public_ip" {
    description = "public ip of the ec2 instance"
    value=aws_instance.nginx-server.public_ip
  
}
output "instance-url" {
    description = "url to access the nginx server"
    value="http://${aws_instance.nginx-server.public_ip}"
  
}
