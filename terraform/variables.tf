variable "region" {
  type = string
}
variable "alias" {
  type = string
}
variable "env" {
  type = string
}
variable "tags" {
  type = object({
    project     = string
    context     = string
    environment = string
    platform    = string
  })
}
variable "backend" {
  type = object({
    group       = string
    storage     = string
    container   = string
    key         = string
  })
}
