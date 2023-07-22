locals {
  databases_list = join("\n", var.databases)
  storage_list   = join("\n", var.storage)
}
variable "webservers" {
  type        = list(string)
  description = "List of webservers"
}

variable "storage" {
  type        = list(string)
  description = "List of storage instances"
}

resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/ansible_inventory.tpl", {
    webservers = join("\n", var.webservers)
    databases  = join("\n", var.databases)
    storage    = join("\n", var.storage)
  })
  filename = "${path.module}/ansible_inventory"

  depends_on = [
    yandex_compute_disk.data_disk
  ]
}

data "template_file" "ansible_inventory_tpl" {
  template = file("${path.module}/ansible_inventory.tpl")
  vars = {
    webservers = join("\n", var.webservers)
    databases  = join("\n", var.databases)
    storage    = join("\n", var.storage)
  }
}

