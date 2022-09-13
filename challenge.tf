 
    terraform {
    cloud {
        organization = "davidsmenesesc"
        workspaces {
        name = "example-workspace"
        }
    }
    }
    provider "google" {
    credentials = file("tf_demo_auth.json")
    project = var.project_id
    region  = "us-east1"
    zone    = "us-east1-b"
    }
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
    resource "google_compute_instance" "default" {
        name         = var.vm-name
        machine_type = "e2-medium"
        zone         = "us-east1-b"
        tags         = ["ssh","web","http-server","https-server"]
        
        metadata = {
            enable-oslogin = "TRUE"
        }
        boot_disk {
            initialize_params {
            image = "debian-cloud/debian-11"
            }
        }
        # Install appication
        metadata_startup_script = "sudo apt update;sudo apt install apache2;sudo apt-get install ufw;sudo ufw enable;sudo ufw allow 'WWW';sudo rm index.html;sudo touch index.html;echo '<html><body>Hola soy David y esto es mi IaC </body></html>' > ./var/www/html/index.html;"

        network_interface {
            network = var.network
            subnetwork = var.sub-network    
            access_config {
            # Include this section to give the VM an external IP address
            }
        }
        }
