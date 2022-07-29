output "website_endpoint" {
  value = module.module.endpoint
}

output "instance_status"{
    value = aws_instance.web.instance_state
}