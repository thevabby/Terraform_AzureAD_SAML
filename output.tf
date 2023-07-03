output "azuread_application_id" {
  value = azuread_application.application.application_id
}
output "azuread_service_principal_id" {
  value = azuread_service_principal.application.id
}

output "azuread_application_display_name" {
  value = azuread_application.application.display_name
}

output "metadata" {
  value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/federationmetadata/2007-06/federationmetadata.xml?appid=${azuread_application.application.application_id}"
}