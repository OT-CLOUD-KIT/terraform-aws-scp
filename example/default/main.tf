provider "aws" {
  region = var.region
}

module "policy" {
  source  = "../../"
  name    = "development-scp" # Policy name

  # Specify target on which policies will be imposed (like OU's or specific account ids)
  targets = var.ou_targets
}