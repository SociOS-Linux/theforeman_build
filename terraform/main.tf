#Google account and project 
provider "google" {
  credentials 	= 	file("service-account.json")
  project 		= 	var.project_id
  region  		= 	var.region
  zone		    = 	var.zone
}
#End google account and project

#Starting network configuration
resource "google_compute_network" "default" {
  name 		= 	var.network_name
}
#End of network configuration

#Starting firewall configuration 
resource "google_compute_firewall" "default" {
  name    	= 	var.firewall_name
  network 	= 	google_compute_network.default.name
  allow {
    protocol 	= 	"icmp"
  }
  allow {
    protocol 	= 	"tcp"
    ports 	 	= 	["22", "80", "8443", "443"]
  }
  source_ranges = 	["0.0.0.0/0"]
}
#End of firewall configuration

#Starting compute instance
resource "google_compute_instance" "server" {
  name 			= 	var.instance_name
  machine_type  = 	var.machine_type
  tags          = 	["http-server", "https-server"]
  
  
#Starting bootdisk configuration
  boot_disk {
    initialize_params {
    image 		= 	var.image_type
    size  		= 	var.disk_size
    type  		= 	var.disk_type
    }
 }
#End bootdisk configuration

#Start network interface connection
  network_interface {
    network 	= 	"default"
    access_config {
    // Ephemeral IP
    }
 }
#End network interface connection
metadata = {
    ssh-keys 	= 	"${var.user}:${file(var.public_key_path)}"
    }
  }
#End of compute instance 

#Copy the files and local machine to virtual machine
#Then execute within that virtual machine

resource "null_resource" "execute" {
connection {
		type        = 	"ssh"
		user        = 	var.user
		private_key = 	file(var.private_key_path)
		host        = 	"${google_compute_instance.server.network_interface.0.access_config.0.nat_ip}"
    }
#This module used to upload files in config folder
provisioner "file" {
  source 		= 	"./config"
  destination 	= 	"~/"
}
#This module used to upload files in scripts folder
provisioner "file" {
  source 		= 	"./scripts"
  destination 	= 	"~/"
}
#This module used to execute bash files in virtual machine
provisioner "remote-exec" {
 inline 	= [
   "chmod 755 ~/scripts/*",
   "sudo sh ~/scripts/firewall_ports.sh",
   "sudo sh ~/scripts/foreman_installation.sh",
   "sudo sh ~/scripts/katello_configuration.sh"
   ]
}
 depends_on = [google_compute_firewall.default, google_compute_network.default,] //module dependencies that Terraform can't automatically infer.
}

output "Ephemeral_IP" {
  value       	= 	google_compute_instance.server.network_interface.0.access_config.0.nat_ip
  description 	= 	"The Ephemeral IP of the terraform-foreman server"
}
