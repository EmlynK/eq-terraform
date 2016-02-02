# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  tags {
    Name = "${var.env}-vpc"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our ec2 instances and ElasticBeanstalk into
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}


# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "survey_runner"
  description = "Used for "
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Rabbitmq
  ## Clustering ports
  ingress {
    from_port = 4369
    to_port   = 4369
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 4369
    to_port   = 4369
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port = 25672
    to_port   = 25672
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 25672
    to_port   = 25672
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ## AMQP Connection ports
  ingress {
    from_port = 5672
    to_port   = 5672
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 5672
    to_port   = 5672
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port = 5671
    to_port   = 5671
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 5671
    to_port   = 5671
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  # End RabbitMQ ports

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
