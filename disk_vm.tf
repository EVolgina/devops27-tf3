resource "yandex_compute_disk" "data_disk" {
  count = 3
  name  = "data-disk-${count.index + 1}"
  size  = 1
  type  = "network-hdd"
  zone  = var.default_zone
}

