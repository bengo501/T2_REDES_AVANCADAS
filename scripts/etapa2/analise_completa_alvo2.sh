#!/bin/bash

# script completo para análise do alvo 2
# uso: ./analise_completa_alvo2.sh <ip_do_alvo>

if [ -z "$1" ]; then
    echo "uso: $0 <ip_do_alvo>"
    echo "exemplo: $0 192.168.1.1"
    exit 1
fi

ALVO=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "========================================="
echo "análise completa - alvo 2"
echo "alvo: $ALVO"
echo "========================================="
echo ""

# criar diretórios
mkdir -p resultados/alvo2/etapa1
mkdir -p resultados/alvo2/etapa2

# etapa 1: obtenção de informações
echo "=== etapa 1: obtenção de informações ==="
cd resultados/alvo2/etapa1

echo "[*] ping para confirmar conectividade..."
ping -c 4 $ALVO > ping_$TIMESTAMP.txt 2>&1
echo "    salvo em: ping_$TIMESTAMP.txt"

echo "[*] dns reverso..."
dig -x $ALVO > dns_reverso_$TIMESTAMP.txt 2>&1
echo "    salvo em: dns_reverso_$TIMESTAMP.txt"

echo "[*] nslookup..."
nslookup $ALVO > nslookup_$TIMESTAMP.txt 2>&1
echo "    salvo em: nslookup_$TIMESTAMP.txt"

echo "etapa 1 concluída!"
echo ""

# etapa 2: mapeamento e vulnerabilidades
echo "=== etapa 2: mapeamento e vulnerabilidades ==="
cd ../etapa2

echo "[*] varredura rápida..."
nmap -F $ALVO -oN scan_rapido_$TIMESTAMP.txt -oX scan_rapido_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_rapido_$TIMESTAMP.txt"

echo "[*] varredura completa (pode demorar)..."
nmap -sV -sC $ALVO -oN scan_completo_$TIMESTAMP.txt -oX scan_completo_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_completo_$TIMESTAMP.txt"

echo "[*] detecção de sistema operacional (requer root)..."
sudo nmap -O $ALVO -oN scan_os_$TIMESTAMP.txt -oX scan_os_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_os_$TIMESTAMP.txt"

echo "[*] varredura udp (requer root)..."
sudo nmap -sU --top-ports 100 $ALVO -oN scan_udp_$TIMESTAMP.txt 2>&1
echo "    salvo em: scan_udp_$TIMESTAMP.txt"

echo "[*] varredura de vulnerabilidades..."
nmap --script vuln $ALVO -oN scan_vuln_$TIMESTAMP.txt -oX scan_vuln_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_vuln_$TIMESTAMP.txt"

# testar serviços web (roteadores geralmente têm)
echo "[*] testando serviços web..."
echo "    executando nikto..."
nikto -h http://$ALVO -output nikto_$TIMESTAMP.txt 2>&1
echo "        salvo em: nikto_$TIMESTAMP.txt"

echo "    coletando headers http..."
curl -I http://$ALVO > headers_$TIMESTAMP.txt 2>&1
curl -v http://$ALVO >> headers_$TIMESTAMP.txt 2>&1
echo "        salvo em: headers_$TIMESTAMP.txt"

echo "    testando https..."
curl -I -k https://$ALVO > headers_https_$TIMESTAMP.txt 2>&1
curl -v -k https://$ALVO >> headers_https_$TIMESTAMP.txt 2>&1
echo "        salvo em: headers_https_$TIMESTAMP.txt"

echo ""
echo "=== análise do alvo 2 concluída! ==="
echo ""
echo "resultados salvos em:"
echo "  - etapa 1: resultados/alvo2/etapa1/"
echo "  - etapa 2: resultados/alvo2/etapa2/"
echo ""
echo "próximos passos:"
echo "1. analisar resultados:"
echo "   grep 'open' resultados/alvo2/etapa2/scan_completo_$TIMESTAMP.txt"
echo "2. pesquisar vulnerabilidades em bases de dados cve"
echo "3. preencher relatorio.md com os resultados"
echo ""

