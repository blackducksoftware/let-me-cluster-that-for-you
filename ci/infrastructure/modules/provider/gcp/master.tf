resource "google_compute_disk" "master" {
  count = "${var.is_enabled == "true" ? "${var.masters}" : "0"}"
  name = "${var.prefix}-master-${count.index}-disk"
  type = "pd-ssd"
  zone = "${local.gcp_zone}"
  size = "${local.gcp_master_extra_disk_size_gb}"
}

resource "google_compute_instance" "master" {
  count = "${var.is_enabled == "true" ? "${var.masters}" : "0"}"
  name = "${var.prefix}-master-${count.index}"
  description = "${var.prefix} Cluster Master ${count.index}"
  labels = {
    environment = "master"
  }

  machine_type         = "${local.masterimagesize}"
  can_ip_forward       = true

  /*scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }*/
 
 
  // Create a new boot disk from an image
  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.rhel-7.self_link}"
      size = "100"
    }
  }

  attached_disk {
    source = "${element(google_compute_disk.master.*.name, count.index)}"
    mode = "READ_WRITE"
  }

  metadata {
    ssh-keys = "${local.cluster_ssh_user}:${file(var.public_key_path)}"
  }

  network_interface {
    subnetwork ="${google_compute_subnetwork.subnet.name}"
      access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  connection {
    type = "ssh"
    user = "${local.cluster_ssh_user}"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum makecache fast",
      "sudo yum update -y",
      "sudo yum install -y pdsh",
      "sudo systemctl disable firewalld",
      "sudo systemctl stop firewalld",
    ]
  }
}
