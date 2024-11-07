import os

config = get_config()

admin_user = os.getenv("ADMIN_USER", "default_admin")
config.Autenticator.admin_users = {admin_user}