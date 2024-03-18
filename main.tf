resource "aws_organizations_policy" "scp" {
  name        = var.scp_policy_name
  description = "${var.scp_policy_name}-scp"
  content     = data.aws_iam_policy_document.scp_policy.json
  type        = "SERVICE_CONTROL_POLICY"
  tags        = merge(
    {
      Name = format("%s", var.scp_policy_name)
    },
    var.scp_tags
  )
}

resource "aws_organizations_policy_attachment" "scp_attachment" {
  for_each  = var.scp_targets
  policy_id = join("", aws_organizations_policy.scp.*.id)
  target_id = each.value
}