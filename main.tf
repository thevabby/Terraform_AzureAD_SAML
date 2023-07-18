terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.39.0"
    }
  }
}

data "azuread_client_config" "current" {}


resource "azuread_application" "application" {
  display_name            = var.application_name
  identifier_uris         = var.identifier_uris
  sign_in_audience        = "AzureADMyOrg"
  prevent_duplicate_names = false

  web {
    redirect_uris = var.redirect_uris
  }

  feature_tags {
    enterprise            = true
    gallery               = false
    custom_single_sign_on = true
  }
}

resource "azuread_service_principal" "application" {
  application_id                = azuread_application.application.application_id
  app_role_assignment_required  = true
  use_existing                  = true
  preferred_single_sign_on_mode = "saml"

  feature_tags {
    enterprise            = true
    gallery               = false
    custom_single_sign_on = true
  }
}

resource "azuread_service_principal_token_signing_certificate" "example" {
  service_principal_id = azuread_service_principal.application.id
  end_date             = "2025-07-01T01:02:03Z"
}

resource "azuread_group" "example" {
  display_name     = var.aad_group
  security_enabled = true
}

resource "azuread_app_role_assignment" "example" {
  app_role_id         = "00000000-0000-0000-0000-000000000000"
  principal_object_id = azuread_group.example.object_id
  resource_object_id  = azuread_service_principal.application.object_id
}

data "http" "idp_metadata" {
  url = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/federationmetadata/2007-06/federationmetadata.xml?appid=${azuread_application.application.application_id}"
  request_headers = {
    Accept = "application/xml"
  }
  depends_on = [
    azuread_service_principal.application,
    azuread_application.application
  ]
}
