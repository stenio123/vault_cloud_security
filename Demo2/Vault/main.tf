provider "aws" {
  # AWS_ACCESS_KEY_ID
  # AWS_SECRET_ACCESS_KEY
  # AWS_DEFAULT_REGION
}

### Vault config

provider "vault" {
  # VAULT_ADDR
  # VAULT_TOKEN
  address = var.vault_addr
  token   = var.vault_token
}

data "template_file" "vault_aws_auth_policy_template" {
  template = file("${path.module}/vault_iam_policy.json.tpl")

  vars = {
    aws_account_id = "${var.aws_account_id}"
  }
}

data "template_file" "dynamic_user_policy_template" {
  template = file("${path.module}/dynamic_user_iam_policy.json.tpl")

  vars = {
    bucket_arn = "${aws_s3_bucket.s3.arn}"
  }
}

# Enable auth backend
resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "stenio" {
  depends_on           = ["vault_auth_backend.userpass"]
  path                 = "auth/userpass/users/stenio"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["access_s3", "default"],
  "password": "changeme"
}
EOT
}

# Create a policy for the role
resource "vault_policy" "access_s3" {
  name = "access_s3"

  policy = <<EOT
path "aws/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}
EOT

}

# Create AWS credential for Vault

resource "aws_iam_user" "vault_demo_user" {
  name = "vault_demo2_user_stenio"
}

resource "aws_iam_access_key" "vault_demo_user_key" {
  user = aws_iam_user.vault_demo_user.name
}

resource "aws_iam_user_policy" "vault_demo_user_policy" {
  user = aws_iam_user.vault_demo_user.name

  policy = data.template_file.vault_aws_auth_policy_template.rendered
}

resource "vault_aws_secret_backend" "aws" {
  access_key = aws_iam_access_key.vault_demo_user_key.id
  secret_key = aws_iam_access_key.vault_demo_user_key.secret
  default_lease_ttl_seconds = "900" #15 minutes
}

resource "vault_aws_secret_backend_role" "role" {
  backend = "${vault_aws_secret_backend.aws.path}"
  name    = "s3_access"
  credential_type = "iam_user"

  policy_document = data.template_file.dynamic_user_policy_template.rendered
}

resource "aws_s3_bucket" "s3" {
  bucket = "vault-demo-test-stenio"
  acl    = "private"

  tags = {
    Name  = "vault-demo-test-stenio"
    ttl   = var.ttl
    owner = var.owner
  }
}