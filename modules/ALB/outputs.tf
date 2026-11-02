output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.app_alb.arn
}
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}
output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.http_listener.arn
}
output "alb_target_group_arn" {
  description = "The ARN of the ALB target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}