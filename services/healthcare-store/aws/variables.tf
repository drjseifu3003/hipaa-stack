variable "name_prefix" {
  type        = string
  description = "Prefix applied to names of all resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. production, staging, development)."
}

variable "datastore_name" {
  type        = string
  description = "The name of the FHIR datastore."
  default     = "fhir-datastore"
}

variable "fine_grained_authorization" {
  type        = bool
  description = "Whether to enable fine-grained authorization (SMART on FHIR v1)."
  default     = false
}
