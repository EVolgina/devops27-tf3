# for_each-vm.tf
resource "yandex_compute_instance" "custom_vm" {
  for_each = var.vm_instances

  name = "custom-${each.key}"

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }

  depends_on = [yandex_compute_instance.web]
}
resource "yandex_compute_instance" "storage" {
  name = "storage"

  resources {
    cores         = var.vmweb_core
    memory        = var.vmweb_memo
    core_fraction = var.vmweb_fr
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.data_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }

  depends_on = [yandex_compute_disk.data_disk]
}

