output "packer-registry-ubuntu-east-2" {
  value = data.hcp_packer_image.ubuntu_us_east_2.cloud_image_id
}
output "instance_status"{
    value = aws_instance.web.instance_state
}