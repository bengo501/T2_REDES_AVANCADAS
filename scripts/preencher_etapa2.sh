#!/bin/bash

# script para executar etapa 2 (mapeamento e vulnerabilidades) e gerar resultados
# uso: ./preencher_etapa2.sh <ip_alvo1> <ip_alvo2>

if [ $# -lt 2 ]; then
    echo "uso: $0 <ip_alvo1> <ip_alvo2>"
    echo "exemplo: $0 192.168.1.105 192.168.1.1"
    exit 1
fi

ALVO1=$1
ALVO2=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "========================================="
echo "etapa 2: mapeamento e vulnerabilidades"
echo "========================================="
echo ""

# criar diretórios
mkdir -p resultados/alvo1/etapa2
mkdir -p resultados/alvo2/etapa2

# alvo 1
echo "=== alvo 1: $ALVO1 ==="
cd resultados/alvo1/etapa2

echo "[*] varredura rápida..."
nmap -F $ALVO1 -oN scan_rapido_$TIMESTAMP.txt -oX scan_rapido_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_rapido_$TIMESTAMP.txt"

echo "[*] varredura completa (pode demorar)..."
nmap -sV -sC $ALVO1 -oN scan_completo_$TIMESTAMP.txt -oX scan_completo_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_completo_$TIMESTAMP.txt"

echo "[*] detecção de sistema operacional (requer root)..."
sudo nmap -O $ALVO1 -oN scan_os_$TIMESTAMP.txt -oX scan_os_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_os_$TIMESTAMP.txt"

echo "[*] varredura udp (requer root)..."
sudo nmap -sU --top-ports 100 $ALVO1 -oN scan_udp_$TIMESTAMP.txt 2>&1
echo "    salvo em: scan_udp_$TIMESTAMP.txt"

echo "[*] varredura de vulnerabilidades..."
nmap --script vuln $ALVO1 -oN scan_vuln_$TIMESTAMP.txt -oX scan_vuln_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_vuln_$TIMESTAMP.txt"

echo "[*] verificando serviços web..."
if grep -q "80\|443\|8080" scan_completo_$TIMESTAMP.txt 2>/dev/null; then
    echo "    serviço web detectado. executando nikto..."
    nikto -h http://$ALVO1 -output nikto_$TIMESTAMP.txt 2>&1
    echo "        salvo em: nikto_$TIMESTAMP.txt"
    
    echo "    coletando headers http..."
    curl -I http://$ALVO1 > headers_$TIMESTAMP.txt 2>&1
    curl -v http://$ALVO1 >> headers_$TIMESTAMP.txt 2>&1
    echo "        salvo em: headers_$TIMESTAMP.txt"
else
    echo "    nenhum serviço web detectado nas portas comuns."
fi

echo "alvo 1: etapa 2 concluída!"
echo ""

# alvo 2
echo "=== alvo 2: $ALVO2 ==="
cd ../../alvo2/etapa2

echo "[*] varredura rápida..."
nmap -F $ALVO2 -oN scan_rapido_$TIMESTAMP.txt -oX scan_rapido_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_rapido_$TIMESTAMP.txt"

echo "[*] varredura completa (pode demorar)..."
nmap -sV -sC $ALVO2 -oN scan_completo_$TIMESTAMP.txt -oX scan_completo_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_completo_$TIMESTAMP.txt"

echo "[*] detecção de sistema operacional (requer root)..."
sudo nmap -O $ALVO2 -oN scan_os_$TIMESTAMP.txt -oX scan_os_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_os_$TIMESTAMP.txt"

echo "[*] varredura udp (requer root)..."
sudo nmap -sU --top-ports 100 $ALVO2 -oN scan_udp_$TIMESTAMP.txt 2>&1
echo "    salvo em: scan_udp_$TIMESTAMP.txt"

echo "[*] varredura de vulnerabilidades..."
nmap --script vuln $ALVO2 -oN scan_vuln_$TIMESTAMP.txt -oX scan_vuln_$TIMESTAMP.xml 2>&1
echo "    salvo em: scan_vuln_$TIMESTAMP.txt"

echo "[*] testando serviços web (roteadores geralmente têm)..."
nikto -h http://$ALVO2 -output nikto_$TIMESTAMP.txt 2>&1
echo "    nikto salvo em: nikto_$TIMESTAMP.txt"

curl -I http://$ALVO2 > headers_$TIMESTAMP.txt 2>&1
curl -v http://$ALVO2 >> headers_$TIMESTAMP.txt 2>&1
echo "    headers http salvo em: headers_$TIMESTAMP.txt"

curl -I -k https://$ALVO2 > headers_https_$TIMESTAMP.txt 2>&1
curl -v -k https://$ALVO2 >> headers_https_$TIMESTAMP.txt 2>&1
echo "    headers https salvo em: headers_https_$TIMESTAMP.txt"

echo "alvo 2: etapa 2 concluída!"
echo ""

# gerar resumo
echo "========================================="
echo "resumo da etapa 2"
echo "========================================="
echo ""
echo "alvo 1 ($ALVO1):"
echo "  - portas abertas:"
grep "open" scan_completo_$TIMESTAMP.txt 2>/dev/null | head -5 || echo "    nenhuma porta aberta encontrada"
echo "  - serviços detectados:"
grep "Service\|Version" scan_completo_$TIMESTAMP.txt 2>/dev/null | head -3 || echo "    nenhum serviço identificado"
echo ""
echo "alvo 2 ($ALVO2):"
echo "  - portas abertas:"
grep "open" scan_completo_$TIMESTAMP.txt 2>/dev/null | head -5 || echo "    nenhuma porta aberta encontrada"
echo "  - serviços detectados:"
grep "Service\|Version" scan_completo_$TIMESTAMP.txt 2>/dev/null | head -3 || echo "    nenhum serviço identificado"
echo ""
echo "próximos passos:"
echo "1. analisar resultados acima"
echo "2. pesquisar vulnerabilidades em bases de dados cve"
echo "3. executar etapa 3: ./scripts/preencher_etapa3.sh"
echo ""

