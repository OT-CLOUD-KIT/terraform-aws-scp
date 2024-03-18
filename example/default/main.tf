provider "aws" {
  region = var.region
}

module "policy" {
  source  = "../../"
  scp_policy_name    = "development" # Policy name

  # Specify target on which policies will be imposed (like OU's or specific account ids)
  scp_targets = var.ou_targets
}