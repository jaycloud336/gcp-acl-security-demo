output "secured_doc_public_url" {
  value       = "https://storage.googleapis.com/${google_storage_bucket.corporate_vault.name}/${google_storage_bucket_object.secured_doc.name}"
  description = "Public URL for secured doc — expected 403"
}

output "secured_doc_authenticated_url" {
  value       = "https://storage.cloud.google.com/${google_storage_bucket.corporate_vault.name}/${google_storage_bucket_object.secured_doc.name}"
  description = "Authenticated URL for secured doc — accessible to named user only"
}

output "financial_doc_public_url" {
  value       = "https://storage.googleapis.com/${google_storage_bucket.corporate_vault.name}/${google_storage_bucket_object.financial_report.name}"
  description = "Public URL for financial doc — exposed via allUsers ACL"
}

output "financial_doc_authenticated_url" {
  value       = "https://storage.cloud.google.com/${google_storage_bucket.corporate_vault.name}/${google_storage_bucket_object.financial_report.name}"
  description = "Authenticated URL for financial doc"
}