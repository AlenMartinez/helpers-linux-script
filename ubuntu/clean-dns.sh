#!/bin/bash
# =======================================================
# Script: clear-dns.sh
# Descripción: Limpia la caché DNS del sistema y reinicia
#              NetworkManager en Ubuntu.
# Requiere: permisos de sudo.
# =======================================================

# Colores para mensajes

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${YELLOW} Verificando permisos de administrador...${RESET}"
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}  Por favor, ejecuta este script con sudo:${RESET}"
  echo "sudo $0"
  exit 1
fi

echo -e "${YELLOW} Limpiando caché DNS...${RESET}"
if resolvectl flush-caches 2>/dev/null; then
  echo -e "${GREEN} Caché DNS limpiada correctamente.${RESET}"
else
  echo -e "${RED} Error al limpiar la caché DNS. Puede que resolvectl no esté disponible.${RESET}"
fi

echo -e "${YELLOW} Reiniciando NetworkManager...${RESET}"
if systemctl restart NetworkManager 2>/dev/null; then
  echo -e "${GREEN} NetworkManager reiniciado con éxito.${RESET}"
else
  echo -e "${RED} No se pudo reiniciar NetworkManager.${RESET}"
fi

echo -e "${YELLOW} Mostrando estadísticas DNS...${RESET}"
if resolvectl statistics 2>/dev/null; then
  echo -e "${GREEN} Estadísticas mostradas arriba.${RESET}"
else
  echo -e "${YELLOW} Usando resolvectl status en su lugar...${RESET}"
  resolvectl status 2>/dev/null || echo -e "${RED} No se pudo obtener el estado DNS.${RESET}"
fi

echo -e "${GREEN} Limpieza de DNS y reinicio de red completados.${RESET}"
