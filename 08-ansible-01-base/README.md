# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению

1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

### Ответы

1.

```shell
TASK [Print fact] **************
ok: [localhost] => {
    "msg": 12
}
```

2.

~/mnt-homeworks/08-ansible-01-base/playbook/group_vars/all/examp.yml

```yaml
---
  some_fact: 'all default fact'
```

```shell
TASK [Print fact] *****************
ok: [localhost] => {
    "msg": "all default fact"
}
```

3. Подготовлено docker окружение

```shell


$ docker run --name centos -it -d  centos
ef7050abae6da349844b996e3b01844d9456ec4c8a58ecdf3e501ff34ad014e1

$ docker run --name ubuntu -it -d  ubuntu:python
71db4342e47b3e693063c700bd150f58d442b89e5bdfcb37c3cb94a3d3e82a28

$ docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
71db4342e47b   ubuntu:python   "bash"        6 seconds ago    Up 4 seconds              ubuntu
ef7050abae6d   centos          "/bin/bash"   23 minutes ago   Up 23 minutes             centos

```

4.

```shell
$ ansible-playbook -i inventory/prod.yml site.yml 

TASK [Gathering Facts] ***********************************
ok: [centos]
ok: [ubuntu]

TASK [Print OS] ********************************
ok: [centos] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *************************
ok: [centos] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
```

5.

```shell
$ cat  group_vars/deb/examp.yml
---
  some_fact: 'deb default fact'

$ cat  group_vars/el/examp.yml 
---
  some_fact: 'el default fact'

```

6.

```shell
TASK [Print fact] **************************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```

7.

```shell
$ ansible-vault encrypt group_vars/deb/examp.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful

$ ansible-vault encrypt group_vars/el/examp.yml 
New Vault password: 
Confirm New Vault password: 
Encryption successful
```

8. 

```shell
$ ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml 
/usr/local/Cellar/ansible/5.7.1/libexec/lib/python3.10/site-packages/paramiko/transport.py:236: 

Vault password: 

...

TASK [Print fact] ****************************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP **********************************
centos                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

9. local

10.

```yaml
  local:
    hosts:
      localhost:
        ansible_connection: local
```

11.

```shell
$ ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml 
Vault password: 

PLAY [Print os facts] ***********************

TASK [Gathering Facts] **********************
ok: [ubuntu]
ok: [centos]
ok: [localhost]

TASK [Print OS] **********************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos] => {
    "msg": "CentOS"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ***********************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *******************
centos                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
```shell
$ ansible-vault decrypt group_vars/deb/examp.yml 
Vault password: 
Decryption successful

$ ansible-vault decrypt group_vars/el/examp.yml 
Vault password: 
Decryption successful
```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

```shell
ansible-vault encrypt_string --ask-vault-password PaSSw0rd
New Vault password: 
Confirm New Vault password: 
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          61626638666338613534616633353738643763383232303034636563613766326562646238386265
          6634623637636663653834666430383436666162396239390a643665386561623235323937613563
          30653764373866616536333139646633633262626136303665396261383838376365363832656631
          3664366133663931380a343061393133373431343231313430623535366266343837633164316630
          3731
Encryption successful

```

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

```shell
$ ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml 
Vault password: 

PLAY [Print os facts] *********************************

TASK [Gathering Facts] ************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos]

TASK [Print OS] ********************************************
ok: [centos] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] **************************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ***************
centos                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

```shell
$ cat playbook/inventory/prod.yml
---
...

  fedora:
    hosts:
      fedora:
        ansible_connection: docker

$ cat playbook/group_vars/fedora/examp.yml

---
  some_fact: 'rh default fact'

$ ansible-playbook -i inventory/prod.yml --ask-vault-pass site.yml
...
TASK [Print fact] *********************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}
...
  
```

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

```shell
cat playbook/start_playbook
#!/bin/bash

echo -en "\nRun containers\n"
docker run --name fedora -it -d  fedora
docker run --name ubuntu -it -d  ubuntu:python
docker run --name centos -it -d  centos

echo -en "\nRun playbooks\n"
ansible-playbook -i inventory/prod.yml --vault-password-file ~/.secret site.yml 

echo -en "\nStop containers\n"
docker stop centos
docker stop ubuntu
docker stop fedora

echo -en "\nRemove containers\n"
docker rm centos ubuntu fedora
```

```shell
$ ./start_playbook 

Run containers
ff4764fcd672064574903c4fc8881b252a51b804139806822243de2e2f3e414b
b5bef2ae65c260450b10dfa384fe7a3bc756077cd2521e5a7b22706641156d4c
ad4a4b2a5c81e7b3422fb3c2c047ddcee8295a36ab5af63d47aee0747902b339

Run playbooks

PLAY [Print os facts] ************************************

TASK [Gathering Facts] ***********************************
ok: [localhost]
ok: [fedora]
ok: [ubuntu]
ok: [centos]

TASK [Print OS] *************************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}
ok: [centos] => {
    "msg": "CentOS"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] **********************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "rh default fact"
}

PLAY RECAP ****************
centos                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


Stop containers
centos
ubuntu
fedora

Remove containers
centos
ubuntu
fedora


6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.


---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
