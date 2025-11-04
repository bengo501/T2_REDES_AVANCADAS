#!/bin/bash

# script para gerar estrutura da etapa 3 (análise de impacto) baseado nos resultados
# uso: ./preencher_etapa3.sh

echo "========================================="
echo "etapa 3: análise de impacto"
echo "========================================="
echo ""

# encontrar arquivos mais recentes
ALVO1_SCAN=$(find resultados/alvo1/etapa2 -name "scan_completo_*.txt" -type f | sort -r | head -1)
ALVO1_VULN=$(find resultados/alvo1/etapa2 -name "scan_vuln_*.txt" -type f | sort -r | head -1)
ALVO2_SCAN=$(find resultados/alvo2/etapa2 -name "scan_completo_*.txt" -type f | sort -r | head -1)
ALVO2_VULN=$(find resultados/alvo2/etapa2 -name "scan_vuln_*.txt" -type f | sort -r | head -1)

if [ -z "$ALVO1_SCAN" ] || [ -z "$ALVO2_SCAN" ]; then
    echo "erro: arquivos de scan não encontrados."
    echo "execute primeiro a etapa 2: ./scripts/preencher_etapa2.sh <ip1> <ip2>"
    exit 1
fi

echo "[*] analisando resultados do alvo 1..."
echo "    scan completo: $ALVO1_SCAN"
if [ -n "$ALVO1_VULN" ]; then
    echo "    scan vulnerabilidades: $ALVO1_VULN"
fi

echo "[*] analisando resultados do alvo 2..."
echo "    scan completo: $ALVO2_SCAN"
if [ -n "$ALVO2_VULN" ]; then
    echo "    scan vulnerabilidades: $ALVO2_VULN"
fi

echo ""

# gerar arquivo de análise
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="etapa3_analise_$TIMESTAMP.txt"

cat > $OUTPUT_FILE << EOF
=========================================
etapa 3: análise de impacto
data: $(date)
=========================================

=== alvo 1 ===

portas abertas encontradas:
EOF

grep "open" "$ALVO1_SCAN" 2>/dev/null | head -20 >> $OUTPUT_FILE || echo "nenhuma porta aberta encontrada" >> $OUTPUT_FILE

cat >> $OUTPUT_FILE << EOF

serviços detectados:
EOF

grep "Service\|Version" "$ALVO1_SCAN" 2>/dev/null | head -20 >> $OUTPUT_FILE || echo "nenhum serviço identificado" >> $OUTPUT_FILE

if [ -n "$ALVO1_VULN" ]; then
    cat >> $OUTPUT_FILE << EOF

vulnerabilidades detectadas:
EOF
    grep -i "vulnerable\|risk\|cve" "$ALVO1_VULN" 2>/dev/null | head -20 >> $OUTPUT_FILE || echo "nenhuma vulnerabilidade conhecida detectada" >> $OUTPUT_FILE
fi

cat >> $OUTPUT_FILE << EOF

=== alvo 2 ===

portas abertas encontradas:
EOF

grep "open" "$ALVO2_SCAN" 2>/dev/null | head -20 >> $OUTPUT_FILE || echo "nenhuma porta aberta encontrada" >> $OUTPUT_FILE

cat >> $OUTPUT_FILE << EOF

serviços detectados:
EOF

grep "Service\|Version" "$ALVO2_SCAN" 2>/dev/null | head -20 >> $OUTPUT_FILE || echo "nenhum serviço identificado" >> $OUTPUT_FILE

if [ -n "$ALVO2_VULN" ]; then
    cat >> $OUTPUT_FILE << EOF

vulnerabilidades detectadas:
EOF
    grep -i "vulnerable\|risk\|cve" "$ALVO2_VULN" 2>/dev/null | head -20 >> $OUTPUT_FILE || echo "nenhuma vulnerabilidade conhecida detectada" >> $OUTPUT_FILE
fi

cat >> $OUTPUT_FILE << EOF

=========================================
próximos passos:

1. revisar resultados acima
2. pesquisar vulnerabilidades em bases de dados cve:
   - https://cve.mitre.org/
   - https://nvd.nist.gov/
3. para cada vulnerabilidade encontrada:
   - analisar impacto
   - propor correção
   - propor mitigação
   - classificar severidade
4. preencher seção 4 do relatorio.md com análise detalhada
=========================================
EOF

echo "análise gerada em: $OUTPUT_FILE"
echo ""
echo "========================================="
echo "resumo da etapa 3"
echo "========================================="
echo ""
cat $OUTPUT_FILE
echo ""
echo "próximos passos:"
echo "1. revisar arquivo: $OUTPUT_FILE"
echo "2. pesquisar vulnerabilidades em bases de dados cve"
echo "3. preencher seção 4 do relatorio.md com análise detalhada"
echo ""

