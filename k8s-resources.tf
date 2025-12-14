# Apply all Kubernetes manifests using kubectl provider
resource "null_resource" "apply_k8s_manifests" {
  depends_on = [
    kubernetes_namespace_v1.devops,
    kubernetes_namespace_v1.cicd,
    kubernetes_namespace_v1.monitoring,
    kubernetes_namespace_v1.logging
  ]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f ${path.module}/k8s/postgres.yaml
      kubectl apply -f ${path.module}/k8s/puppet.yaml
      kubectl apply -f ${path.module}/k8s/jenkins.yaml
      kubectl apply -f ${path.module}/k8s/sonarqube.yaml
      kubectl apply -f ${path.module}/k8s/monitoring.yaml
      kubectl apply -f ${path.module}/k8s/logging.yaml
    EOT
  }

  triggers = {
    manifests_hash = sha256(join("", [
      filesha256("${path.module}/k8s/postgres.yaml"),
      filesha256("${path.module}/k8s/puppet.yaml"),
      filesha256("${path.module}/k8s/jenkins.yaml"),
      filesha256("${path.module}/k8s/sonarqube.yaml"),
      filesha256("${path.module}/k8s/monitoring.yaml"),
      filesha256("${path.module}/k8s/logging.yaml")
    ]))
  }
}

# Outputs for service URLs
output "jenkins_url" {
  value       = "Access Jenkins at: kubectl get svc jenkins -n cicd"
  description = "Jenkins service access command"
}

output "puppetboard_url" {
  value       = "Access Puppetboard at: kubectl get svc puppetboard -n devops"
  description = "Puppetboard service access command"
}

output "grafana_url" {
  value       = "Access Grafana at: kubectl get svc grafana -n monitoring"
  description = "Grafana service access command"
}

output "kibana_url" {
  value       = "Access Kibana at: kubectl get svc kibana -n logging"
  description = "Kibana service access command"
}

output "sonarqube_url" {
  value       = "Access SonarQube at: kubectl get svc sonarqube -n cicd"
  description = "SonarQube service access command"
}
