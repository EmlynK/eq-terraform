resource "aws_elastic_beanstalk_application" "author" {
  name = "${var.env}-author"
  description = "Author Application"
}

resource "aws_elastic_beanstalk_environment" "author-prime" {
  name = "${var.env}-author-prime"
  application = "${aws_elastic_beanstalk_application.author.name}"
  solution_stack_name = "${var.aws_elastic_beanstalk_solution_stack_name}"

  tags {
       Name = "${var.env}-eb-application"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      =  "VPCId"
    value     = "${aws_vpc.author-vpc.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.author_application.id}"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = "${aws_security_group.author_ons_ips.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.author_ons_ips.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${var.elastic_beanstalk_iam_role}"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = "${aws_security_group.author_ons_ips.id}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.eb_max_size}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "${var.eb_min_size}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.eb_instance_type}"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "SSLCertificateId"
    value     = "${var.certificate_arn}"
  }

  setting {
    namespace =  "aws:elb:listener:443"
    name      = "InstancePort"
    value = "80"
  }

  setting {
    namespace  = "aws:elb:listener:443"
    name       = "InstanceProtocol"
    value      = "HTTP"
  }  

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EQ_AUTHOR_DATABASE_URL"
    value     = "postgres://${var.database_user}:${var.database_password}@${aws_db_instance.author-database.address}:${aws_db_instance.author-database.port}/${aws_db_instance.author-database.name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EQ_SCHEMA_BUCKET"
    value     = "${var.schema_bucket}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EQ_AUTHOR_ADMIN_USERNAME"
    value     = "${var.author_admin_username}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EQ_AUTHOR_ADMIN_EMAIL"
    value     = "${var.author_admin_email}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EQ_AUTHOR_ADMIN_PASSWORD"
    value     = "${var.author_admin_password}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EQ_AUTHOR_ADMIN_FIRSTNAME"
    value     = "${var.author_admin_firstname}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "EQ_AUTHOR_ADMIN_LASTNAME"
    value     = "${var.author_admin_lastname}"
  }
}

resource "aws_route53_record" "author" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-author.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elastic_beanstalk_environment.author-prime.cname}"]
}
