# Устанавливаем базовый образ Jupyter
FROM jupyterhub/jupyterhub:latest
# Указываем переменную окружения с именем администратора
ARG ADMIN_USER=admin
# Указываем переменную окружения с паролем администратора
ENV ADMIN_USER=${ADMIN_USER}
# Скопируем конфиг
COPY jupyterhub_config.py /data/jupyterhub/jupyterhub_config.py
# Указываем рабочую директорию
WORKDIR /data/jupyterhub
# Запускаем JupyterHub
CMD ["jupyterhub"]