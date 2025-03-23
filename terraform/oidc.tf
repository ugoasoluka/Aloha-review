#OIDC

data "aws_partition" "current" {}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url = aws_eks_cluster.aloha_eks_cluster.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.${data.aws_partition.current.dns_suffix}"
  ]

  tags = {
    Name = "external-dns-irsa"
  }
}

output "aws_iam_openid_connect_arn" {
  description = "ARN assigned by AWS for this provider"
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

locals {
  aws_iam_openid_connect_provider_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}

output "aws_iam_openid_connect_arn_extract" {
  description = "OpenID connect provider extracted from ARN"
  value       = local.aws_iam_openid_connect_provider_extract_from_arn
}
