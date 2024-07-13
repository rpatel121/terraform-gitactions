resource "aws_db_instance" "mysqldb" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = aws_secretsmanager_secret_version.ssm_manager.secret_string
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
   vpc_security_group_ids = [aws_security_group.allow_mysql_access.id]
}

/*
data "aws_ssm_parameter" "manual_password" {
  name = "/mysql/password/admin"
}


resource "aws_ssm_parameter" "ssm_secrets" {
  name  = "/mysql/terraform/admin/password"
  type  = "SecureString"
  value = var.admin_password
}

variable "admin_password" {
  type      = string
  sensitive = true
}
*/
resource "aws_secretsmanager_secret" "ssm_manager" {
  name = "ssm_msql_admin_password"
}

data "aws_secretsmanager_random_password" "ssm_manager" {
  password_length            = 15
  require_each_included_type = true
}


resource "aws_secretsmanager_secret_version" "ssm_manager" {
  secret_id     = aws_secretsmanager_secret.ssm_manager.id
  secret_string = data.aws_secretsmanager_random_password.ssm_manager.random_password
}

data "aws_vpc" "this" {
   default = true
}

resource "aws_security_group" "allow_mysql_access" {
  name   = "allow_mysql_access"
  vpc_id = data.aws_vpc.this.id

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

