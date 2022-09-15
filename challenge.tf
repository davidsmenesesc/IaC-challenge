 
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
    //Network
    module "Networking" {
    source = "./Network"
    network = var.network
    sub-network = var.sub-network
    project_id = var.project_id
    }
//Virtual machines
    module "virtual-machines" {
        source = "./VM"
        network = var.network
        sub-network = var.sub-network
        vm-name = var.vm-name
    }
        