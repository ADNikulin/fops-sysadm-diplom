# Курсовая работа на профессии "DevOps-инженер с нуля"
# Никулин Александр Дмитриевич

<details>
    <summary>Задача</summary>

    Условия доступны по [ссылке]{https://github.com/netology-code/fops-sysadm-diplom/blob/main/README.md}
</details>

Предпологается что у человека настроен YC CLI и есть соотвествующие учетные данные. 

У юзера должен быть создан сервисный аккаунт в нужном folder
Так же у юзера должен быть создан сервисный авторизационный ключ (https://yandex.cloud/ru/docs/iam/operations/authorized-key/create#console_1)

Скачиваем файл и подпихиваем этот файл в YC
```bash
yc config set service-account-key key.json
yc config set cloud-id <идентификатор_облака>
yc config set folder-id <идентификатор_каталога>
```

Для авторизации используем: 
```bash
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

По структуре.\
Предполагалось для терраформ части использовать следующий подход: 

```
.
└── proj/
    ├── live/
    │   ├── stage-develop/
    │   └── stage-prod/
    │       ├── main.tf
    │       ├── outputs.tf
    │       ├── variables.tf
    │       ├── ....
    │       └── terraforms.tfvars
    └── modules/
        ├── networks/
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── ....
        └── servers/
            ├── main.tf
            ├── outputs.tf
            └── variables.tf
```
Что-то в этом духе: где live директория это описание инфры, modules, это уже готовые и собранные системы.\
Но не успел сделать задуманное, думаю позже лично для себя сделаю.\

По итогу в live секции лежат все основные файлы по настройке инфры, разбиты тематически

Далее в в подчасти ansible_configs находятся роли по настройке тематических сервисов. 

Когда создается инфра, формируются файлы из терраформа и дописываются в переменные и инфру. 
В частности: 
* [invemtory](https://github.com/ADNikulin/fops-sysadm-diplom/blob/master/ansible_configs/inventory.yaml)
* [terraform_vars](https://github.com/ADNikulin/fops-sysadm-diplom/blob/master/ansible_configs/vars/terraform_vars.yml)

Данные берутся из [outputs.tf](https://github.com/ADNikulin/fops-sysadm-diplom/blob/master/terraform_configs/live/stage-prod/outputs.tf)

Далее плейбук подставляет уже эти файлы и инфру и поднимает оставшиеся сервисы. 
В общем то и всё. 

На текущий момент: 
* вебсервисы - [http://158.160.161.138/](http://158.160.161.138/) (Можно увидеть на главной, как берется имя хоста в зависимости от машины (3 штуки))
* кибана - [http://158.160.78.180:5601](http://158.160.78.180:5601/app/discover#/?_g=(filters:!(),refreshInterval:(pause:!t,value:60000),time:(from:now-15m,to:now))&_a=(columns:!(),filters:!(),index:'filebeat-*',interval:auto,query:(language:kuery,query:''),sort:!(!('@timestamp',desc)))).
* графана [http://158.160.82.213:3000](http://158.160.82.213:3000/d/rYdddlPWk/node-exporter-full?orgId=1&refresh=1m)
