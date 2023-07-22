resource "yandex_compute_instance" "web" {
  count = 2

  name = "web-${count.index + 1}"

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
}

