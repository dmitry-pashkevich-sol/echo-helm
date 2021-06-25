variable "cluster_endpoint" {
  type        = string
  description = "Cluster endpoint"
}

variable "cluster_ca_cert" {
  type        = string
  description = "Certificate"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "ingress_kind" {
  type        = string
  description = "Deployment or DaemonSet"
}

variable "ingress_class" {
  default     = "nginx"
  description = "Class of ingress"
  type        = string
}

variable "ingress_external_traffic_policy" {
  description = "Set external traffic policy to: Local to preserve source IP on"
  type        = string
}

variable "ingress_namespace" {
  description = "Namespace to deploy"
  type        = string
}

variable "ingress_chart_name" {
  description = "Name of ingress chart"
  type        = string
}

variable "ingress_repository_name" {
  description = "Name of ingress chart repository"
  type        = string
}


variable "application_namespace" {
  description = "Application namespace"
  type        = string
}

variable "application_repository" {
  description = "Application chart repo"
  type        = string
}

variable "application_chart" {
  description = "Application chart name"
  type        = string
}

variable "number_of_replicas" {
  type        = number
  description = "Number of application replicas"
  default     = 1
}

variable "application_ingress" {
  type        = bool
  description = "Enable Ingress for application"
}

variable "dns_name" {
  type        = string
  description = "DNS name of application"
}

variable "basic_auth" {
  type        = string
  description = "Generated with htpasswd string"
}

variable "basic_auth_key_name" {
  type        = string
  default     = "basic-auth"
  description = "Name of basic auth key"
}

variable "ingress_chart_version" {
  type        = string
  description = "Ingress chart version"
}

variable "application_chart_version" {
  type        = string
  description = "Application chart version"
}