#Базовый образ Jupyter
FROM jupyter/base-notebook:latest
#Переключаемся на пользователя root
USER root
#Устанавливаем Bash
RUN apt-get update && apt-get install -y bash
# Устанавливаем Pandas
RUN pip install --no-cache-dir pandas
#Копируем директорию с Jupyter notebooks в контейнер
COPY all_notebooks /home/jovyan/all_notebooks
#Настраиваем рабочую директорию
WORKDIR /home/jovyan/all_notebooks
#Открываем порт 8888 для доступа к Jupyter Notebook
EXPOSE 8888
#Запускаем Jupyter Notebook
CMD [ "/bin/bash","start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.notebook_dir=/home/jovyan/all_notebooks" ]