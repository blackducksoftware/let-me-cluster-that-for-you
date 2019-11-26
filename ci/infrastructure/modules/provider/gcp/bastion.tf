resource "google_compute_instance" "bastion" {
    count = "${var.is_enabled == "true" ? "1" : "0"}"
    name = "${var.prefix}-bastion-${count.index}"
    machine_type = "${local.bastion_image_size}"
    zone = "${local.gcp_zone}"
    tags = ["${var.prefix}-bastion","http","https","ssh"]

    boot_disk {
      auto_delete = "${var.disk_auto_delete}"
      initialize_params {
        image = "${data.google_compute_image.rhel-7.self_link}"
        size  = "${var.bastion_disk_size_gb}"
        type  = "${var.bastiondisk_type}"
      }
    }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.subnet.name}"
    access_config {}
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  metadata {
    ssh-keys = "${local.bastion_ssh_user}:${file(var.public_key_path)}"
  }
}
