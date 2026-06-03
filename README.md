# GCP Cloud Storage ACL Security Demo

Hands-on infrastructure demo showing how Fine-Grained Access Control Lists (ACLs) in Google Cloud Storage can expose sensitive objects publicly — even inside a private bucket — and how enabling Uniform Bucket-Level Access (UBLA) instantly closes the vulnerability.

Deployed via **Terraform** with a GCS remote backend.

---

## The Problem

Google Cloud Storage offers two access control models:

- **Uniform Bucket-Level Access (UBLA)** — permissions enforced strictly at the bucket boundary. Every object inherits the same IAM policy. Clean, predictable, auditable.
- **Fine-Grained ACL** — each object can have its own independent permissions, completely overriding the bucket policy. One misconfigured ACL entry can expose a sensitive file to the entire internet — without the bucket ever being made public.

This demo provisions both scenarios and lets you verify the behavior in real time.

---

## What Gets Deployed

| Resource | Description |
|---|---|
| `internal-financial-vault-demo` | Cloud Storage bucket with fine-grained ACL enabled |
| `secured-doc.pdf` | Internal document scoped to a named user only |
| `unsecured-doc.pdf` | Sensitive financial report exposed via `allUsers` ACL |

---

## Prerequisites

- GCP account with billing enabled
- `gcloud` CLI installed and authenticated
- `terraform` CLI installed
- Owner or Storage Admin IAM role on the target project

---

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/jaycloud336/gcp-acl-security-demo.git
cd gcp-acl-security-demo
```

### 2. Create the Terraform state bucket

Terraform requires a GCS bucket to store remote state. Create it once before anything else:

```bash
gcloud storage buckets create gs://acl-demo-tfstate-<your-initials> \
  --location=us-central1 \
  --project=your-project-id
```

> This bucket must exist before running `terraform init`. It is not managed by Terraform itself.

### 3. Create your `terraform.tfvars`

```bash
cat > terraform.tfvars <<EOF
project_id      = "your-project-id"
bucket_name     = "internal-financial-vault-demo"
authorized_user = "your-email@gmail.com"
EOF
```

> `terraform.tfvars` is gitignored — your credentials stay local.

### 4. Initialize Terraform

```bash
terraform init
```

This connects Terraform to the remote state bucket and downloads the GCP provider.

### 5. Deploy the vulnerable configuration

```bash
terraform apply
```

### 6. Get document URLs

```bash
terraform output
```

---

## Expected Behavior

### Before UBLA — Vulnerable (Fine-Grained)

| Document | Public URL | Authenticated URL |
|---|---|---|
| `secured-doc.pdf` | ❌ Document access denied | ✅ Named user only |
| `unsecured-doc.pdf` | ✅ Document accessible | ✅ Document accessible |

### After UBLA — Fixed

| Document | Public URL | Authenticated URL |
|---|---|---|
| `secured-doc.pdf` | ❌ Document access denied | ❌ Document access denied |
| `unsecured-doc.pdf` | ❌ Document access denied | ❌ Document access denied |

---

## Applying the Fix

### 1. Enable UBLA

In `01-main.tf` change one line:

```hcl
uniform_bucket_level_access = true
```

### 2. Remove ACL resources from Terraform state

Once UBLA is enabled, GCP deactivates all object-level ACLs on the bucket. They become completely inert — the GCP API will no longer accept ACL operations on a UBLA-enabled bucket. If you leave the ACL resources in state and re-run `terraform apply`, Terraform will attempt to reconcile them and throw errors.

Remove them from state before reapplying:

```bash
terraform state rm google_storage_bucket_acl.financial_doc_acl
terraform state rm google_storage_bucket_acl.secured_doc_acl
```

This tells Terraform to stop managing those resources without destroying anything in GCP. Your state file will then accurately reflect reality.

> **Note:** This is a deliberate example of state drift — where a real-world infrastructure change (enabling UBLA) puts Terraform state out of sync with actual GCP behavior, requiring manual state surgery to realign.

### 3. Redeploy

```bash
terraform apply
```

---

## Tear Down

```bash
terraform destroy
```

---

## Project Structure
---

## Project Structure

```
gcp-acl-security-demo/
├── docs/
│   ├── secured-doc.pdf
│   └── unsecured-doc.pdf
├── .gitignore
├── 00-provider.tf
├── 01-main.tf
├── 02-variables.tf
├── 03-outputs.tf
├── README.md
└── terraform.tfvars        ← create your own .tfvars file
```

---

## Related Content

- 📺 Walkthrough video — *coming soon* - https://www.youtube.com/@PodTalk-k8
