#!/bin/bash

# script para executar etapa 1 (obtenção de informações) e gerar resultados
# uso: ./preencher_etapa1.sh <ip_alvo1> <ip_alvo2>

if [ $# -lt 2 ]; then
    echo "uso: $0 <ip_alvo1> <ip_alvo2>"
    echo "exemplo: $0 192.168.1.105 192.168.1.1"
    exit 1
fi

ALVO1=$1
ALVO2=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "========================================="
echo "etapa 1: obtenção de informações"
echo "========================================="
echo ""

# criar diretórios
mkdir -p resultados/alvo1/etapa1
mkdir -p resultados/alvo2/etapa1

# alvo 1
echo "=== alvo 1: $ALVO1 ==="
cd resultados/alvo1/etapa1

echo "[*] ping para confirmar conectividade..."
ping -c 4 $ALVO1 > ping_$TIMESTAMP.txt 2>&1
echo "    salvo em: ping_$TIMESTAMP.txt"

echo "[*] dns reverso..."
dig -x $ALVO1 > dns_reverso_$TIMESTAMP.txt 2>&1
echo "    salvo em: dns_reverso_$TIMESTAMP.txt"

echo "[*] nslookup..."
nslookup $ALVO1 > nslookup_$TIMESTAMP.txt 2>&1
echo "    salvo em: nslookup_$TIMESTAMP.txt"

echo "alvo 1: etapa 1 concluída!"
echo ""

# alvo 2
echo "=== alvo 2: $ALVO2 ==="
cd ../../alvo2/etapa1

echo "[*] ping para confirmar conectividade..."
ping -c 4 $ALVO2 > ping_$TIMESTAMP.txt 2>&1
echo "    salvo em: ping_$TIMESTAMP.txt"

echo "[*] dns reverso..."
dig -x $ALVO2 > dns_reverso_$TIMESTAMP.txt 2>&1
echo "    salvo em: dns_reverso_$TIMESTAMP.txt"

echo "[*] nslookup..."
nslookup $ALVO2 > nslookup_$TIMESTAMP.txt 2>&1
echo "    salvo em: nslookup_$TIMESTAMP.txt"

echo "alvo 2: etapa 1 concluída!"
echo ""

# gerar resumo
echo "========================================="
echo "resumo da etapa 1"
echo "========================================="
echo ""
echo "alvo 1 ($ALVO1):"
echo "  - ping: resultados/alvo1/etapa1/ping_$TIMESTAMP.txt"
echo "  - dns reverso: resultados/alvo1/etapa1/dns_reverso_$TIMESTAMP.txt"
echo "  - nslookup: resultados/alvo1/etapa1/nslookup_$TIMESTAMP.txt"
echo ""
echo "alvo 2 ($ALVO2):"
echo "  - ping: resultados/alvo2/etapa1/ping_$TIMESTAMP.txt"
echo "  - dns reverso: resultados/alvo2/etapa1/dns_reverso_$TIMESTAMP.txt"
echo "  - nslookup: resultados/alvo2/etapa1/nslookup_$TIMESTAMP.txt"
echo ""
echo "próximos passos:"
echo "1. revisar resultados acima"
echo "2. executar etapa 2: ./scripts/preencher_etapa2.sh $ALVO1 $ALVO2"
echo ""

