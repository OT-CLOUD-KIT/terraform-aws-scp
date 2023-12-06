provider "aws" {
  profile = "default"
}

module "deny_policy" {
  source                  = "../../"
  name                    =  "development"
  targets                  =  ["ou-9cz1-52kkfm0o"]
  deny_all                = true
}