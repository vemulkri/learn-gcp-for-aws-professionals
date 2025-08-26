#### GCP VPC - Global
resource "google_compute_network" "vpc" {
  provider                = google.google_global
  name                    = "gcp-vpc-1"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  mtu                     = 1460

  lifecycle {
    prevent_destroy = false
  }
}

# GCP Subnet for Region 1
resource "google_compute_subnetwork" "subnet1" {
  provider                 = google.google_global
  name                     = "subnet-1"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "northamerica-northeast1"
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

}

# GCP Subnet for Region 2
resource "google_compute_subnetwork" "subnet2" {
  provider                 = google.google_global
  name                     = "subnet-2" ## _ is not allowed in name syntax -- "^(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)$"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = "northamerica-northeast2"
  network                  = google_compute_network.vpc.id
  private_ip_google_access = false

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

}

# GCP Public NAT
resource "google_compute_router" "nat" {
  provider = google.google_global
  name     = "nat"
  network  = google_compute_network.vpc.id
  region   = google_compute_subnetwork.subnet2.region
}
resource "google_compute_router_nat" "nat" {
  provider                           = google.google_global
  name                               = "nat"
  router                             = google_compute_router.nat.name
  region                             = google_compute_router.nat.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
  auto_network_tier                  = "STANDARD"

  log_config {
    enable = true
    filter = "ALL"
  }
}

# GCP Private VM(EC2 equivalent in AWS) - NO External IP - VM will use public NAT for egress access
resource "google_compute_instance" "vm1" {
  provider     = google.google_global
  name         = "vm"
  machine_type = "e2-micro"
  zone         = "northamerica-northeast2-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250709"
      size  = 10
      type  = "pd-balanced"
    }
    mode        = "READ_WRITE"
    auto_delete = true
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet2.name
    # access_config {
    #
    # }
  }

  tags = ["test-vm"]
  lifecycle {
    ignore_changes = [metadata]
  }
}

# GCP FW - Ingress
resource "google_compute_firewall" "ingress" {
  provider  = google.google_global
  name      = "allow-ingress"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  priority = "65530"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] ## Google IAP range
  target_tags   = ["test-vm"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

}

#GCP FW - Egress
resource "google_compute_firewall" "deny_all_egress" {
  provider  = google.google_global
  name      = "deny-all-egress"
  network   = google_compute_network.vpc.name
  direction = "EGRESS"
  priority = "10000"

  deny {
    protocol = "all"
    ports = []
  }

  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["test-vm"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

}
resource "google_compute_firewall" "egress" {
  provider  = google.google_global
  name      = "allow-egress"
  network   = google_compute_network.vpc.name
  direction = "EGRESS"
  priority = "100"

  allow {
    protocol = "icmp"
  }

  destination_ranges = ["8.8.8.8/32"]
  target_tags        = ["test-vm"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

}