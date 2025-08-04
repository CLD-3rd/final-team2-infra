# Kubectl Setup Module - Main Configuration

# Data source for EKS cluster authentication
data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# Null resource to ensure kubectl is available
resource "null_resource" "kubectl_setup" {
  triggers = {
    cluster_name = var.cluster_name
    cluster_endpoint = var.cluster_endpoint
    cluster_ca_certificate = var.cluster_ca_certificate
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Update kubeconfig
      aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}
      
      # Test kubectl connection
      kubectl get nodes
      
      # Wait for cluster to be ready
      kubectl wait --for=condition=Ready nodes --all --timeout=300s
    EOT
  }

  depends_on = [var.cluster_ready]
}

# Wait for kubectl to be ready
resource "time_sleep" "wait_for_kubectl" {
  depends_on = [null_resource.kubectl_setup]
  create_duration = "30s"
} 