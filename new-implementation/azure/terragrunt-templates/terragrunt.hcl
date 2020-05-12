remote_state {
  backend = "gcs"
    config = {
      bucket         = "onprem-terragrunt-tf-state"
      prefix         = "azure/${get_env("TF_VAR_location", "")}/${get_env("TF_VAR_cluster_name", "")}/${path_relative_to_include()}"
 }
}
