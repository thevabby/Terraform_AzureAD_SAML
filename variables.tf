
variable "application_name" {
  type = string
}

variable "aad_group" {
  type = string
}

variable "identifier_uris" {
  type = list(any)
}

variable "redirect_uris" {
  type = list(any)
}