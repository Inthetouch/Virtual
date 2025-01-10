# Финальная работа: Виртуализация

## 1. Клонируем репозитарий проекта taski
```git clone git@github.com:yandex-praktikum/taski.git```

## 2. Создаем Dockerfile и прописываем следующие инструкции::

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