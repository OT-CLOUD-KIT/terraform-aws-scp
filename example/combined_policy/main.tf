provider "aws" {
  region = var.region
}

module "policy" {
  source = "../../"
  name   = "development-scp" # Policy name

  # For allowing specific services
  allow_only_approved_services = true
  allowed_services             = ["ec2:*", "s3:*", "acm:*", "route53:*"]

  # For allowing creation of resources in a specifc region
  region_enforcement = true
  allowed_regions    = ["us-east-1", "ap-south-1"]

  # deny modifying specifc IAM role
  deny_ability_to_modify_specific_IAM_role = true
  protect_iam_role_resources               = ["arn:aws:iam::XXXXXXXXXXXX:role/ROLENAME"]

  # For denying deleting VPC Flowflogs
  deny_deleting_amazon_VPC_flowlogs = true

  # Require tags on resources
  deny_resource_creation_with_no_tag = true
  actions                           = ["ec2:RunInstances"]
  resources                         = ["arn:aws:ec2:*:*:instance/*"]
  resources_tag = [{
      test     = "Null"
      variable = "env"
      values   = ["dev"]
    }]

  # Require Instance Metadata Service Version 2
  require_IMDSv2 = true

  # For denying modification of S3 public access 
  deny_modifying_S3_Block_Public_Access  = true
  deny_s3_bucket_public_access_resources = ["arn:aws:s3:::S3BUCKETNAME"]

  # Deny VPC modification and deletion
  deny_vpc_modification = true

  deny_modifying_IAM_password_policy = true

  deny_creation_savings_plans        = true
  deny_purchasing_reserved_instances = true

  # Allow only specific instance types ec2 to create
  allow_only_approved_Ec2_instance_types = true
  allowed_ec2_instance_types             = ["*.nano"]

  deny_creating_iam_access_keys = true

  # Specify target on which policies will be imposed (like OU's or specific account ids)
  targets = var.ou_targets
}
