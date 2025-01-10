# Финальная работа: Виртуализация

## 1. Клонируем репозитарий проекта taski
```git clone git@github.com:yandex-praktikum/taski.git```

## 2. Создаем Dockerfile c использованием multi-stage:

### Этап 1: Сборка frontend
- ```FROM node:16 AS frontend-builder```
 
Устанавливаю рабочую директорию
- ```WORKDIR /app```

Копирую package.json и package-lock.json
- ```COPY frontend/package.json .```
- ```COPY frontend/package-lock.json .```

Устанавливаем зависимости
- ```RUN npm install```

Копируем файлы frontend
- ```COPY frontend/ .```

Собираем frontend
- ```RUN npm run build```

### Этап 2: Сборка backend и копирование frontend'а

Выбираем образ ```node:16```
- ```FROM node:16 AS backend-builder```

Устанавливаю рабочую директорию    
- ```WORKDIR /app```

Копируем requirements.txt в директорию приложения
- ```COPY backend/requirements.txt .```

Устанавливаю зависимости
- ```RUN pip install -r requirements.txt```

Устанавка сетевых утилит
- ```RUN apt-get update && apt-get install -y postgresql-client```

Копирую директорию backend в контейнер
- ```COPY backend/ /app/```

Копирую необходимые файлы из предыдущего этапа
- ```COPY --from=frontend-builder /app/build /app/frontend/build```

Открываем порт, на котором работает приложение
- ```EXPOSE 8000```

Запускаю сервер
- ```CMD ["bash", "-c", "python /app/wait_for_db.py && python manage.py runserver 0.0.0.0:8000"]```

| Название         | Описание                                                              |
|------------------|-----------------------------------------------------------------------|
| bash	           | Указывает, что команда будет выполняться через оболочку Bash          |
| -c               | Флаг Bash, который говорит ему выполнить строку, указанную в кавычках.|
| wait_for_db.py   | Запускает Python-скрипт wait_for_db.py                                |
| manage.py        | Запускает Pyhton-скрипт manage.py, который является утилитой Django.  |
| runserver        | Запуск сервера.                                                       |
| 0.0.0.0          | Указывает, что сервер будет слушать на всех сетевых интерфейсах контейнера.                                                                                |
| 8000             | Порт, на котором работает приложение.                                 |


## 3. Разворачиваем с помощью docker-compose:

| Название         | Описание                                                                     |
|------------------|--------------------------------------------------------------------------    |
| services         | Секция, где описываются все сервисы, запускаемые с помощью Docker Compose.   |
| backend          | Имя сервиса, отвечающего за работу приложения (бэкенд).                      |
| build            | Указывает параметры сборки образа контейнера.                                |
| context          | Контекст сборки — директория, из которой собирается образ.                   |
| dockerfile       | Указывает конкретный Dockerfile, используемый для сборки.                    |
| image            | Название образа, который будет создан и запущен.                             |
| container_name   | Имя контейнера, используемое для идентификации сервиса.                      |
| ports            | Маппинг портов между хостом и контейнером.                                   |
| depends_on       | Указывает зависимости сервиса (какие сервисы должны стартовать раньше).      |
| environment      | Переменные окружения, передаваемые внутрь контейнера.                        |
| DB_HOST          | Переменная окружения, указывающая на хост базы данных.                       |
| database         | Имя сервиса базы данных (PostgreSQL).                                        |
| volumes          | Том, используемый для хранения данных вне контейнера.                        |
| POSTGRES_USER    | Переменная окружения, задающая имя пользователя базы данных.                 |
| POSTGRES_PASSWORD| Переменная окружения, задающая пароль для базы данных.                       |
| POSTGRES_DB      | Переменная окружения, задающая имя создаваемой базы данных.                  |
| db_data          | Логическое имя тома для хранения данных PostgreSQL.                          |
| /var/lib/postgresql/data | Путь в контейнере, где PostgreSQL сохраняет данные.                  |


## 4. Изменяем параметры базы на PostgreSQL в settings.py, часть переменных уже прописаны в docker-compose:
```DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'taskidb', # имя базы данных
        'USER': 'admin', # имя пользователя
        'PASSWORD': 'admin', # пароль
        'HOST': 'database',  # имя сервиса базы данных в docker-compose
        'PORT': '5432', # порт для подключения
    }
}
```

## 5. Разворачиваю проект с помощью Minikube

1. Скачиваю Minikube
2. Прописывают PATH к переменным окружения
3. Инициализирую Minikube - `minikube start`
4. Поднимаю сервис backend - `kubectl apply -f backend-deployment.yaml`
5. Поднимаю сервис базы данных - `kubectl apply -f database-deployment.yaml`

Описание параметров: 
| Параметр | Описание |
|----------|----------|
| apiVersion | Указывает версию API Kubernetes. Для Deployment это apps/v1, для Service — v1. |
| kind | Тип объекта. В данном файле это Deployment (развёртывание) и Service (сервис). |
| metadata.name | Имя объекта. Для Deployment — database-deployment, для Service — database. |
| metadata.labels | Метки для группировки и идентификации объектов. Например, app: database. |
| spec.replicas | Количество экземпляров приложения, которые будут запущены (здесь 1). |
| spec.selector | Указывает, какие поды относятся к этому объекту (по меткам app: database). |
| spec.template.metadata | Метаданные для подов, создаваемых Deployment, включая метки. |
| spec.template.spec | Конфигурация контейнеров, которые будут запускаться в подах. |
| containers.name | Имя контейнера внутри пода (database). |
| containers.image | Образ контейнера. Здесь используется postgres:latest. |
| containers.ports | Список портов, открытых в контейнере. Например, containerPort: 5432. |
| env | Переменные окружения для настройки PostgreSQL. |
| POSTGRES_DB | Имя базы данных (taskidb). |
| POSTGRES_USER | Имя пользователя (admin). |
| POSTGRES_PASSWORD | Пароль пользователя (admin). |
| Service.spec.selector | Указывает, какие поды обслуживает сервис (по метке app: database). |
| Service.spec.ports | Описывает настройки порта. |
| port | Порт, на котором сервис доступен внутри кластера (5432). |
| targetPort | Порт внутри пода, к которому направляется трафик (5432). |

## 6. Автоматизирую развертку docker-compose и minikube через GitHub Actions

| Параметр | Описание | Команды |
|----------|----------|---------|
| name     | Имя GitHub Actions Workflow. В данном случае — Docker Compose CI/CD pipeline. | Отсутствует |
| on.push.branches | Триггер запуска workflow при пуше в ветку finalProject. | Отсутствует |
| jobs     | Определяет задания (jobs), которые будут выполняться. | Отсутствует |
| runs-on  | Указывает, на какой машине выполняется задание. Здесь используется ubuntu-latest. | Отсутствует |
| Pull repository | Скачивает код репозитория. Используется действие actions/checkout@v2. | uses: actions/checkout@v2 |
| Set up Docker Buildx | Настраивает плагин Docker Buildx для сборки образов. | uses: docker/setup-buildx-action@v2 |
| Set up Docker Compose | Устанавливает docker-compose на сервер. Выполняет команду через apt-get. | run: sudo apt-get install -y docker-compose |
| Login in Docker Hub | Выполняет вход в Docker Hub с использованием секретов (DOCKER_USERNAME и DOCKER_PASSWORD). | uses: docker/login-action@v2 with: username: secrets.DOCKER_USERNAME, password: secrets.DOCKER_PASSWORD |
| Build and run services | Собирает и запускает сервисы с помощью команды docker-compose up -d --build. | run: docker-compose up -d --build |
| Wait for service to start | Ждёт 45 секунд, чтобы запущенные сервисы стали полностью доступны. | run: sleep 45 |
| Backend tests | Выполняет проверку состояния сервисов через логи контейнеров backend и database. | run: docker logs backend && sleep 10 && docker logs database |
| Docker compose down | Останавливает и удаляет запущенные контейнеры, даже если предыдущие шаги завершились с ошибкой. | run: docker-compose down if: always() |
| Push Docker image | Загружает собранный образ бэкенда в Docker Hub. | run: docker push ${{ secrets.DOCKER_USERNAME }}/backend:latest |
| Install kubectl | Устанавливает утилиту kubectl для управления Kubernetes-кластером. | uses: azure/setup-kubectl@v3 |
| with: version: latest |  |  |
| Start Minikube | Запускает локальный Kubernetes-кластер с помощью Minikube. | uses: medyagh/setup-minikube@latest |
| Wait initial Minikube setup | Ждёт 10 секунд, чтобы Minikube полностью запустился. | run: sleep 10 |
| Generate Minikube config | Отображает текущую конфигурацию Minikube. | run: minikube config view |
| Deploy to Minikube | Применяет конфигурации Kubernetes для деплоя приложений. Выполняет kubectl apply для файлов backend-deployment.yaml и database-deployment.yaml. | run: kubectl apply -f backend-deployment.yaml && kubectl apply -f database-deployment.yaml |
| Minikube logs | Отображает состояние всех ресурсов в Minikube с помощью команды kubectl get all. | run: kubectl get all |
| Minikube down | Останавливает и удаляет Minikube-кластер после завершения всех шагов. | run: minikube stop && minikube delete if: always() |
