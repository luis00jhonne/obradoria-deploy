#!/bin/bash
set -e

echo "=== 1/4 - Atualizando sistema ==="
sudo apt-get update && sudo apt-get upgrade -y

echo "=== 2/4 - Instalando Docker ==="
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adicionar usuário ao grupo docker (evita sudo)
sudo usermod -aG docker $USER

echo "=== 3/4 - Configurando swap de 2GB ==="
if [ ! -f /swapfile ]; then
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo "Swap de 2GB criado."
else
    echo "Swap já existe, pulando."
fi

echo "=== 4/4 - Verificando ==="
docker --version
docker compose version
free -h
echo ""
echo "========================================="
echo "  Setup concluído!"
echo "  IMPORTANTE: Faça logout e login novamente"
echo "  para usar docker sem sudo."
echo "========================================="
