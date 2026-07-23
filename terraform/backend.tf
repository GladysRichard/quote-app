terraform {
  backend "s3" {
    bucket = "gladys-quote-app-terraform-state"
    key    = "quote-app/terraform.tfstate"
    region = "eu-west-2"
  }
}