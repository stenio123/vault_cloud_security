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

# Enable auth backend
resource "vault_auth_backend" "aws" {
  type = "aws"
}

# Create AWS credential for Vault
data "template_file" "vault_aws_auth_policy_template" {
  template = file("${path.module}/vault_iam_policy.json.tpl")

  vars = {
    aws_account_id = var.aws_account_id
    # in order to avoid circular dependencies
    vault_iam_role = "vault_role"
  }
}

resource "aws_iam_user" "vault_demo_user" {
  name = "vault_demo_user"
}

resource "aws_iam_access_key" "vault_demo_user_key" {
  user = aws_iam_user.vault_demo_user.name
}

resource "aws_iam_user_policy" "vault_demo_user_policy" {
  user = aws_iam_user.vault_demo_user.name

  policy = data.template_file.vault_aws_auth_policy_template.rendered
}

resource "vault_aws_auth_backend_client" "aws_client" {
  backend    = vault_auth_backend.aws.path
  access_key = aws_iam_access_key.vault_demo_user_key.id
  secret_key = aws_iam_access_key.vault_demo_user_key.secret
}

# Create a policy for the role
resource "vault_policy" "read_policy" {
  name = "read_secret"

  policy = <<EOT
path "kv1/aws" {
  policy = "read"
}
EOT
}

# Create the role tied to iam
resource "vault_aws_auth_backend_role" "read_role" {
  backend   = vault_auth_backend.aws.path
  role      = "read_role"
  auth_type = "ec2"

  bound_ami_ids = ["${var.ami_id}"]
  bound_account_ids = ["${var.aws_account_id}"]
  # bound_vpc_ids                   = ["vpc-b61106d4"]
  # bound_subnet_ids                = ["vpc-133128f1"]
  # bound_iam_role_arns             = ["arn:aws:iam::123456789012:role/MyRole"]
  # bound_iam_instance_profile_arns = ["arn:aws:iam::123456789012:instance-profile/MyProfile"]
  # inferred_entity_type            = "ec2_instance"
  # inferred_aws_region             = "us-east-1"
  token_ttl      = 60
  token_max_ttl  = 120
  token_policies = ["default", "read_secret"]
}

resource "vault_mount" "example" {
  path        = "kv1"
  type        = "kv"
  options     = { 
    version = "1"
  }
}

# There are many ways of injecting a secret to Vault, this is just one of them
resource "vault_generic_secret" "example" {
  path = "kv1/aws"

  data_json = <<EOT
{
  "foo":   "bar",
  "broccoli": "kale"
}
EOT
}
