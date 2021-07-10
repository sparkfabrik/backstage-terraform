resource "aws_security_group" "rds_instance_sg" {
  name        = "${var.project}-rds-sg"
  description = "Allow traffic to DB from default security group"
  vpc_id      = var.vpc_id
  ingress {
    description     = "Connection to DB"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.default_security_group_id]
  }
}

resource "aws_db_subnet_group" "default_sn" {
  name       = "rds_subnet_group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "default_db" {
  identifier              = var.project
  name                    = "backstagedb"
  allocated_storage       = var.storage
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "13.2"
  parameter_group_name    = "default.postgres13"
  instance_class          = "db.t3.micro"
  username                = var.username
  password                = var.password
  multi_az                = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 15
  backup_window           = "03:00-04:00"
  maintenance_window      = "wed:04:30-wed:05:30" 
  availability_zone       = "eu-west-1b"
  db_subnet_group_name    = aws_db_subnet_group.default_sn.name
  vpc_security_group_ids  = [aws_security_group.rds_instance_sg.id]
}
