# Cert-Manager Module Outputs

output "cert_manager_namespace" {
  description = "Cert-manager namespace"
  value       = kubernetes_namespace.cert_manager.metadata[0].name
}

output "letsencrypt_staging_issuer" {
  description = "Let's Encrypt staging ClusterIssuer name"
  value       = "letsencrypt-staging"
}

output "letsencrypt_prod_issuer" {
  description = "Let's Encrypt production ClusterIssuer name"
  value       = "letsencrypt-prod"
}

output "selfsigned_issuer" {
  description = "Self-signed ClusterIssuer name"
  value       = "selfsigned-issuer"
}

output "cert_manager_status" {
  description = "Cert-manager installation status"
  value       = helm_release.cert_manager.status
} 