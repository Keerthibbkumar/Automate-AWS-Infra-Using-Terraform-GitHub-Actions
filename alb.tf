resource "aws_lb" "app_lb" {
  name = "ALB-PROJ-LB"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sgw.id]
  subnets = aws_subnet.ps[*].id
  tags = {
    Name = "ALB-PROJ-LB"
  }
}

resource "aws_lb_target_group" "ltg" {
  name = "ALB-PROJ-TG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "ALB-PROJ-MYTG"
  }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.app_lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.ltg.arn
    }
}

resource "aws_lb_target_group_attachment" "attach" {
  count = 2
  target_group_arn = aws_lb_target_group.ltg.id
  target_id = aws_instance.name[count.index].id
  port = 80
}