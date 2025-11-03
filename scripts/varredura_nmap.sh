#!/bin/bash

# script de varredura nmap - etapa 2
# uso: ./varredura_nmap.sh <alvo>

if [ -z "$1" ]; then
    echo "uso: $0 <alvo>"
    echo "exemplo: $0 192.168.1.1"
    exit 1
fi

ALVO=$1
DIR_RESULTADOS="resultados/${ALVO//[^a-zA-Z0-9]/_}"
mkdir -p "$DIR_RESULTADOS"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "=== executando varreduras nmap para $ALVO ==="
echo "resultados serão salvos em: $DIR_RESULTADOS"
echo ""

# varredura rápida de portas comuns
echo "[*] varredura rápida de portas comuns..."
nmap -F "$ALVO" -oN "$DIR_RESULTADOS/nmap_fast_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/nmap_fast_$TIMESTAMP.xml"
echo "    salvo em: $DIR_RESULTADOS/nmap_fast_$TIMESTAMP.txt"

# varredura completa com detecção de versões
echo "[*] varredura completa com detecção de versões (pode demorar)..."
nmap -sV -sC "$ALVO" -oN "$DIR_RESULTADOS/nmap_version_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/nmap_version_$TIMESTAMP.xml"
echo "    salvo em: $DIR_RESULTADOS/nmap_version_$TIMESTAMP.txt"

# varredura de todas as portas (pode ser muito lenta)
echo "[*] varredura de todas as portas (pode demorar muito)..."
read -p "executar varredura completa de todas as portas? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    nmap -p- "$ALVO" -oN "$DIR_RESULTADOS/nmap_allports_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/nmap_allports_$TIMESTAMP.xml"
    echo "    salvo em: $DIR_RESULTADOS/nmap_allports_$TIMESTAMP.txt"
fi

# detecção de sistema operacional
echo "[*] detecção de sistema operacional..."
nmap -O "$ALVO" -oN "$DIR_RESULTADOS/nmap_os_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/nmap_os_$TIMESTAMP.xml"
echo "    salvo em: $DIR_RESULTADOS/nmap_os_$TIMESTAMP.txt"

# varredura udp (portas mais comuns)
echo "[*] varredura udp de portas comuns..."
nmap -sU --top-ports 20 "$ALVO" -oN "$DIR_RESULTADOS/nmap_udp_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/nmap_udp_$TIMESTAMP.xml"
echo "    salvo em: $DIR_RESULTADOS/nmap_udp_$TIMESTAMP.txt"

echo ""
echo "=== varreduras nmap concluídas ==="
echo "verifique os resultados em: $DIR_RESULTADOS/"

