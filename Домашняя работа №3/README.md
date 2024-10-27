# Домашнее задание №3
## Развернуть контейнер с публичным образом в Docker.
1. Для сборки образа необходимо создать Dockerfile - файл содержащий инструкции для сборки.
    - ```touch Dockerfile```
2. В Dockerfile прописать следующие инструкции:
    - Задаем базовый образ на основе которого будет собираться новый образ, в данном случае используется образ Ubuntu с последней версией(latest).
        
        ```FROM ubuntu:latest```
    - Обновляем пакетную базу в системе, чтобы были установлены последние версии пакетов. Устанавливаем ```Bash``` в контейнер, флаг -y отвечает на все запросы установки "да".
        
        ```RUN apt-get update & apt-get install -y bash```
    - Копируем файл test.sh в контейнер, чтобы был доступен внутри образа.
        
        ```COPY test.sh /test.sh```
    - Запускаем скрипт внутри образа.
        
        ```RUN /test.sh"```
    - Указываем команду которая будет выполнена при запуске контейнера. В данном случае ```Bash``` который запускает скрипт ```test.sh```.
        
        ```CMD [ "/bin/bash", "/test.sh" ]```
3. Собрать образ с помощью команды ```docker build```.
    - ```docker build -t myfirstimage .```
    - Флаг -t позволяет присвоить наименование образу.
4. Запустить образ с помощью команды ```docker run```.
    - ```docker run -it myfirstimage```
    - Флаг -it позволяет запустить образ в режиме терминала.
    - Флаг -d позволяет запускать образ в фоновом режиме.

## Развернуть свой сервер на котором будут храниться Jupiter notebooks. 
В директории all_notebooks хранятся файлы ipynb которые должны показыватся по умолчанию всем пользователям.
1. Создаем Dockerfile со следующими инструкциями:
    - Используем официальный образ Jupyter Notebook

    ```FROM jupyter/base-notebook:latest```
    - Переключаемся на пользователя ```root```

    ```USER root```
    - Устанавливаем необходимые зависимости.

    ```RUN apt-get update && apt-get install -y bash```
    
    ```RUN pip install --no-cache-dir pandas```
    - Копируем директорию all_notebooks в контейнер. Jovyan - пользователь Jupyter Notebook. Данный пользователь - это пользователь который создается в образах Jupyter.

    ```COPY all_notebooks /home/jovyan/all_notebooks```
    - Открываем порт 8888 для доступа к Jupyter Notebook.

    ```EXPOSE 8888```
    - Запускаем Jupyter Notebook.

    ```CMD [ "/bin/bash","start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.notebook_dir=/home/jovyan/all_notebooks" ]```
        
        - ```start-notebook.sh``` - скрипт запускающий Jupyter Notebook.
        - ```NotebookApp.token``` - токен для доступа к Jupyter Notebook.
        - ```NotebookApp.notebook_dir``` - директория с Jupyter notebooks.

## Сборка и запуск контейнера.
1. Собираем образ с помощью команды ```docker build -t jupyter-server .```
2. Запускаем образ с помощью команды ```docker run -p 8888:8888 -v "$(pwd)/all_notebooks":/home/jovyan/all_notebooks my-jupyter-notebook```
- ```-p 8888:8888``` - указываем порт для доступа к Jupyter Notebook.
- ```-v "$(pwd)/all_notebooks":/home/jovyan/all_notebooks``` - указываем директорию с notebooks в образе.

