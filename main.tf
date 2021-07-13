#Google account and project 
provider "google" {
  credentials 	= file("service-account.json")
  project 		= var.project_id
  region  		= var.region
  zone		    = "us-central1-a"
}
#End google account and project

#Starting network configuration
resource "google_compute_network" "default" {
  name 	= "terraform-network"
}
#End of network configuration

#Starting firewall configuration 
resource "google_compute_firewall" "default" {
  name    = "terraform-firewall"
  network = google_compute_network.default.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports 	 = ["22", "80", "8443", "443"]
  }
  allow {
    protocol = "udp"
    ports 	 = ["22", "80", "8443", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}
#End of firewall configuration

#Starting compute instance
resource "google_compute_instance" "server" {
  name 			    = "terraform-foreman"
  machine_type  = "e2-standard-8"
  tags = ["http-server", "https-server"]
  
  
#Starting bootdisk configuration
  boot_disk {
    initialize_params {
    image = "centos-cloud/centos-7"
    size = "50"
    type = "pd-balanced"
    }
 }
#End bootdisk configuration

#Start network interface connection
  network_interface {
    network = "default"
    access_config {
    // Ephemeral IP
    }
 }
#End network interface connection
metadata = {
    ssh-keys = "${var.user}:${file(var.public_key_path)}"
    }
  }
#End of compute instance 

# Copy in the bash script we want to execute.
# The source is the location of the bash scterrript
# on the local project box you are executing terraform
# from.  The destination is on the new GCP Instance.
resource "null_resource" "execute" {
  
connection {
		type     = "ssh"
		user     = var.user
		private_key = file(var.private_key_path)
		host     = "${google_compute_instance.server.network_interface.0.access_config.0.nat_ip}"
    }
provisioner "remote-exec" {
 inline = [
  "sudo yum -y localinstall https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm",
	"sudo yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm",
	"sudo yum -y localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm",
	"sudo yum -y install epel-release centos-release-scl-rh",
	"sudo yum -y update",
	"echo 0 > /proc/sys/vm/overcommit_memory",
	"sudo yum -y install katello",
	"sudo foreman-installer --scenario katello"
	 ]
  }
 depends_on = [google_compute_firewall.default, google_compute_network.default,]
}
output "Ephemeral_IP" {
  value       = google_compute_instance.server.network_interface.0.access_config.0.nat_ip
  description = "The Ephemeral IP of the terraform-foreman server"
}