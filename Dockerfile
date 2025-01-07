# Этап 1: Сборка frontend
FROM node:16 AS frontend-builder
#Устанавливаем рабочую директорию
WORKDIR /app
#Копируем package.json и package-lock.json
COPY frontend/package.json .
COPY frontend/package-lock.json .
#Устанавливаем зависимости
RUN npm install
#Копируем файлы frontend
COPY frontend/ .
#Собираем frontend
RUN npm run build

#Этап 2: Сборка backend и копирование frontend'a
FROM python:3.9-slim AS backend-builder
#Устанавливаем рабочую директорию
WORKDIR /app
#Копируем requirements.txt в директорию приложения
COPY backend/requirements.txt .
#Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt
#Устанавка сетевых утилит
RUN apt-get update && apt-get install -y iputils-ping telnet postgresql-client
#Копируем директорию backend в контейнер
COPY backend/ /app/
#Копируем необходимые файлы из предыдущего этапа (frontend)
COPY --from=frontend-builder /app/build /app/frontend/build

# Открываем порт, на котором работает приложение
EXPOSE 8000

# Запускаем сервер
CMD ["bash", "-c", "python /app/wait_for_db.py && python manage.py runserver 0.0.0.0:8000"]