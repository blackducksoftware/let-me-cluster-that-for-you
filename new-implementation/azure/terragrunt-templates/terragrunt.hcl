remote_state {
  backend = "gcs"
    config = {
      bucket         = "onprem-terragrunt-tf-state"
      prefix         = "azure/${path_relative_to_include()}"
 }
}
