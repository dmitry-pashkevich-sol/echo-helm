output "ingress_chart_version" {
  value = helm_release.nginx_ingress.version
}

output "application_chart_version" {
  value = helm_release.echo-server.version
}