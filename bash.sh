#!/bin/bash

# Script para limpar regras UFW e permitir Minecraft (porta 25565) apenas do IP atual
# NÃO altera as políticas default do UFW

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Configurando UFW para Minecraft (porta 25565) ===${NC}"
echo

# Verifica UFW
if ! command -v ufw &> /dev/null; then
    echo -e "${RED}❌ UFW não está instalado. Instale com: sudo pacman -S ufw${NC}"
    exit 1
fi

# Pega IP público
echo -e "${YELLOW}Obtendo seu IP público atual...${NC}"
PUBLIC_IP=$(curl -s --connect-timeout 10 https://api.ipify.org)

if [ -z "$PUBLIC_IP" ]; then
    echo -e "${RED}❌ Falha ao obter IP público. Verifique sua conexão.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Seu IP atual: ${BLUE}$PUBLIC_IP${NC}"
echo

echo -e "${YELLOW}⚠️  Isso vai:${NC}"
echo "   • Apagar TODAS as regras atuais do UFW"
echo "   • Permitir apenas $PUBLIC_IP na porta 25565 (TCP + UDP)"
echo "   • NÃO alterar as políticas default (mantém o que já estava configurado)"
echo

read -p "Digite 'SIM' para confirmar: " CONFIRM
if [[ "$CONFIRM" != "SIM" ]]; then
    echo -e "${RED}❌ Cancelado.${NC}"
    exit 0
fi

echo
echo -e "${YELLOW}Aplicando configurações...${NC}"

# Desabilita temporariamente para poder resetar
sudo ufw --force disable

# Limpa todas as regras existentes (reset)
sudo ufw --force reset

# NÃO define políticas default → mantém exatamente como estava antes do reset

# Adiciona apenas as regras do Minecraft para o IP atual
sudo ufw allow from "$PUBLIC_IP" to any port 25565 proto tcp comment "Minecraft TCP"
sudo ufw allow from "$PUBLIC_IP" to any port 25565 proto udp comment "Minecraft UDP"

# Opcional: permitir SSH do mesmo IP (descomente se precisar)
# sudo ufw allow from "$PUBLIC_IP" to any port 22 proto tcp comment "SSH temporário"

# Reativa o UFW com as novas regras
sudo ufw --force enable

echo
echo -e "${GREEN}✅ Pronto! Regras atualizadas sem alterar políticas default.${NC}"
echo
sudo ufw status numbered
echo
echo -e "${YELLOW}💡 Quando seu IP mudar, execute o script novamente.${NC}"
echo -e "${BLUE}🔍 Políticas atuais mantidas:${NC}"
sudo ufw status verbose | grep "Default:"