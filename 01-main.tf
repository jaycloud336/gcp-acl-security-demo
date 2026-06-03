# The bucket itself appears private
resource "google_storage_bucket" "corporate_vault" {
  name                        = var.bucket_name
  location                    = upper(var.region)
  uniform_bucket_level_access = true # Fine-grained ACL enabled — vulnerable
  force_destroy               = true
}

# Secured document — upload
resource "google_storage_bucket_object" "secured_doc" {
  name         = "secured-doc.pdf"
  bucket       = google_storage_bucket.corporate_vault.name
  source       = "./docs/secured-doc.pdf"
  content_type = "application/pdf"
}

# Secured document — scoped to named user only
# resource "google_storage_object_acl" "secured_doc_acl" {
#   bucket = google_storage_bucket.corporate_vault.name
#   object = google_storage_bucket_object.secured_doc.name

#   role_entity = [
#     "OWNER:user-${var.authorized_user}"  # Note: use READER if authorized_user is not the project owner
# ]
# }

# Financial document — upload
resource "google_storage_bucket_object" "financial_report" {
  name         = "unsecured-doc.pdf"
  bucket       = google_storage_bucket.corporate_vault.name
  source       = "./docs/unsecured-doc.pdf"
  content_type = "application/pdf"
}

# THE VULNERABILITY — allUsers object ACL override
# resource "google_storage_object_acl" "accidental_public_override" {
#   bucket = google_storage_bucket.corporate_vault.name
#   object = google_storage_bucket_object.financial_report.name

#   role_entity = [
#     "READER:allUsers" # Exposes this file to the entire internet
#   ]
# }