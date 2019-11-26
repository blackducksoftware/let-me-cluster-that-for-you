resource "google_compute_firewall" "internal" {
    name = "${var.prefix}-internal"
    network = "${google_compute_network.cluster.name}"

	allow {
	  protocol = "all"
    }

    source_ranges = ["${google_compute_subnetwork.subnet.ip_cidr_range}"]
}

resource "google_compute_firewall" "http" {
    name = "${var.prefix}-${local.gcp_region}-http"
    network = "${google_compute_network.cluster.name}"

    allow {
        protocol = "tcp"
        ports = ["80","8080"]
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "https" {
    name = "${var.prefix}-${local.gcp_region}-https"
    network = "${google_compute_network.cluster.name}"

    allow {
        protocol = "tcp"
        ports = ["443","8443"]
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh_allow" {
    name = "${var.prefix}-${local.gcp_region}-ssh"
    network = "${google_compute_network.cluster.name}"
    allow {
        protocol = "tcp"
        ports = ["22"]
    }
    source_ranges = ["${var.ssh_source_range_ips}"]
}
