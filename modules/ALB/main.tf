# ALB security group
resource "aws_security_group" "alb_sg"{
  name        = format("%s-sg", var.alb_name)
  description = "Security group for the ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = format("%s-sg", var.alb_name)
  }
}
# Inbound Rule: Managed as an external resource
resource "aws_vpc_security_group_ingress_rule" "http" {

  security_group_id = aws_security_group.alb_sg.id
  to_port           = var.listener_port
  from_port         = var.listener_port
  ip_protocol       = "tcp"
  cidr_ipv4         = var.my_ip_address
}
# Outbound Rule: Managed as an external resource
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "-1" # All traffic
  cidr_ipv4         = "0.0.0.0/0"
}

# Create the Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.pub_subnet_a_id, var.pub_subnet_b_id]
}

/*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
*/

# Create the Target Group for HTTP traffic
resource "aws_lb_target_group" "app_tg" {
  name        = var.alb_target_group_name
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    port                = var.target_port
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# Create the Listener to route traffic from port 80 to the Target Group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}