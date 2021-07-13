# Variables.tf
variable "project_id" {
    type = string
    default = "<project_id_of_gcp_console>"
}
variable "region" {
    type = string
    default = "<region_need_to_deploy>"
}
variable "private_key_path" {
    type = string
    default = "<path_for_private_key>"
}
variable "public_key_path" {
    type = string
    default = "<path_for_publickey>" 
}
variable "user" {
    type = string
    default = "<ssh_username>"
}