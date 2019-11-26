locals {
  docker_pkg = "${lower(var.docker_version) != "os" ? "docker-ce-${var.docker_version}.ce" : "docker"}"
}
