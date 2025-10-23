#!/bin/bash
# ===============================================
#  FULL SYSTEM MAINTENANCE - PARROT OS (NO SNAP)
# ===============================================

echo "Actualizando sistema con parrot-upgrade..."
sudo parrot-upgrade -y

echo "Actualizando Flatpaks (si existen)..."
if command -v flatpak &>/dev/null; then
  flatpak update -y
fi

echo "Reparando paquetes rotos y configuraciones pendientes..."
sudo apt install -f -y
sudo dpkg --configure -a

echo "Limpiando paquetes innecesarios..."
sudo apt autoremove --purge -y
sudo apt autoclean -y
sudo apt clean -y

echo "Limpiando caché del sistema..."
sudo rm -rf /var/cache/*
sudo rm -rf /var/tmp/*

echo " Limpiando caché de usuario..."
rm -rf ~/.cache/thumbnails/* 2>/dev/null
rm -rf ~/.cache/* 2>/dev/null

echo "Eliminando librerías huérfanas..."
sudo apt install deborphan -y
sudo apt remove --purge $(deborphan) -y 2>/dev/null || true

echo "Limpiando caché DNS..."
sudo systemd-resolve --flush-caches
sudo systemctl restart systemd-resolved

echo "Verificando estado de paquetes..."
sudo apt update -y && sudo apt --fix-broken install -y

echo "Limpiando logs del sistema..."
sudo journalctl --vacuum-time=7d
sudo rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/journal/*

echo " Mantenimiento completo finalizado."
echo "Recomendación: reinicia el sistema para aplicar todo."
