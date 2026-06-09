# Terraform Infrastructure

Manages ALB, ACM certificates, and Route53 DNS for prod and staging.

- **Prod:** `rulebook.unicycling-software.com`
- **Staging:** `rulebooktest.unicycling-software.com`

State is stored in S3 (`unicycling-rulebook-terraform-state`), locked via `use_lockfile` (Terraform ≥ 1.10, no DynamoDB needed).

## Prerequisites

```bash
brew install terraform   # or brew upgrade terraform
terraform version        # must be >= 1.10
aws sts get-caller-identity  # confirm AWS credentials are active
```

---

## Step 1: Bootstrap (one-time only)

Creates the S3 bucket used to store Terraform state. Run once; never run again.

```bash
cd terraform/bootstrap
terraform init
terraform apply
cd -
```

---

## Step 2: Gather AWS resource IDs

Run these CLI commands to populate the `terraform.tfvars` files in `prod/` and `staging/`.

```bash
# Route53 hosted zone
aws route53 list-hosted-zones \
  --query "HostedZones[?contains(Name,'unicycling-software.com')].{Id:Id,Name:Name}" \
  --output table

# Prod EC2: instance ID, VPC ID, subnet, security group
aws ec2 describe-instances \
  --filters "Name=ip-address,Values=54.148.66.79" \
  --query "Reservations[].Instances[].[InstanceId,VpcId,SubnetId,SecurityGroups[0].GroupId]" \
  --output table

# Staging EC2
aws ec2 describe-instances \
  --filters "Name=ip-address,Values=52.25.119.104" \
  --query "Reservations[].Instances[].[InstanceId,VpcId,SubnetId,SecurityGroups[0].GroupId]" \
  --output table

# All subnets in the VPC — pick 2+ in different AZs for the ALB (use public subnets)
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=vpc-e113c084" \
  --query "Subnets[].[SubnetId,AvailabilityZone,MapPublicIpOnLaunch]" \
  --output table

# Existing Route53 A records (needed for the import step)
aws route53 list-resource-record-sets \
  --hosted-zone-id /hostedzone/Z1NYSHL8JOE6MN \
  --query "ResourceRecordSets[?Type=='A']" --output json
```

Fill the results into `prod/terraform.tfvars` and `staging/terraform.tfvars`.

---

## Step 3: Apply (two-step, per environment)

No import needed — `dns.tf` uses `allow_overwrite = true` so Terraform will replace the existing direct-to-EC2 A record automatically.

The two-step approach is required because `aws_route53_record.acm_validation` uses `for_each` over the cert's validation options, which are only known after the cert is created. Creating the cert first makes the second apply fully deterministic.

### Staging

```bash
cd terraform

terraform init -backend-config=staging/backend.tfvars -reconfigure

# Step 3a: create the ACM cert so its validation domains become known
terraform apply -target=aws_acm_certificate.app -var-file=staging/terraform.tfvars

# Step 3b: apply everything (creates ALB, listeners, validation records, flips DNS)
terraform apply -var-file=staging/terraform.tfvars
```

### Prod (after staging is validated)

```bash
terraform init -backend-config=prod/backend.tfvars -reconfigure

terraform apply -target=aws_acm_certificate.app -var-file=prod/terraform.tfvars

terraform apply -var-file=prod/terraform.tfvars
```

---

## Day-to-day usage

### Apply to staging

```bash
cd terraform

terraform init \
  -backend-config=staging/backend.tfvars -reconfigure

terraform plan \
  -var-file=staging/terraform.tfvars

terraform apply \
  -var-file=staging/terraform.tfvars
```

### Apply to prod

```bash
cd terraform

terraform init \
  -backend-config=prod/backend.tfvars -reconfigure

terraform plan \
  -var-file=prod/terraform.tfvars

terraform apply \
  -var-file=prod/terraform.tfvars
```

> **Note:** `-reconfigure` is required when switching between environments because the S3 backend key changes. It does not destroy or migrate state.

---

## Verification after apply

```bash
# Check cert was issued
aws acm list-certificates --region us-west-2 --output table

# Check ALB target health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)

# End-to-end HTTPS check
curl -I https://rulebooktest.unicycling-software.com
curl -I https://rulebook.unicycling-software.com
```

---

## After successful cutover

Remove the ACME cron job from each EC2 — ACM auto-renews certificates, so it is no longer needed:

```bash
ssh ec2-user@<instance-ip>
crontab -e   # delete the certbot/acme renewal line
```
