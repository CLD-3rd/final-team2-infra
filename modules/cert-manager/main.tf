# Cert-Manager Module - Main Configuration

# Kubernetes Provider for cert-manager installation
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

# Cert-Manager Installation using Helm
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_version
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = var.enable_prometheus
  }

  set {
    name  = "webhook.timeoutSeconds"
    value = "30"
  }

  set {
    name  = "global.leaderElection.namespace"
    value = "cert-manager"
  }

  # Enhanced wait settings for production stability
  wait = true
  timeout = 900  # 15 minutes timeout
  wait_for_jobs = true

  # Ensure EKS cluster is fully ready before cert-manager installation
  depends_on = [
    kubernetes_namespace.cert_manager,
    time_sleep.wait_for_eks_ready
  ]
}

# Wait for EKS cluster to be fully ready
resource "time_sleep" "wait_for_eks_ready" {
  depends_on = [var.eks_cluster_ready]

  create_duration = "60s"  # Wait 60 seconds after EKS is ready
}

# Cert-Manager Namespace
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
      "app.kubernetes.io/name"       = "cert-manager"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/version"    = var.cert_manager_version
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/part-of"    = "cert-manager"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# Let's Encrypt Staging ClusterIssuer
resource "kubernetes_manifest" "letsencrypt_staging" {
  depends_on = [helm_release.cert_manager]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging"
    }
    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        email = var.letsencrypt_email
        privateKeySecretRef = {
          name = "letsencrypt-staging"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = var.ingress_class
              }
            }
          }
        ]
      }
    }
  }
}

# Let's Encrypt Production ClusterIssuer
resource "kubernetes_manifest" "letsencrypt_prod" {
  depends_on = [helm_release.cert_manager]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email = var.letsencrypt_email
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = var.ingress_class
              }
            }
          }
        ]
      }
    }
  }
}

# Self-Signed ClusterIssuer for testing
resource "kubernetes_manifest" "selfsigned_issuer" {
  depends_on = [helm_release.cert_manager]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "selfsigned-issuer"
    }
    spec = {
      selfSigned = {}
    }
  }
} 