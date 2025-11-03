#!/bin/bash

# script de varredura web - etapa 2
# uso: ./varredura_web.sh <url>

if [ -z "$1" ]; then
    echo "uso: $0 <url>"
    echo "exemplo: $0 http://exemplo.com"
    exit 1
fi

URL=$1
DIR_RESULTADOS="resultados/${URL//[^a-zA-Z0-9]/_}"
mkdir -p "$DIR_RESULTADOS"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "=== executando varreduras web para $URL ==="
echo "resultados serão salvos em: $DIR_RESULTADOS"
echo ""

# nikto
if command -v nikto &> /dev/null; then
    echo "[*] executando nikto..."
    nikto -h "$URL" -output "$DIR_RESULTADOS/nikto_$TIMESTAMP.txt"
    echo "    salvo em: $DIR_RESULTADOS/nikto_$TIMESTAMP.txt"
else
    echo "[!] nikto não encontrado. pulando..."
fi

# whatweb
if command -v whatweb &> /dev/null; then
    echo "[*] executando whatweb..."
    whatweb "$URL" -v > "$DIR_RESULTADOS/whatweb_$TIMESTAMP.txt" 2>&1
    echo "    salvo em: $DIR_RESULTADOS/whatweb_$TIMESTAMP.txt"
else
    echo "[!] whatweb não encontrado. pulando..."
fi

# curl - análise básica de headers
echo "[*] coletando headers http..."
curl -I "$URL" > "$DIR_RESULTADOS/headers_$TIMESTAMP.txt" 2>&1
curl -v "$URL" >> "$DIR_RESULTADOS/headers_$TIMESTAMP.txt" 2>&1
echo "    salvo em: $DIR_RESULTADOS/headers_$TIMESTAMP.txt"

# dirb/gobuster/dirsearch - se disponível
if command -v dirb &> /dev/null; then
    echo "[*] executando dirb (pode demorar)..."
    read -p "executar dirb? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        dirb "$URL" -o "$DIR_RESULTADOS/dirb_$TIMESTAMP.txt"
        echo "    salvo em: $DIR_RESULTADOS/dirb_$TIMESTAMP.txt"
    fi
elif command -v gobuster &> /dev/null; then
    echo "[*] executando gobuster (pode demorar)..."
    read -p "executar gobuster? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        gobuster dir -u "$URL" -w /usr/share/wordlists/dirb/common.txt -o "$DIR_RESULTADOS/gobuster_$TIMESTAMP.txt"
        echo "    salvo em: $DIR_RESULTADOS/gobuster_$TIMESTAMP.txt"
    fi
fi

echo ""
echo "=== varreduras web concluídas ==="
echo "verifique os resultados em: $DIR_RESULTADOS/"

