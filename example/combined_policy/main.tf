provider "aws" {
  profile = "default"
}

module "policy" {
    source                                      = "../../"
    name                                        =  "development"
    allow_only_approved_services                = false 
    allowed_services                            = ["ec2:*","s3:*","acm:*","route53:*"]
    deny_root_user_access                       = false 
    region_enforcement                          = false   
    allowed_regions                             = ["us-east-1", "ap-south-1"] 
    deny_ability_to_leave_Organization          = false 
    deny_ability_to_modify_specific_IAM_role    = false 
    protect_iam_role_resources                  = ["arn:aws:iam::XXXXXXXXXXXX:role/test-ec2-role"]
    deny_deleting_amazon_VPC_flowlogs           = false 
    require_tag_on_specific_resources           = false  
    resourcetag_key                             = "Env"
    resourcetag_value                           = ["true"]
    require_IMDSv2                              = false 
    deny_creation_of_unencrypted_ebs_volume     = false 
    deny_RDS_unencrypted                        = false 
    deny_unencrypted_object_uploads_statement   = false 
    deny_modifying_S3_Block_Public_Access       = false 
    deny_s3_bucket_public_access_resources      = ["arn:aws:s3:::testbucket"]
    deny_vpc_modification                       = false 
    deny_modifying_IAM_password_policy          = false 

    deny_creation_savings_plans                 = false
    deny_purchasing_reserved_instances          = false
     
    allow_only_approved_Ec2_instance_types      = false 
    allowed_ec2_instance_types                  = ["*.nano"]
    deny_creating_iam_access_keys               = false     
    targets                                     = var.ou_targets
}
