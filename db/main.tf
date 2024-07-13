resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "Wellcome123!"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible    = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.allow_mysql_access.id]
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_mysql_access" {
  name   = "allow_mysql_access"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "Access MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mysql_access"
  }
}

