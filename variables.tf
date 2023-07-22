###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###ssh vars
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvFga7bnTy7JYFUfXzhvYt/hWgu2BOL4A0MTn0ayXl4+9dhCvqrJT5ZteRU8QyPSKde90vDb2gIejdH9DL5i7WawOKSaTa3wHoef51eTVo3tjNVXIscHKnZOeZ+ttnBaT98Yjhu56ctDyPGVSLjnke6IURwuNQzsjAtiWvnPdzVIbONE8um2rgFc0U4CQYLjrEFRQL7rkdnK27Sj2ynPexxHJTyA6SYtGvJ/vBwEfRXUzZo7vsWiLnZvbyIhdEtd0XVITdSf+8N9kj1rmFeBybpEJtnNemjGf/B9ZU59kgCc723rkxnyPxcWM9P+qEfz4DyAU2eMopXuhGk9lshGzKTcKaOyaUMzr1V4JBzT0UKJoNHr0p7gN+PXms+vni30nppBougaC3ZgdwNMILGITVB5llB8XacLt0xTRc07FLGML196YlOBJap+SSjEAWRcYZtmxHLXWWHgVjDZS5cjFLlMI6eRsd4ih5SrPsHNcVyfv67JxUzvPOJ9b6t71Lkjc= devops@WORKBOOK"
  description = "ssh-keygen -t ed25519"
}

### VM instances configuration
variable "vm_instances" {
  type = map(object({
    cpu  = number
    ram  = number
    disk = number
  }))
  description = "Map of VM instances with CPU cores, RAM (in GB), and disk size (in GB)"
  default = {
    "main"    = { cpu = 4, ram = 8, disk = 10 }
    "replica" = { cpu = 2, ram = 4, disk = 10 }
  }
}
variable "vmweb_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "The family of the Yandex Compute image for the VMs"
}
variable "vmweb_core" {
  type        = number
  default     = 2
  description = "Number of CPU cores for VM"
}

variable "vmweb_memo" {
  type        = number
  default     = 2
  description = "Amount of memory (RAM) for VM in GB"
}

variable "vmweb_fr" {
  type        = number
  default     = 5
  description = "Core fraction for VM"
}
variable "databases" {
  type        = list(string)
  description = "List of database instances"
}
