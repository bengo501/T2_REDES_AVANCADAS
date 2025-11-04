#!/bin/bash

# script completo para integrante do grupo - etapa 2 (mapeamento e vulnerabilidades)
# uso: ./minha_parte_trabalho.sh <ip_ou_dominio>

if [ -z "$1" ]; then
    echo "uso: $0 <ip_ou_dominio>"
    echo "exemplo: $0 192.168.1.1"
    echo "exemplo: $0 exemplo.com"
    exit 1
fi

ALVO=$1
DIR_RESULTADOS="resultados/alvo1"
mkdir -p "$DIR_RESULTADOS"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "========================================="
echo "análise de vulnerabilidades - etapa 2"
echo "alvo: $ALVO"
echo "resultados salvos em: $DIR_RESULTADOS/"
echo "========================================="
echo ""

# verificar ferramentas instaladas
echo "[*] verificando ferramentas instaladas..."
command -v nmap >/dev/null 2>&1 || { echo "erro: nmap não encontrado. instale com: sudo apt install nmap"; exit 1; }
command -v nikto >/dev/null 2>&1 || echo "aviso: nikto não encontrado. instale com: sudo apt install nikto"
command -v curl >/dev/null 2>&1 || { echo "erro: curl não encontrado. instale com: sudo apt install curl"; exit 1; }
echo "    ok: ferramentas verificadas"
echo ""

# varredura rápida
echo "[1/7] varredura rápida de portas comuns..."
nmap -F "$ALVO" -oN "$DIR_RESULTADOS/scan_rapido_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/scan_rapido_$TIMESTAMP.xml" 2>&1
echo "    salvo em: $DIR_RESULTADOS/scan_rapido_$TIMESTAMP.txt"
echo ""

# varredura completa (pode demorar)
echo "[2/7] varredura completa com detecção de versões (pode demorar alguns minutos)..."
nmap -sV -sC "$ALVO" -oN "$DIR_RESULTADOS/scan_completo_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/scan_completo_$TIMESTAMP.xml" 2>&1
echo "    salvo em: $DIR_RESULTADOS/scan_completo_$TIMESTAMP.txt"
echo ""

# detecção de sistema operacional
echo "[3/7] detecção de sistema operacional..."
nmap -O "$ALVO" -oN "$DIR_RESULTADOS/scan_os_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/scan_os_$TIMESTAMP.xml" 2>&1
echo "    salvo em: $DIR_RESULTADOS/scan_os_$TIMESTAMP.txt"
echo ""

# varredura udp
echo "[4/7] varredura udp (100 portas mais comuns)..."
nmap -sU --top-ports 100 "$ALVO" -oN "$DIR_RESULTADOS/scan_udp_$TIMESTAMP.txt" 2>&1
echo "    salvo em: $DIR_RESULTADOS/scan_udp_$TIMESTAMP.txt"
echo ""

# verificar se há serviço web
echo "[5/7] verificando serviços web..."
if grep -q "80\|443\|8080" "$DIR_RESULTADOS/scan_completo_$TIMESTAMP.txt" 2>/dev/null; then
    echo "    serviço web detectado. executando varreduras web..."
    
    # nikto
    if command -v nikto >/dev/null 2>&1; then
        echo "    executando nikto..."
        nikto -h "http://$ALVO" -output "$DIR_RESULTADOS/nikto_$TIMESTAMP.txt" 2>&1
        echo "        salvo em: $DIR_RESULTADOS/nikto_$TIMESTAMP.txt"
    fi
    
    # headers http
    echo "    coletando headers http..."
    curl -I "http://$ALVO" > "$DIR_RESULTADOS/headers_$TIMESTAMP.txt" 2>&1
    curl -v "http://$ALVO" >> "$DIR_RESULTADOS/headers_$TIMESTAMP.txt" 2>&1
    echo "        salvo em: $DIR_RESULTADOS/headers_$TIMESTAMP.txt"
else
    echo "    nenhum serviço web detectado. pulando varreduras web..."
fi
echo ""

# varredura de vulnerabilidades
echo "[6/7] varredura de vulnerabilidades com nmap scripts..."
nmap --script vuln "$ALVO" -oN "$DIR_RESULTADOS/scan_vuln_$TIMESTAMP.txt" -oX "$DIR_RESULTADOS/scan_vuln_$TIMESTAMP.xml" 2>&1
echo "    salvo em: $DIR_RESULTADOS/scan_vuln_$TIMESTAMP.txt"
echo ""

# gerar resumo
echo "[7/7] gerando resumo das descobertas..."
cat > "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" << EOF
=========================================
resumo da análise - alvo: $ALVO
data: $(date)
=========================================

=== portas abertas (tcp) ===
EOF

grep "open\|filtered" "$DIR_RESULTADOS/scan_completo_$TIMESTAMP.txt" | grep -v "^#" >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" 2>/dev/null

cat >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" << EOF

=== serviços detectados ===
EOF

grep -i "Service\|Version" "$DIR_RESULTADOS/scan_completo_$TIMESTAMP.txt" | grep -v "^#" | head -20 >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" 2>/dev/null

cat >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" << EOF

=== sistema operacional detectado ===
EOF

grep -i "os\|running" "$DIR_RESULTADOS/scan_os_$TIMESTAMP.txt" | grep -v "^#" | head -10 >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" 2>/dev/null

if [ -f "$DIR_RESULTADOS/nikto_$TIMESTAMP.txt" ]; then
    cat >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" << EOF

=== vulnerabilidades web detectadas (nikto) ===
EOF
    grep -i "vulnerable\|risk" "$DIR_RESULTADOS/nikto_$TIMESTAMP.txt" | head -10 >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" 2>/dev/null
fi

cat >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" << EOF

=== vulnerabilidades detectadas (nmap vuln scripts) ===
EOF

grep -i "vulnerable\|risk\|cve" "$DIR_RESULTADOS/scan_vuln_$TIMESTAMP.txt" | head -20 >> "$DIR_RESULTADOS/resumo_$TIMESTAMP.txt" 2>/dev/null

echo "    salvo em: $DIR_RESULTADOS/resumo_$TIMESTAMP.txt"
echo ""

# exibir estatísticas rápidas
echo "========================================="
echo "estatísticas rápidas:"
echo "========================================="
echo ""
echo "portas abertas (tcp):"
grep -c "open" "$DIR_RESULTADOS/scan_completo_$TIMESTAMP.txt" 2>/dev/null | head -1 || echo "0"
echo ""
echo "portas abertas (udp):"
grep -c "open" "$DIR_RESULTADOS/scan_udp_$TIMESTAMP.txt" 2>/dev/null | head -1 || echo "0"
echo ""
echo "arquivos criados:"
ls -lh "$DIR_RESULTADOS"/*"$TIMESTAMP"* 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
echo ""

echo "========================================="
echo "análise concluída!"
echo "========================================="
echo ""
echo "próximos passos:"
echo "1. revisar resultados em: $DIR_RESULTADOS/"
echo "2. ler resumo: cat $DIR_RESULTADOS/resumo_$TIMESTAMP.txt"
echo "3. analisar vulnerabilidades encontradas"
echo "4. pesquisar cves relacionados"
echo "5. preencher relatorio.md com os resultados"
echo ""
echo "comandos úteis:"
echo "  cat $DIR_RESULTADOS/resumo_$TIMESTAMP.txt"
echo "  grep 'open' $DIR_RESULTADOS/scan_completo_$TIMESTAMP.txt"
echo "  grep -i 'vulnerable' $DIR_RESULTADOS/scan_vuln_$TIMESTAMP.txt"
echo ""


