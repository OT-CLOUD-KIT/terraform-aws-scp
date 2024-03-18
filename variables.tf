variable scp_policy_name {
  type        = string
  description = "Name that is to be assigned to the policy"
  default     = ""
}

variable scp_policy_type {
  type        = string
  description = "The type of policy to create. Valid values are AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, SERVICE_CONTROL_POLICY (SCP), and TAG_POLICY. Defaults to SERVICE_CONTROL_POLICY"
  default     = "SERVICE_CONTROL_POLICY"
}

variable scp_tags {
  type        = map(string)
  description = "Key-value map of resource tags."
  default     = {}
}

variable scp_targets {
  type        = set(string)
  description = "Lists of OU and account id's to attach SCP"
  default     = ([])
}

variable deny_only_approved_services {
  type        = bool
  description = "Allow creation of only approved services."
  default     = false
}

variable deny_services {
  type        = list(string)
  description = "A list of string for allowed services to use in the accounts if `allow_only_approved_services` is `true"
  default     = [""]
}

variable deny_root_user_access {
  type        = bool
  description = "Deny usage of AWS account root."
  default     = true
}

variable region_enforcement {
  type        = bool
  description = "Allow creating resources in a specific region."
  default     = false
}

variable allowed_regions {
  type        = list(string)
  description = "AWS Regions allowed."
  default     = [""]
}

variable deny_ability_to_leave_Organization {
  type        = bool
  description = "Deny child account to leave organization."
  default     = true
}

variable deny_ability_to_modify_specific_IAM_role {
  type        = bool
  description = "Deny modification of specific IAM Role."
  default      = false
}

variable "protect_iam_role_resources" {
  description = "IAM role resource ARNs to protect from modification and deletion."
  type        = list(string)
  default     = [""]
}

variable deny_deleting_amazon_VPC_flowlogs {
  type        = bool
  description = "Deny deletion of VPC flowlogs."
  default     = false
}

variable deny_resource_creation_with_no_tag {
  type        = bool
  description = "Require specific tag on resources."
  default     = false
}

variable "actions_denied_incase_no_tags" {
  type    = list(string)
  description = "AWS actions on which the Deny Creation of Resource With No Tag is imposed"
  default = []
}

variable "selected_resources_arns" {
  type    = list(string)
  description = "ARN's on which the Deny Creation of Resource With No Tag is imposed"
  default = []
}

variable "resources_tag" {
   type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  description = "key and value as tags required on resources while creation"
  default = []
}

variable require_IMDSv2 {
  type        = bool
  description = "Require ec2 to use v2"
  default     = false
}

variable deny_creation_of_unencrypted_ebs_volume {
  type        = bool
  description = "Deny craetion of unencrypted ebs."
  default     = true
}

variable deny_RDS_unencrypted {
  type        = bool
  description = "Deny creation of unencrypted RDS."
  default     = true
}

variable deny_unencrypted_object_uploads_statement {
  type        = bool
  description = "Deny uploading unencrypted data in S3."
  default     = true
}

variable deny_modifying_S3_Block_Public_Access {
  type        = bool
  description = "Deny modification of S3 public access."
  default     = false
}

variable deny_s3_bucket_public_access_resources {
  type        = list(string)
  description = "Bucket ARN for denying s3 public access."
  default     = [""]
}

variable deny_vpc_modification {
  type        = bool
  description = "Deny creation and modification in vpc."
  default     = false
}

variable deny_modifying_IAM_password_policy {
  type        = bool
  description = "Deny changes to the IAM password policy."
  default     = false
}

variable deny_creation_savings_plans {
  type        = bool
  description = "Deny creation of savings plans."
  default     = false
}

variable deny_purchasing_reserved_instances {
  type        = bool
  description = "Deny purchasing of reserved instances."
  default     = false
}

variable allow_only_approved_Ec2_instance_types {
  type        = bool
  description = "Allow creation of specific ec2 instance type"
  default     = false
}

variable allowed_ec2_instance_types {
  type        = list(string)
  description = "EC2 instances types allowed."
  default     = [""]
}

variable deny_creating_iam_access_keys {
  type        = bool
  description = "Deny creating iam access keys and iam user."
  default     = false
}
