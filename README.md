# fops-sysadm-diplom
без оформления пока:

Предпологается что у человека настроен YC CLI и есть соотвествующие учетные данные. 

У юзера должен быть создан сервисный аккаунт в нужном folder
Так же у юзера должен быть создан сервисный авторизационный ключ (https://yandex.cloud/ru/docs/iam/operations/authorized-key/create#console_1)

Скачиваем файл и подпихиваем этот файл в YC
```bash
yc config set service-account-key key.json
yc config set cloud-id <идентификатор_облака>
yc config set folder-id <идентификатор_каталога>
```bash

Для авторизации используем: 
```bash
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

