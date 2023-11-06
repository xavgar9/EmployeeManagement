provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = file(var.credentials_file_path)
}

resource "google_compute_instance" "terraform_vm" {
  name         = "terraform-vm"
  machine_type = var.machine_type

  metadata = {
    ssh-keys = "${var.user}:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  connection {
    type        = "ssh"
    user        = var.user
    host        = google_compute_instance.terraform_vm.network_interface.0.access_config.0.nat_ip
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {

    inline = [
      "sudo apt update",
      "sudo apt install -y build-essential",
      "sudo apt install -y git",
      "sudo apt install -y docker docker-compose",
      "sudo systemctl start docker",
      "git clone https://github.com/xavgar9/EmployeeManagement",
      "cd EmployeeManagement",
      "sudo make run",
      "sudo make run-migrations"
    ]
  }
}
resource "google_compute_firewall" "allow-http-ssh" {
  name    = "terraform-vm-firewall"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "22", "3000"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http-ssh"]
}
