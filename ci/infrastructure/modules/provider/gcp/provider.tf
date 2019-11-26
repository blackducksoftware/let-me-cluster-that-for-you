provider "google" {
 credentials ="${var.account_file_path}"
 project = "${local.gcp_project_name}"
 region = "${local.gcp_region}"
 zone = "${local.gcp_zone}"
}
