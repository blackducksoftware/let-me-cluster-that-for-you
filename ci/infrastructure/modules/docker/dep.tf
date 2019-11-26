resource "null_resource" "dummy_dep" {
  depends_on = [
    "null_resource.docker-start",
  ]
}
