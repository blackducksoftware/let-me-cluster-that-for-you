remote_state {
  backend = "gcs"
    config = {
      bucket         = "onprem-terragrunt-tf-state"
      prefix         = "google/${get_env("TF_VAR_region", "")}/${get_env("TF_VAR_cluster_name", "")}/${path_relative_to_include()}"
 }
}
