# Apply all Kubernetes manifests using kubectl provider
resource "null_resource" "apply_k8s_manifests" {
  depends_on = [
    kubernetes_namespace_v1.devops,
    kubernetes_namespace_v1.cicd,
    kubernetes_namespace_v1.monitoring,
    kubernetes_namespace_v1.logging,
    kubernetes_namespace_v1.storage
  ]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f ${path.module}/k8s/postgres.yaml
      kubectl apply -f ${path.module}/k8s/jenkins.yaml
      kubectl apply -f ${path.module}/k8s/sonarqube.yaml
      kubectl apply -f ${path.module}/k8s/monitoring.yaml
      kubectl apply -f ${path.module}/k8s/logging.yaml
      kubectl apply -f ${path.module}/k8s/fluent-bit.yaml
      kubectl apply -f ${path.module}/k8s/minio.yaml
      kubectl apply -f ${path.module}/k8s/kafka.yaml
      kubectl apply -f ${path.module}/k8s/kafka-ui.yaml
      kubectl apply -f ${path.module}/k8s/n8n.yaml
    EOT
  }

  triggers = {
    manifests_hash = sha256(join("", [
      filesha256("${path.module}/k8s/postgres.yaml"),
      filesha256("${path.module}/k8s/jenkins.yaml"),
      filesha256("${path.module}/k8s/sonarqube.yaml"),
      filesha256("${path.module}/k8s/monitoring.yaml"),
      filesha256("${path.module}/k8s/logging.yaml"),
      filesha256("${path.module}/k8s/fluent-bit.yaml"),
      filesha256("${path.module}/k8s/minio.yaml"),
      filesha256("${path.module}/k8s/kafka.yaml"),
      filesha256("${path.module}/k8s/kafka-ui.yaml"),
      filesha256("${path.module}/k8s/n8n.yaml")
    ]))
  }
}

# Outputs for service URLs
output "jenkins_url" {
  value       = "Access Jenkins at: kubectl get svc jenkins -n cicd"
  description = "Jenkins service access command"
}

output "n8n_url" {
  value       = "Access n8n at: kubectl port-forward -n cicd svc/n8n 5678:5678"
  description = "n8n workflow automation service access command"
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

output "minio_url" {
  value       = "Access MinIO Console at: kubectl get svc minio -n storage (API: 9000, Console: 9001)"
  description = "MinIO service access command"
}

output "kafka_url" {
  value       = "Access Kafka at: kubectl get svc kafka -n cicd (Internal: 9092, External: 9093)"
  description = "Kafka service access command"
}

output "kafka_ui_url" {
  value       = "Access Kafka UI at: kubectl get svc kafka-ui -n cicd (Web UI on port 8080)"
  description = "Kafka UI service access command"
}
