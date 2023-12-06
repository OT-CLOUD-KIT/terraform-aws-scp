data "aws_iam_policy_document" "deny_all_access" {

    statement {
      sid       = "DenyAllAccess"
      effect    = "Deny"
      actions   = ["*"]
      resources = ["*"]
    }
}

data "aws_iam_policy_document" "scp_policy" {

    dynamic "statement" {
        for_each = local.allow_only_approved_services
        content {
            sid       = "AllowOnlyApprovedServices"
            effect    = "Allow"
            actions   = var.allowed_services
            resources = ["*"]
        }
    }

    dynamic "statement" {
        for_each = local.deny_root_user_access
        content {
            sid       = "DenyRootAccount"
            actions   = ["*"]
            resources = ["*"]
            effect    = "Deny"
            condition {
              test     = "StringLike"
              variable = "aws:PrincipalArn"
              values   = ["arn:aws:iam::*:root"]
            }
        }
    }

    dynamic "statement" {
        for_each = local.region_enforcement
        content {
            sid       = "RestrictRegion"
            effect    = "Deny"
            actions   = ["*"]
            resources = ["*"]
            condition {
              test     = "StringNotEquals"
              variable = "aws:RequestedRegion"
              values   = var.allowed_regions
            }
        }
    }

    dynamic "statement" {
        for_each = local.deny_ability_to_leave_Organization
        content {
            sid       = "DenyLeavingOrgs"
            effect    = "Deny"
            actions   = ["organizations:LeaveOrganization"]
            resources = ["*"]
        }
    }

    dynamic "statement" {
        for_each = local.deny_ability_to_modify_specific_IAM_role
        content {
            sid       = "DenyAccessToASpecificRole"
            effect    = "Deny"
            actions   = ["iam:AttachRolePolicy", "iam:DeleteRole", "iam:DeleteRolePermissionsBoundary", "iam:DeleteRolePolicy", "iam:DetachRolePolicy", "iam:PutRolePermissionsBoundary", "iam:PutRolePolicy", "iam:UpdateAssumeRolePolicy", "iam:UpdateRole", "iam:UpdateRoleDescription"]
            resources = var.protect_iam_role_resources
        }
    }

    dynamic "statement" {
        for_each = local.deny_deleting_amazon_VPC_flowlogs
        content {
            sid         = "DenyDeletingAmazonVPCFlowlogs"
            effect      = "Deny"
            actions     = ["ec2:DeleteFlowLogs", "logs:DeleteLogGroup", "logs:DeleteLogStream"]
            resources   = ["*"]
        }
    }

    dynamic "statement" {
        for_each = local.require_tag_on_specific_resources
        content{
            sid             = "DenyCreateResourceWithNoTag"
            effect          = "Deny"
            actions         = ["ec2:RunInstances"]
            resources       = ["arn:aws:ec2:*:*:instance/*"]
            condition {
                test        = "Null"
                variable    = "aws:RequestTag/${var.resourcetag_key}"
                values      = var.resourcetag_value
            }
        }
    }

    dynamic "statement" {
        for_each = local.require_IMDSv2
        content {
            sid             = "RequireImdsV2"
            effect          = "Deny"
            actions         = ["ec2:RunInstances"]
            resources       = ["arn:aws:ec2:*:*:instance/*"]
            condition {
                test        = "StringNotEquals"
                variable    = "ec2:MetadataHttpTokens"
                values      = ["required"]
            }
        }
    }

    dynamic "statement" {
        for_each = local.deny_creation_of_unencrypted_ebs_volume
        content{
            sid             = "DenyCreatingunencryptedEBSVolume"
            effect          = "Deny"
            actions         = ["ec2:CreateVolume"]
            resources       = ["*"]
            condition {
                test        = "Bool"
                variable    = "ec2:Encrypted"
                values      = ["false"]
            }
        }
    }

    dynamic "statement" {
        for_each = local.deny_RDS_unencrypted
        content {
            sid             = "DenyRDSunencrypted"
            effect          = "Deny"
            actions         = ["rds:CreateDBInstance","rds:CreateDBCluster"]
            resources       = ["*"]
            condition {
                test        = "Bool"
                variable    = "rds:StorageEncrypted"
                values      = ["false"]
            }
        }
    }
    
    dynamic "statement" {
        for_each = local.deny_unencrypted_object_uploads_statement
        content {
            sid       = "DenyUnEncryptedObjectUploads"
            effect    = "Deny"
            actions   = ["s3:PutObject"]
            resources = ["*"]
            condition {
              test     = "Null"
              variable = "s3:x-amz-server-side-encryption"
              values   = [true]
            }
        }
    }

    dynamic "statement" {
        for_each = local.deny_modifying_S3_Block_Public_Access
        content {
            sid         = "DenyModifyingS3BlockPublicAccess"
            effect      = "Deny"
            actions     = ["s3:PutBucketPublicAccessBlock", "s3:DeletePublicAccessBlock"]
            resources   = var.deny_s3_bucket_public_access_resources
        }
    }

    dynamic "statement" {
        for_each = local.deny_vpc_modification
        content {
            sid         = "DenyVPCModification"
            effect      = "Deny"
            actions     = ["ec2:CreateNatGateway", "ec2:CreateInternetGateway","ec2:DeleteNatGateway","ec2:AttachInternetGateway","ec2:DeleteInternetGateway","ec2:DetachInternetGateway","ec2:CreateClientVpnRoute","ec2:AttachVpnGateway","ec2:DisassociateClientVpnTargetNetwork", "ec2:DeleteClientVpnEndpoint", "ec2:DeleteVpcPeeringConnection", "ec2:AcceptVpcPeeringConnection", "ec2:CreateNatGateway","ec2:ModifyClientVpnEndpoint","ec2:CreateVpnConnectionRoute","ec2:RevokeClientVpnIngress","ec2:RejectVpcPeeringConnection","ec2:DetachVpnGateway","ec2:DeleteVpnConnectionRoute","ec2:CreateClientVpnEndpoint","ec2:AuthorizeClientVpnIngress","ec2:DeleteVpnGateway","ec2:TerminateClientVpnConnections","ec2:DeleteClientVpnRoute","ec2:ModifyVpcPeeringConnectionOptions","ec2:CreateVpnGateway","ec2:DeleteNatGateway","ec2:DeleteVpnConnection","ec2:CreateVpcPeeringConnection","ec2:CreateVpnConnection"]
            resources   = ["*"]
        }
    }

    dynamic "statement" {
        for_each = local.deny_modifying_IAM_password_policy
        content {
            sid         = ""
            effect      = "Deny"
            actions     = ["iam:DeleteAccountPasswordPolicy", "iam:UpdateAccountPasswordPolicy"]
            resources   = ["*"]
            condition {
                test        = "StringNotEquals"
                variable    = "aws:PrincipalARN"
                values      = ["arn:aws:iam::*:role/"]
            }
        }
    }

    dynamic "statement" {
        for_each    = local.deny_creation_savings_plans
        content {
            sid         = "DenyAccessToCreateSavingsPlans"
            effect      = "Deny"
            actions     = ["savingsplans:CreateSavingsPlans"]
            resources   = ["*"]
            condition {
                test        = "StringNotLike"
                variable    = "aws:PrincipalArn"
                values      = ["arn:aws:iam::*:role/"]
                # var.
            }
        }
    }

    dynamic "statement" {
        for_each    = local.deny_purchasing_reserved_instances
        content {
            sid         = "DenyAccessToRI"
            effect      = "Deny"
            actions     = ["ec2:PurchaseReservedInstancesOffering", "ec2:AcceptReservedInstancesExchangeQuote", "ec2:CancelCapacityReservation", "ec2:CancelReservedInstancesListing", "ec2:CreateCapacityReservation", "ec2:CreateReservedInstancesListing"]
            resources   = ["*"]
            condition {
                test        = "StringNotLike"
                variable    = "aws:PrincipalArn"
                values      = ["arn:aws:iam::*:role/"]
            }
        }
    }

    dynamic "statement" {
        for_each = local.allow_only_approved_Ec2_instance_types
        content {
            sid    = "RequiredInstanceType"
            effect = "Deny"
            actions =  ["ec2:RunInstances", "ec2:StartInstances"]
            resources = ["arn:aws:ec2:*:*:instance/*"]
            condition {
              test    = "StringNotLike"
              variable = "ec2:InstanceType"
              values   = var.allowed_ec2_instance_types
            }
        }
    }

    dynamic "statement" {
        for_each = local.deny_creating_iam_access_keys
        content {
            sid       = "DenyCreatingIAMAccessKeys"
            effect    = "Deny"
            actions   = ["iam:CreateAccessKey", "iam:CreateUser"]
            resources = ["*"]
        }
    }
    
}
