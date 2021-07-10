output default_security_group_id {
  value = aws_security_group.default_sg.id
}

output target_group_arn {
  value = aws_alb_target_group.default_tg.arn
}

output alb_dns_name {
  value = aws_alb.default_alb.dns_name
}
