#terraform code to launch EC2 instance

resource "aws_instance" "web"{
  ami           = "ami-0c5300e833c2b32f3"  #Amazon Windows AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.TF_SG.name]
  key_name = "Jiya"

  tags = {
    Name = "Terraform Ec2"
  } 
}

#create a vpc

resource "aws_vpc" "main"{
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyTerraformVPC"
  }
}

#Create a public subnet

resource "aws_subnet" "PublicSubnet"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
}

  #create a private subnet

resource "aws_subnet" "PrivSubnet"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"

}


  #create IGW

resource "aws_internet_gateway" "myIgw"{
    vpc_id = aws_vpc.main.id
}

  #route Tables for public subnet

resource "aws_route_table" "PublicRT"{
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIgw.id
    }
}
 

  #route table association public subnet 

resource "aws_route_table_association" "PublicRTAssociation"{
    subnet_id = aws_subnet.PublicSubnet.id
    route_table_id = aws_route_table.PublicRT.id
}

