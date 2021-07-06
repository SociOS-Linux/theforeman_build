#Google account and project 
provider "google" {
    version = "3.73.0"

    credentials = file("socios-linux-246b61c10333.json")
  
  project = "socios-linux"
  region  = "us-central1"
  zone    = "us-central1-a"
}
#End google account and project

#Start resource compute instance
resource "google_compute_instance" "server" {
  name = "terraform-foreman"
  machine_type = "e2-standard-8"
  tags = ["ssh","http-server","https-server"]
  
#Start bootdisk configuration
 boot_disk {
     initialize_params {
     image = "centos-7"
     size = "50"
     type = "pd-balanced"
     }
 }
#End bootdisk configuration

#Start network interface connection
 network_interface {
     network = "default"
     network_ip = "10.128.0.5"
     access_config {
      // Ephemeral IP
     }
 }
#End network interface connection
metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}
# Copy in the bash script we want to execute.
# The source is the location of the bash scterrript
# on the local project box you are executing terraform
# from.  The destination is on the new GCP Instance.

resource "null_resource" "copyhtml" {

  connection {
    type     = "ssh"
    user     = var.user
    private_key = file(var.privatekeypath)
    host     = "${google_compute_instance.server.network_interface.0.access_config.0.nat_ip}"
    timeout  = "160s"
  }
#Defining provisioner and remote execusion process
	provisioner "remote-exec" {
    inline = [
    "chmod +x /tmp/autoinstall.sh",
    "sh /tmp/autoinstall.sh",
  ]
}
	depends_on = [google_compute_instance.server, google_compute_firewall.default]
}
#Start firewall configuration 
resource "google_compute_firewall" "default" {
    name    = "terraform-firewall"
    network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }
allow {
    protocol = "tcp"
    ports = ["22", "80", "8443", "443"]
  }
allow {
    protocol = "udp"
    ports = ["22", "80", "8443", "443"]
  }
}
#End firewall configuration

#Start network configuration
resource "google_compute_network" "default" {
  name = "terraform-network"
}
#End Resource Compute Instance