variable "network" {
  description = "The VPC name for deployment"
  type = string
  default = "challenge-network"
}
variable "sub-network" {
  description = "The VPC subnet for deployment"
  type = string
  default = "challenge-subnetwork"
}
variable "vm-name" {
  description = "The vm-name"
  type = string
  default = "challenge-vm"
}