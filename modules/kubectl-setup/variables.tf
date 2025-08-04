# Kubectl Setup Module Variables

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "cluster_ready" {
  description = "EKS cluster ready signal"
  type        = any
  default     = null
}

variable "cluster_status" {
  description = "EKS cluster status"
  type        = string
  default     = ""
}

variable "node_groups_ready" {
  description = "EKS node groups ready signal"
  type        = any
  default     = null
}

variable "addons_ready" {
  description = "EKS add-ons ready signal"
  type        = any
  default     = null
}

variable "create_iam_role" {
  description = "Whether to create IAM role for kubectl setup (not needed - using existing EKS permissions)"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
} 