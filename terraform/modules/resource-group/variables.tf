variable "name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default = "UAE North"
}

variable "tags" {
 description = "tags"
 default     = null
}