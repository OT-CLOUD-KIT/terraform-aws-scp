
AWS Service Control Policy (SCP) Terraform Module
=====================================
[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage]

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png
Service Control Policies (SCPs) are a type of organization policy that are used to manage permissions in the organization. SCPs offer central control over the maximum available permissions for all accounts in the organization.

### ***Note*** : 
* SCPs affect only member accounts in the organization. They have no effect on users or roles in the management account.
* The maximum size of an SCP document is 5,120 characters. 


## Prerequisites
- [AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

 - **IAM Policy:** If a IAM user will be imposing SCP's then it should have a read only access of organization (AWSOrganizationReadOnlyAccess) and for applying scp below permission should be granted : 
 ```
    "organizations:CreatePolicy
    "organizations:AttachPolicy"
    "organizations:TagResource"
``` 

## Module Usage 

Module can be use in 2 different manners : 
* With Default policies enabled
* With combined policies 

### *With Default policies enabled:*
In this below policies will be implemented as default : 
* Deny root user access
* Deny ability to leave Organization
* Deny creation of unencrypted ebs volume
* Deny RDS unencrypted
* Deny unencrypted object uploads statement
```
module "policy" {
  source  = "../../"
  name    = "development" # Policy name

  # Specify target on which policies will be imposed (like OU's or specific account ids)
  targets = var.ou_targets
}
```
### *With Combined policies enabled:*
```
module "policy" {
  source = "../../"
  name   = "development"

  # For denying specific services
  deny_only_approved_services = true
  deny_services             = ["s3:*", "acm:*"]

  # For allowing creation of resoiurces in a specifc region
  region_enforcement = true
  allowed_regions    = ["us-east-1", "ap-south-1"]

  # deny modifying specifc IAM role
  deny_ability_to_modify_specific_IAM_role = true
  protect_iam_role_resources               = ["arn:aws:iam::XXXXXXXXXXXX:role/test-ec2-role"]

  # For denying deleting VPC Flowflogs
  deny_deleting_amazon_VPC_flowlogs = true

  # Require tags on resources
  require_tag_on_specific_resources = true
  actions                           = ["ec2:RunInstances"]
  resources                         = ["arn:aws:ec2:*:*:instance/*"]
  resources_tag = [{
      test     = "Null"
      variable = "Owner"
      values   = ["true"]
  }]

  # Require Instance Metadata Service Version 2
  require_IMDSv2 = true

  # For denying modification of S3 public access 
  deny_modifying_S3_Block_Public_Access  = true
  deny_s3_bucket_public_access_resources = ["arn:aws:s3:::testbucket"]

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
  targets                       = var.ou_targets
}
```

SCP Policies 
------
| Name | Description |
|------|--------|
| deny_only_approved_services | Policy for denying only a set of services only |
| deny_root_user_access | Access to root account will be not allowed |
| region_enforcement |  Allow creating resources in a specific region. |                       
| deny_ability_to_leave_Organization |  Deny child account to leave organization. |          
| deny_ability_to_modify_specific_IAM_role | Deny modification of specific IAM Role. |    
| deny_deleting_amazon_VPC_flowlogs | Deny deletion of VPC flowlogs. |        
| deny_resource_creation_with_no_tag | Specify the resources which should have tags imposed |        
| require_IMDSv2 | Require ec2 to use IMDSv2 |            
| deny_creation_of_unencrypted_ebs_volume | Deny creation of unencrypted ebs. | 
| deny_RDS_unencrypted | Deny creation of unencrypted RDS |        
| deny_unencrypted_object_uploads_statement | Deny uploading unencrypted data in S3. | 
| deny_modifying_S3_Block_Public_Access  | Deny modification of S3 public access. |      
| deny_vpc_modification | Deny creation and modification in vpc. |               
| deny_modifying_IAM_password_policy  | Deny changes to the IAM password policy. |     
| deny_creation_savings_plans |  Deny creation of savings plans. | 
| deny_purchasing_reserved_instances | Deny purchasing of reserved instances. | 
| allow_only_approved_Ec2_instance_types  | Allow creation of specific ec2 instance type |  
| deny_creating_iam_access_keys  | Deny creating iam access keys and iam user. | 

# Inputs :

General Variables
------
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name to be assigned on the policy | `string` | "" | Yes
| type | Type of policy to create. Valid values are AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, SERVICE_CONTROL_POLICY (SCP), and TAG_POLICY. Defaults to SERVICE_CONTROL_POLICY | `string` | SERVICE_CONTROL_POLICY | Yes |
| targets | Lists of OU's or account id's to attach SCP's | `set(string)` | ([]) | Yes |
| tags | Key-value tags to implement on policies. | `map(string)` | {} | No |

SCP Rules Variables
------
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deny_creation_of_unencrypted_ebs_volume | Deny creation of unencrypted ebs. | `bool` | true | No
| deny_RDS_unencrypted | Deny creation of unencrypted RDS | `bool` | true | No                       
| deny_unencrypted_object_uploads_statement | Deny uploading unencrypted data in S3. | `bool` | true | No
| deny_ability_to_leave_Organization | Deny child account to leave organization. | `bool` | true | No
| deny_root_user_access | Access to root account will be not allowed | `bool` | true | No |
| deny_only_approved_services | Policy for denying only a set of services only. For implementing its value must be `true` and also `deny_services` variable should also be passed | `bool` | false | No |
| deny_services | A list of string for denying services in the accounts if `deny_only_approved_services` is `true` | `list(string)` | [] | No |
| region_enforcement | Allow creating resources in a specific region. | `bool` | false | No                   
allowed_regions | Allowed List of regions for creating AWS resources, if `region_enforcement` is `true` | `list(string)` | [] | No                        
deny_ability_to_modify_specific_IAM_role | Deny modification of specific IAM Role. | `bool` | false | No
protect_iam_role_resources | Specify IAM role ARN for protecting it against deleting and modifications , if `deny_ability_to_modify_specific_IAM_role` is `true` | `list(string)` | [] | No
deny_deleting_amazon_VPC_flowlogs | Deny deletion of VPC flowlogs. | `bool` | false | No
deny_resource_creation_with_no_tag |  Specify the resources which should have tags imposed |`bool` | false | No  
actions | AWS actions on which the Deny Creation of Resource With No Tag is imposed, if `deny_resource_creation_with_no_tag` is `true` | `list(string)` | [] | No
resources | ARN's on which the Deny Creation of Resource With No Tag is imposed, if `deny_resource_creation_with_no_tag` is `true` | `list(string)` | [] | No
resourcetag_map | key and value as tags required on resources while creation, if `deny_resource_creation_with_no_tag` is `true`. A single key can be passed with a multiple values  | `list(object)` | [] | No                                                 
require_IMDSv2 | Require ec2 to use IMDSv2 | `bool` | false | No                            
deny_modifying_S3_Block_Public_Access | Deny modification of S3 public access. | `bool` | false | No      
deny_s3_bucket_public_access_resources | Bucket ARN for denying s3 public access, if `deny_modifying_S3_Block_Public_Access` is `true` | `bool` | false | No
deny_vpc_modification | Deny creation and modification in vpc. | `bool` | false | No                      
deny_modifying_IAM_password_policy | Deny changes to the IAM password policy. | `bool` | false | No  
deny_creation_savings_plans | Deny creation of savings plans. | `bool` | false | No    
deny_purchasing_reserved_instances | Deny purchasing of reserved instances. | `bool` | false | No       
allow_only_approved_Ec2_instance_types | Allow creation of specific ec2 instance type | `bool` | false | No   
allowed_ec2_instance_types | Allowed EC2 instances types for creation. | `list(string)` | [] | No                 
deny_creating_iam_access_keys | Deny creating iam access keys and iam user. | `bool` | false | No      

Output
------
| Name | Description |
|------|-------------|
| organizations_policy_id | The unique id of the policy |
| organizations_policy_arn | ARN of the policy |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource 
| [aws_organizations_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource 

### Contributors

|  [Himanshi Parnami][himanshi_homepage] |
|---|

  [himanshi_homepage]: https://github.com/himanshiparnami