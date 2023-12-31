# Задание 1
- Изучите проект.
- Заполните файл personal.auto.tfvars
- Инициализируйте проект, выполните код (он выполнится даже если доступа к preview нет).
- Примечание: Если у вас не активирован preview доступ к функционалу "Группы безопасности" в Yandex Cloud - запросите доступ у поддержки облачного провайдера. Обычно его выдают в течении 24-х часов.
-Приложите скриншот входящих правил "Группы безопасности" в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview версии.
### Ответ: Все изучила, доступ запросила, сеть создала

![yc](https://github.com/EVolgina/devops27-tf3/blob/main/YC.PNG)

# Задание 2
- Создайте файл count-vm.tf. Опишите в нем создание двух одинаковых ВМ web-1 и web-2(не web-0 и web-1!), с минимальными параметрами, используя мета-аргумент count loop. - Назначьте ВМ созданную в 1-м задании группу безопасности.
- Создайте файл for_each-vm.tf. Опишите в нем создание 2 ВМ с именами "main" и "replica" разных по cpu/ram/disk , используя мета-аргумент for_each loop. Используйте для обеих ВМ одну, общую переменную типа list(object({ vm_name=string, cpu=number, ram=number, disk=number })). При желании внесите в переменную все возможные параметры.
ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.
- Используйте функцию file в local переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ №2.
- Инициализируйте проект, выполните код.
### Ответ: 
```
# count-vm.tf
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
```
```
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
```
![vm](https://github.com/EVolgina/devops27-tf3/blob/main/4%20vm.PNG)
# Задание 3
- Создайте 3 одинаковых виртуальных диска, размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле disk_vm.tf .
- Создайте в том же файле одну ВМ c именем "storage" . Используйте блок dynamic secondary_disk{..} и мета-аргумент for_each для подключения созданных вами дополнительных дисков.
### Ответ:
```
resource "yandex_compute_disk" "data_disk" {
  count = 3
  name  = "data-disk-${count.index + 1}"
  size  = 1
  type  = "network-hdd"
  zone  = var.default_zone
}
```
![yvm](https://github.com/EVolgina/devops27-tf3/blob/main/5vm.PNG)
![ydisk](https://github.com/EVolgina/devops27-tf3/blob/main/ydisk.PNG)

# Задание 4
- В файле ansible.tf создайте inventory-файл для ansible. Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции. Готовый код возьмите из демонстрации к лекции demonstration2. Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2.(т.е. 5 ВМ)
Инвентарь должен содержать 3 группы [webservers], [databases], [storage] и быть динамическим, т.е. обработать как группу из 2-х ВМ так и 999 ВМ.
- Выполните код. Приложите скриншот получившегося файла.
- Для общего зачета создайте в вашем GitHub репозитории новую ветку terraform-03. Закомитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.
- Удалите все созданные ресурсы.
  ### Ответ:
  ![asible](https://github.com/EVolgina/devops27-tf3/blob/main/ansible.PNG)
