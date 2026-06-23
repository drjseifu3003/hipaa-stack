output "datastore_id" {
  value       = aws_healthlake_fhir_datastore.store.id
  description = "The ID of the HealthLake FHIR Datastore."
}

output "datastore_arn" {
  value       = aws_healthlake_fhir_datastore.store.arn
  description = "The ARN of the HealthLake FHIR Datastore."
}

output "datastore_endpoint" {
  value       = aws_healthlake_fhir_datastore.store.datastore_endpoint
  description = "The endpoint URL of the HealthLake FHIR Datastore."
}
