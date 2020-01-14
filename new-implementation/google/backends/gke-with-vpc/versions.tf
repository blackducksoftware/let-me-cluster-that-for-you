terraform {
  required_version = ">= 0.12"
  required_providers {
    google     = "~> 2.19"
    null       = "~> 2.1"
    random     = "~> 2.2"
    kubernetes = "~> 1.10"
    local      = "~> 1.4"
    template   = "~> 2.1"
  }
}
