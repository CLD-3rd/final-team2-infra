# Kubectl Setup Module Outputs

output "kubectl_ready" {
  description = "Kubectl setup completion signal"
  value       = time_sleep.wait_for_kubectl.id
}

output "cluster_connection_info" {
  description = "Cluster connection information"
  value = {
    cluster_name = var.cluster_name
    endpoint     = var.cluster_endpoint
    region       = var.aws_region
  }
} 