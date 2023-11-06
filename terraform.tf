provider "google" {
  project     = "employee-management-404119"
  region      = "us-central1"
  zone        = "us-central1-a"
  credentials = file("application_default_credentials.json")
}

resource "google_compute_instance" "terraform_vm" {
  name         = "terraform-vm"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  connection {
    host        = google_compute_instance.terraform_vm.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {

    inline = [
      "sudo apt update",
      "sudo apt install -y build-essential",
      "sudo apt install -y git",
      "sudo apt install -y docker docker-compose",
      "git clone https://github.com/xavgar9/EmployeeManagement",
      "cd EmployeeManagement",
      "bash init.sh"
    ]
  }
}

resource "google_compute_firewall" "default" {
  name    = "terraform-vm-firewall"
  network = "google_compute_network.default.name"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}
