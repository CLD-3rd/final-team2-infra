# Kubectl Setup Module - Main Configuration

# Data source for EKS cluster authentication
data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Null resource to ensure kubectl is available
resource "null_resource" "kubectl_setup" {
  triggers = {
    cluster_name = var.cluster_name
    cluster_endpoint = var.cluster_endpoint
    cluster_ca_certificate = var.cluster_ca_certificate
    cluster_status = var.cluster_status
    node_groups_ready = var.node_groups_ready
    addons_ready = var.addons_ready
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Update kubeconfig
      aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}
      
      # Test kubectl connection
      kubectl get nodes
      
      # Wait for all nodes to be ready
      kubectl wait --for=condition=Ready nodes --all --timeout=300s
      
      # Wait for core add-ons to be ready
      kubectl wait --for=condition=Available deployment/coredns -n kube-system --timeout=300s
      kubectl wait --for=condition=Available deployment/kube-proxy -n kube-system --timeout=300s
    EOT
  }

  depends_on = [
    var.cluster_ready,
    var.node_groups_ready,
    var.addons_ready
  ]
}

# Wait for kubectl to be ready
resource "time_sleep" "wait_for_kubectl" {
  depends_on = [null_resource.kubectl_setup]
  create_duration = "30s"
} 