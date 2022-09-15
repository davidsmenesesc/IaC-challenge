//--------------------------------------------------------------------------//
//Network
    resource "google_compute_network" "vpc_network" {
    project                 = var.project_id 
    name                    = var.network
    auto_create_subnetworks = false
    mtu                     = 1460
    }
    resource "google_compute_subnetwork" "subnet-with-logging" {
        name          = var.sub-network
        ip_cidr_range = "10.2.0.0/16"
        region        = "us-east1"
        network       = var.network 
    log_config {
        aggregation_interval = "INTERVAL_10_MIN"
        flow_sampling        = 0.5
        metadata             = "INCLUDE_ALL_METADATA"
        }
    }
//-----------------------------------------------------------------------//
//Firewall rules
    resource "google_compute_firewall" "rules" {
    project     = var.project_id 
    name        = "challenge-firewall-rule"
    network     = var.network
    description = "Creates firewall rule targeting tagged instances"

    allow {
        protocol = "tcp"
        ports    = ["80", "8080", "1000-2000"]
    }
    source_tags = ["challenge-network"]
    target_tags = ["web"]
    }
resource "google_compute_firewall" "ssh" {
    name = "allow-ssh"
    allow {
        ports    = ["22"]
        protocol = "tcp"
    }
    direction     = "INGRESS"
    network       = var.network
    priority      = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["ssh"]
    }
    resource "google_compute_firewall" "port_80" {
    name = "allow-80"
    allow {
        ports    = ["80"]
        protocol = "tcp"
    }
    direction     = "INGRESS"
    network       = var.network
    priority      = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["web","http-server","https-server",]
    }