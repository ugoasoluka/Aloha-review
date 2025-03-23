## Service account creation

resource "aws_iam_role" "external_dns_iam_role" {
  name = "external-dns-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
        }
        Condition = {
          StringEquals = {
            "${local.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:external-dns:external-dns"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "external-dns-irsa-role"
  }
}

# Create a New IAM Policy for Route 53 record creation
resource "aws_iam_policy" "external_dns_policy" {
  name        = "external-dns-route53-policy"
  description = "IAM policy for External DNS to manage Route 53 records for ugo-projects.click"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = "arn:aws:route53:::hostedzone/Z02610481DRTYYM366S17"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones"
        ]
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "external_dns_attachment" {
  role       = aws_iam_role.external_dns_iam_role.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}

output "external_dns_iam_role_arn" {
  description = "IRSA IAM Role ARN"
  value       = aws_iam_role.external_dns_iam_role.arn
}

