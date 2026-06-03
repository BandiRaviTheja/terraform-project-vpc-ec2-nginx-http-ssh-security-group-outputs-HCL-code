
resource "aws_instance" "nginx-server" {
    ami="ami-0c4fc5dcabc9df21d"
    instance_type="t3.micro"
    subnet_id=aws_subnet.public-subnet.id
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
    associate_public_ip_address = true
    user_data = <<-EOF
              #!/bin/bash
              sudo yum upgrade -y && sudo yum update -y
              sudo yum install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo systemctl status nginx
              EOF

    

    tags ={
        Name="nginx-server"
    }
  
}
