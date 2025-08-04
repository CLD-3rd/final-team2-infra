# Cert-Manager Module Variables

variable "cert_manager_version" {
  description = "Cert-manager version to install"
  type        = string
  default     = "1.13.0"
}

variable "letsencrypt_email" {
  description = "Email address for Let's Encrypt notifications"
  type        = string
  sensitive   = true
  # DO NOT set default value - use environment variable TF_VAR_letsencrypt_email
}

variable "ingress_class" {
  description = "Ingress class for HTTP01 challenge"
  type        = string
  default     = "nginx"
}

variable "enable_prometheus" {
  description = "Enable Prometheus monitoring for cert-manager"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "eks_cluster_ready" {
  description = "EKS cluster ready signal for dependency management"
  type        = any
  default     = null
} 