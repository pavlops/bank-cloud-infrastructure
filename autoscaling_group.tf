locals {
  user_data = <<-EOT
    #! /bin/bash
    sudo apt-get update
    sudo yum install -y httpd24
    sudo service httpd start
    echo "<h1>Bank Cloud Infrastructure Online!</h1>" | sudo tee /var/www/html/index.html
  EOT
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.1.0"

  # Autoscaling group params
  name                = "bci-asg"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  health_check_type   = "EC2"
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns   = module.alb.target_group_arns
  security_groups     = [module.asg_sg.this_security_group_id]

  # Launch template params
  lt_name                  = "bci-lt"
  use_lt                   = true
  create_lt                = true
  image_id                 = "ami-047bb4163c506cd98"
  instance_type            = "t3.micro"
  iam_instance_profile_arn = aws_iam_instance_profile.profile.arn
  user_data_base64         = "${base64encode(local.user_data)}"

  # Persistance layer using EBS
  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = false
        encrypted             = true
        volume_size           = 8
        volume_type           = "gp2"
      }
    }
  ]
}

module "asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name        = "bci-asg-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = "${module.alb_sg.this_security_group_id}"
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
}
