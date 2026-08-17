terraform {
  backend "s3" {
    bucket       = "enterprise-terraform-state-984285320293"
    key          = "prod/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}