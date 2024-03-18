output "organizations_policy_id" {
  value       = join("", aws_organizations_policy.scp.*.id)
  description = "The unique id of the policy"
}

output "organizations_policy_arn" {
  value       = join("", aws_organizations_policy.scp.*.arn)
  description = "ARN of the policy"
}