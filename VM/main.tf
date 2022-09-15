//------------------------------------------------------------------------------------//
    //Instance
    resource "google_compute_instance" "Virtual-machine" {
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
        //metadata_startup_script = "sudo apt update;sudo apt install apache2;y;sudo apt-get install ufw;sudo ufw allow 'SSH';sudo ufw allow 'WWW';sudo ufw allow 80/tcp;sudo ufw enable;sudo rm /var/www/html/index.html;sudo touch /var/www/html/index.html;echo '<html><body>Hola soy David y esto es mi IaC </body></html>' > ./var/www/html/index.html;"

        network_interface {
            network = var.network
            subnetwork = var.sub-network    
            access_config {
            # Include this section to give the VM an external IP address
            }
        }
        }