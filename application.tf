resource "aws_elastic_beanstalk_application" "app" {
  name        = "incredible-website"
  description = "Application for the incredible website."
}

resource "aws_elastic_beanstalk_environment" "production" {
  name                = "production"
  application         = "${aws_elastic_beanstalk_application.app.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v4.5.1 running Node.js"

  setting {
    namespace = "aws:elbv2:listener:80"
    name = "ListenerEnabled"
    value = "true"
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name = "Protocol"
    value = "HTTP"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "NODE_ENV"
    value = "production"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "${aws_iam_instance_profile.build.name}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.small"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "1"
  }
}

output "url" {
  value = "${aws_elastic_beanstalk_environment.production.cname}"
}
