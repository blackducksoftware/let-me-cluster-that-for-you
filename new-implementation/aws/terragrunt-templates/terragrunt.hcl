remote_state {
  backend = "gcs"
    config = {
      bucket         = "onprem-terragrunt-tf-state"
      prefix         = "aws/${path_relative_to_include()}"
 }
}
