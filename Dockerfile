#Используем официальный образ Python в качестве основы
FROM python:3.9
#Устанавливаем рабочий каталог
WORKDIR /app
#Устанавливаем зависимости
COPY ./backend/requirements.txt .
#Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt
#Копируем все содержимое в рабочую директорию
COPY . .
#Определяем команды, которые будут выполняться при запуске контейнера
CMD ["gunicorn", "backend.wsgi:application", "--bind", "0.0.0.0:8000"]