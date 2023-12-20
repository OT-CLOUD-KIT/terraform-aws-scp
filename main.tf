resource "aws_organizations_policy" "scp" {
  name        = var.name
  description = "${var.name}-scp"
  content     = data.aws_iam_policy_document.scp_policy.json
  type        = var.type
  tags        = merge(
    {
      Name = format("%s", var.name)
    },
    var.tags
  )
}

resource "aws_organizations_policy_attachment" "scp_attachment" {
  for_each  = var.targets
  policy_id = join("", aws_organizations_policy.scp.*.id)
  target_id = each.value
}