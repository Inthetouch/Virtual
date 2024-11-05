#Базовый образ Jupyter
FROM jupyter/minimal-notebook:latest
#Создаем папку для ноутбуков
RUN mkdir /home/jovyan/all_notebooks
#Устанавливаем необходимые права на папку
RUN chown -R jovyan:users /home/jovyan/all_notebooks
#Устанавливаем переменные среды
ENV JUPYTER_ENABLE_LAB=yes
ENV NB_USER=jovyan
ENV NB_UID=1000
ENV NB_GID=100
#Запускаем Jupyter Notebook с параметрами командной строки
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8889", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.notebook_dir=/home/jovyan/all_notebooks"]
