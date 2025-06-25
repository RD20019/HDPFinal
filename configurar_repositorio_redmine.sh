#!/bin/bash

# Variables de configuración
REPO_GITHUB="https://github.com/RD20019/HDPFinals.git"
REPO_LOCAL="/var/repos/hdpfinals"
RAILS_ENV="production"
REDMINE_DIR="/opt/redmine"

echo "==> 1. Creando directorio para repositorios si no existe..."
sudo mkdir -p /var/repos
sudo chown -R $USER:$USER /var/repos

echo "==> 2. Clonando el repositorio desde GitHub..."
if [ -d "$REPO_LOCAL" ]; then
  echo "Ya existe un repositorio en $REPO_LOCAL, eliminando..."
  rm -rf "$REPO_LOCAL"
fi

git clone "$REPO_GITHUB" "$REPO_LOCAL"

echo "==> 3. Estableciendo permisos adecuados..."
sudo chown -R www-data:www-data "$REPO_LOCAL"

echo "==> 4. Configurando cron para sincronizar commits..."
CRON_CMD="cd $REDMINE_DIR && bundle exec rake redmine:fetch_changesets RAILS_ENV=$RAILS_ENV"
(crontab -l | grep -v -F "$CRON_CMD" ; echo "*/15 * * * * $CRON_CMD") | crontab -

echo "==> 5. Ahora ve a Redmine y realiza lo siguiente manualmente:"
echo ""
echo "   🔹 Ve a tu proyecto > Configuración > Módulos, activa 'Repositorio'"
echo "   🔹 Luego ve a la pestaña 'Repositorio'"
echo "   🔹 Tipo: Git"
echo "   🔹 Ruta del repositorio: $REPO_LOCAL"
echo ""
echo "💡 Si todo está bien, Redmine leerá automáticamente los commits del repositorio local"
echo "📁 Local: $REPO_LOCAL"
echo "🌐 GitHub: $REPO_GITHUB"
