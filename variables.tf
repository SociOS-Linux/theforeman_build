# Variables.tf
variable "project_id" {
    type = string
    default = "project_id of your GCP project"
}
variable "region" {
    type = string
    default = "name of your project region"
}
variable "zone" {
    type = string
    default = "name of your project zone"
}
variable "network_name" {
    type = string
    default = "name for GCP network"
}
variable "firewall_name" {
    type = string
    default = "name for your GCP firewall"
}
variable "instance_name" {
    type = string
    default = "name for your GCP instance"
}
variable "machine_type" {
    type = string
    default = "type of your machine"
}
variable "image_type" {
    type = string
    default = "type of your image"
}
variable "disk_size" {
    type = string
    default = "disk space for instance"
}
variable "disk_type" {
    type = string
    default = "disk type for your instance"
}
variable "private_key_path" {
    type = string
    default = "~/.ssh/mykey"
}
variable "public_key_path" {
    type = string
    default = "~/.ssh/mykey.pub"
}
variable "user" {
    type = string
    default = "username"
}