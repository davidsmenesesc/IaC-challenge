variable "project_id" {
  description = "The project ID to host the network in"
  type = string
  default = "rampup-360523"
}
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