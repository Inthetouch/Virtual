# Устанавливаем базовый образ Jupyter
FROM jupyterhub/jupyterhub:latest
# Укажем каталог для хранения постоянных данных
VOLUME "/data/jupyterhub"
# Указываем рабочую директорию
WORKDIR /data/jupyterhub
# Запускаем JupyterHub
CMD ["jupyterhub"]