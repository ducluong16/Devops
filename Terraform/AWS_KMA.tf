# Cấu hình provider cho AWS
provider "aws" {
  region = "us-east-1"
}

# ----------------------
# Tạo Nhóm IAM
# ----------------------

# Nhóm Admin với toàn quyền truy cập
resource "aws_iam_group" "admin_group" {
  name = "AdminGroup"
}

resource "aws_iam_group_policy" "admin_policy" {
  group = aws_iam_group.admin_group.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

# Nhóm Developers với quyền truy cập EC2 và RDS
resource "aws_iam_group" "developers_group" {
  name = "DevelopersGroup"
}

resource "aws_iam_group_policy" "dev_policy" {
  group = aws_iam_group.developers_group.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:*",
          "rds:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Nhóm Finance với quyền đọc dữ liệu từ S3
resource "aws_iam_group" "finance_group" {
  name = "FinanceGroup"
}

resource "aws_iam_group_policy" "finance_policy" {
  group = aws_iam_group.finance_group.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::company-reports",
          "arn:aws:s3:::company-reports/*"
        ]
      }
    ]
  })
}

# ----------------------
# Tạo Người dùng IAM
# ----------------------

# Người dùng cho Admin
resource "aws_iam_user" "admin_user1" {
  name = "AdminUser1"
}

resource "aws_iam_user_group_membership" "admin_user1_membership" {
  user = aws_iam_user.admin_user1.name
  groups = [aws_iam_group.admin_group.name]
}

resource "aws_iam_user" "admin_user2" {
  name = "AdminUser2"
}

resource "aws_iam_user_group_membership" "admin_user2_membership" {
  user = aws_iam_user.admin_user2.name
  groups = [aws_iam_group.admin_group.name]
}

# Người dùng cho Developers
resource "aws_iam_user" "dev_user1" {
  name = "DevUser1"
}

resource "aws_iam_user_group_membership" "dev_user1_membership" {
  user = aws_iam_user.dev_user1.name
  groups = [aws_iam_group.developers_group.name]
}

resource "aws_iam_user" "dev_user2" {
  name = "DevUser2"
}

resource "aws_iam_user_group_membership" "dev_user2_membership" {
  user = aws_iam_user.dev_user2.name
  groups = [aws_iam_group.developers_group.name]
}

# Người dùng cho Finance
resource "aws_iam_user" "finance_user1" {
  name = "FinanceUser1"
}

resource "aws_iam_user_group_membership" "finance_user1_membership" {
  user = aws_iam_user.finance_user1.name
  groups = [aws_iam_group.finance_group.name]
}

resource "aws_iam_user" "finance_user2" {
  name = "FinanceUser2"
}

resource "aws_iam_user_group_membership" "finance_user2_membership" {
  user = aws_iam_user.finance_user2.name
  groups = [aws_iam_group.finance_group.name]
}

# ----------------------
# Tạo Vai trò IAM cho EC2
# ----------------------

resource "aws_iam_role" "ec2_role" {
  name = "EC2Role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  role = aws_iam_role.ec2_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::company-reports",
          "arn:aws:s3:::company-reports/*"
        ]
      }
    ]
  })
}
