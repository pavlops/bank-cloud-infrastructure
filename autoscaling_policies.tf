resource "aws_autoscaling_policy" "asg_scale_in" {
  name                   = "bci-asg-scale-in"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 200
  autoscaling_group_name = module.asg.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "asg_scale_in_cpu" {
  alarm_name          = "bci-asg-scale-in-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = "60"
  threshold           = "80"
  dimensions          = {"AutoScalingGroupName" = "${module.asg.autoscaling_group_name}"}
  actions_enabled     = true
  alarm_actions       = ["${aws_autoscaling_policy.asg_scale_in.arn}"]
}

resource "aws_autoscaling_policy" "asg_scale_out" {
  name                   = "bci-asg-scale-out"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 200
  autoscaling_group_name = module.asg.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "asg_scale_out_cpu" {
  alarm_name          = "bci-asg-scale-out-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = "60"
  threshold           = "60"
  dimensions          = {"AutoScalingGroupName" = "${module.asg.autoscaling_group_name}"}
  actions_enabled     = true
  alarm_actions       = ["${aws_autoscaling_policy.asg_scale_out.arn}"]
}
