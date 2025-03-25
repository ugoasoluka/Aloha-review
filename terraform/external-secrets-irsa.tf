## Service account creation

resource "aws_iam_role" "external_secrets_iam_role" {
  name = "external-secrets-role"
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
            "${local.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:external-secrets:external-secrets"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "external-secrets-irsa-role"
  }
}

# Create a New IAM Policy for Route 53 record creation
resource "aws_iam_policy" "external_secrets_policy" {
  name        = "external-secrets-operator-policy"
  description = "IAM policy for External Secrets Operator to read secrets from AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets"
        ]
        Resource = "arn:aws:secretsmanager:us-east-1:767828724853:secret:tasky-app-secrets-8fXOww"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "external_secret_attachment" {
  role       = aws_iam_role.external_secrets_iam_role.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}

output "external_secrets_iam_role_arn" {
  description = "IRSA IAM Role ARN"
  value       = aws_iam_role.external_secrets_iam_role.arn
}

