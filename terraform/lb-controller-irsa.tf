## Service account creation

resource "aws_iam_role" "alb_controller_iam_role" {
  name = "aws-load-balancer-controller-role"
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
            "${local.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "aws-load-balancer-controller-irsa"
  }
}

# Create a New IAM Policy for Route 53 record creation
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/alb-controller-policy.json")
}



resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_controller_iam_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

output "alb_controller_iam_role_arn" {
  description = "IRSA IAM Role ARN"
  value       = aws_iam_role.alb_controller_iam_role.arn
}

