# Namespaces
resource "kubernetes_namespace_v1" "devops" {
  metadata {
    name = "devops"
    labels = {
      name = "devops"
    }
  }
}

resource "kubernetes_namespace_v1" "cicd" {
  metadata {
    name = "cicd"
    labels = {
      name = "cicd"
    }
  }
}

resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      name = "monitoring"
    }
  }
}

resource "kubernetes_namespace_v1" "logging" {
  metadata {
    name = "logging"
    labels = {
      name = "logging"
    }
  }
}

resource "kubernetes_namespace_v1" "storage" {
  metadata {
    name = "storage"
    labels = {
      name = "storage"
    }
  }
}
