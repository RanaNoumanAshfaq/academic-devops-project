# GKE Cluster (Control Plane)
resource "google_container_cluster" "primary" {
  name     = "${var.project_name}-gke"
  location = var.region
  
  # We delete the default node pool to create a custom one with better cost controls
  remove_default_node_pool = true
  initial_node_count       = 1
}

# Custom Node Pool (Worker Nodes)
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.project_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true # HUGE COST SAVING: Uses spare capacity (like Spot instances)
    machine_type = "e2-medium"

    # Grants full access to all Cloud APIs (Good for learning, limit in production)
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}