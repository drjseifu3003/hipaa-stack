output "datastore_id" {
  value       = awscc_healthlake_fhir_datastore.store.datastore_id
  description = "The ID of the HealthLake FHIR Datastore."
}

output "datastore_arn" {
  value       = awscc_healthlake_fhir_datastore.store.datastore_arn
  description = "The ARN of the HealthLake FHIR Datastore."
}

output "datastore_endpoint" {
  value       = awscc_healthlake_fhir_datastore.store.datastore_endpoint
  description = "The endpoint URL of the HealthLake FHIR Datastore."
}
