resource "aws_iam_role" "build" {
  name = "incredible-website-build-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "beanstalk_policy" {
  name = "incredible-website-beanstalk-policy"
  role = "${aws_iam_role.build.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BucketAccess",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::elasticbeanstalk-*",
        "arn:aws:s3:::elasticbeanstalk-*/*"
      ]
    },
    {
      "Sid": "XRayAccess",
      "Action":[
        "xray:PutTraceSegments",
        "xray:PutTelemetryRecords"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "CloudWatchLogsAccess",
      "Action": [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
      ]
    },
    {
      "Sid": "CloudWatchCodeBuildLogsAccess",
      "Action": [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:*:*:log-group:/aws/codebuild*"
      ]
    },
    {
        "Sid": "AllowPassRoleToElasticBeanstalk",
        "Effect": "Allow",
        "Action": [
            "iam:PassRole"
        ],
        "Resource": "*",
        "Condition": {
            "StringLikeIfExists": {
                "iam:PassedToService": "elasticbeanstalk.amazonaws.com"
            }
        }
    },
    {
        "Sid": "AllowCloudformationOperationsOnElasticBeanstalkStacks",
        "Effect": "Allow",
        "Action": [
            "cloudformation:*"
        ],
        "Resource": [
            "arn:aws:cloudformation:*:*:stack/awseb-*",
            "arn:aws:cloudformation:*:*:stack/eb-*"
        ]
    },
    {
      "Sid": "LoadBalancer",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*" 
      ],
      "Resource": [
        "*"
      ]
    },
    {
        "Sid": "AllowDeleteCloudwatchLogGroups",
        "Effect": "Allow",
        "Action": [
            "logs:DeleteLogGroup"
        ],
        "Resource": [
            "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
        ]
    },
    {
        "Sid": "AllowS3OperationsOnElasticBeanstalkBuckets",
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::elasticbeanstalk-*",
            "arn:aws:s3:::elasticbeanstalk-*/*"
        ]
    },
    {
        "Sid": "AllowOperations",
        "Effect": "Allow",
        "Action": [
            "autoscaling:AttachInstances",
            "autoscaling:CreateAutoScalingGroup",
            "autoscaling:CreateLaunchConfiguration",
            "autoscaling:DeleteLaunchConfiguration",
            "autoscaling:DeleteAutoScalingGroup",
            "autoscaling:DeleteScheduledAction",
            "autoscaling:DescribeAccountLimits",
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeLoadBalancers",
            "autoscaling:DescribeNotificationConfigurations",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DescribeScheduledActions",
            "autoscaling:DetachInstances",
            "autoscaling:PutScheduledUpdateGroupAction",
            "autoscaling:ResumeProcesses",
            "autoscaling:SetDesiredCapacity",
            "autoscaling:SuspendProcesses",
            "autoscaling:TerminateInstanceInAutoScalingGroup",
            "autoscaling:UpdateAutoScalingGroup",
            "cloudwatch:PutMetricAlarm",
            "ec2:AssociateAddress",
            "ec2:AllocateAddress",
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CreateSecurityGroup",
            "ec2:DeleteSecurityGroup",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeAddresses",
            "ec2:DescribeImages",
            "ec2:DescribeInstances",
            "ec2:DescribeKeyPairs",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcs",
            "ec2:DisassociateAddress",
            "ec2:ReleaseAddress",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RevokeSecurityGroupIngress",
            "ec2:TerminateInstances",
            "ecs:CreateCluster",
            "ecs:DeleteCluster",
            "ecs:DescribeClusters",
            "ecs:RegisterTaskDefinition",
            "elasticbeanstalk:*",
            "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:ConfigureHealthCheck",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DescribeInstanceHealth",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeTargetHealth",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:DeregisterTargets",
            "iam:ListRoles",
            "logs:CreateLogGroup",
            "logs:PutRetentionPolicy",
            "rds:DescribeDBInstances",
            "rds:DescribeOrderableDBInstanceOptions",
            "rds:DescribeDBEngineVersions",
            "sns:ListTopics",
            "sns:GetTopicAttributes",
            "sns:ListSubscriptionsByTopic",
            "sqs:GetQueueAttributes",
            "sqs:GetQueueUrl",
            "codebuild:CreateProject",
            "codebuild:DeleteProject",
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
        ],
        "Resource": [
            "*"
        ]
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "build" {
  name = "incredible-website-build-profile"
  role = "${aws_iam_role.build.name}"
}

resource "aws_s3_bucket_policy" "artifacts" {
  bucket = "${aws_s3_bucket.artifacts.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "incredible-website-artifacts-policy",
  "Statement": [
    {
      "Sid": "incredible-website-access",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.build.arn}"
      },
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.artifacts.arn}"]
    },
    {
      "Sid": "incredible-website-child-access",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.build.arn}"
      },
      "Action": ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"],
      "Resource": ["${aws_s3_bucket.artifacts.arn}/*"]
    }
  ]
}
POLICY
}
