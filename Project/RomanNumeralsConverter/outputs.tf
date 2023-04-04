output "WebsiteURL" {
    value = "http://${aws_instance.webserverhost.public_dns}"
}