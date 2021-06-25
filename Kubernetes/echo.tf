module "echo" {
  source                          = "../modules/echo-helm"
  ingress_external_traffic_policy = "Local"
  ingress_kind                    = "DaemonSet"
  ingress_class                   = "blackwall"
  cluster_endpoint                = var.cluster
  cluster_name                    = "myapp-eks-cluster"
  ingress_namespace               = "ingress-nginx"
  ingress_chart_name              = "ingress-nginx"
  ingress_repository_name         = "https://kubernetes.github.io/ingress-nginx"
  application_chart_version       = "0.3.0"
  ingress_chart_version           = "3.34.0"
  application_chart               = "echo-server"
  application_namespace           = "echo-server"
  application_repository          = "https://ealenn.github.io/charts"
  number_of_replicas              = 3
  application_ingress             = true
  dns_name                        = "echo.pashkevich.org"
  basic_auth                      = var.basic_auth
  cluster_ca_cert                 = var.certificate
}

output "ingress_chart_version" {
  value = module.echo.ingress_chart_version
}

output "application_chart_version" {
  value = module.echo.application_chart_version
}