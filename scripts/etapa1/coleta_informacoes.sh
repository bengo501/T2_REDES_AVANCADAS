#!/bin/bash

# script de coleta de informações - etapa 1
# uso: ./coleta_informacoes.sh <alvo>

if [ -z "$1" ]; then
    echo "uso: $0 <alvo>"
    echo "exemplo: $0 exemplo.com"
    exit 1
fi

ALVO=$1
DIR_RESULTADOS="resultados/${ALVO//[^a-zA-Z0-9]/_}"
mkdir -p "$DIR_RESULTADOS"

echo "=== coletando informações para $ALVO ==="
echo "resultados serão salvos em: $DIR_RESULTADOS"
echo ""

# whois
echo "[*] executando whois..."
whois "$ALVO" > "$DIR_RESULTADOS/whois.txt" 2>&1
echo "    salvo em: $DIR_RESULTADOS/whois.txt"

# dns lookup - registro a
echo "[*] executando dns lookup (registro a)..."
dig "$ALVO" +short > "$DIR_RESULTADOS/dns_a.txt" 2>&1
dig "$ALVO" >> "$DIR_RESULTADOS/dns_a.txt" 2>&1
echo "    salvo em: $DIR_RESULTADOS/dns_a.txt"

# dns lookup - mx
echo "[*] executando dns lookup (registro mx)..."
dig "$ALVO" mx +short > "$DIR_RESULTADOS/dns_mx.txt" 2>&1
dig "$ALVO" mx >> "$DIR_RESULTADOS/dns_mx.txt" 2>&1
echo "    salvo em: $DIR_RESULTADOS/dns_mx.txt"

# dns lookup - ns
echo "[*] executando dns lookup (registro ns)..."
dig "$ALVO" ns +short > "$DIR_RESULTADOS/dns_ns.txt" 2>&1
dig "$ALVO" ns >> "$DIR_RESULTADOS/dns_ns.txt" 2>&1
echo "    salvo em: $DIR_RESULTADOS/dns_ns.txt"

# dns lookup - txt
echo "[*] executando dns lookup (registro txt)..."
dig "$ALVO" txt +short > "$DIR_RESULTADOS/dns_txt.txt" 2>&1
dig "$ALVO" txt >> "$DIR_RESULTADOS/dns_txt.txt" 2>&1
echo "    salvo em: $DIR_RESULTADOS/dns_txt.txt"

# nslookup
echo "[*] executando nslookup..."
nslookup "$ALVO" > "$DIR_RESULTADOS/nslookup.txt" 2>&1
echo "    salvo em: $DIR_RESULTADOS/nslookup.txt"

echo ""
echo "=== coleta de informações concluída ==="
echo "verifique os resultados em: $DIR_RESULTADOS/"

