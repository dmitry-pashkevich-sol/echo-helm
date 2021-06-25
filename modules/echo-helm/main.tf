provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

resource "helm_release" "nginx_ingress" {
  name             = "ingress-controller"
  version          = var.ingress_chart_version
  repository       = var.ingress_repository_name
  chart            = var.ingress_chart_name
  namespace        = var.ingress_namespace
  create_namespace = true
  values = [<<EOF
controller:
  kind: ${var.ingress_kind}
  ingressClass: ${var.ingress_class}
  config:
    proxy-protocol: "True"
    real-ip-header: "proxy_protocol"
    set-real-ip-from: "0.0.0.0/0"

  service:
    externalTrafficPolicy: ${var.ingress_external_traffic_policy}
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
      service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
      service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
  EOF
  ]
}

resource "helm_release" "echo-server" {
  name             = "echo-server"
  namespace        = var.application_namespace
  repository       = var.application_repository
  chart            = var.application_chart
  version          = var.application_chart_version
  create_namespace = true
  values = [<<EOF
replicaCount: ${var.number_of_replicas}

ingress:
  enabled: var.application_ingress
  hosts:
    - host: ${var.dns_name}
      paths:
        - "/"
  annotations:
    kubernetes.io/ingress.class: blackwall
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: ${var.basic_auth_key_name}
    nginx.ingress.kubernetes.io/auth-realm: 'Authentication Required'
    EOF
  ]
}

resource "kubernetes_secret" "basic_auth" {
  metadata {
    name      = var.basic_auth_key_name
    namespace = var.application_namespace
  }
  data = {
    auth = var.basic_auth
  }
  depends_on = [helm_release.echo-server]
}