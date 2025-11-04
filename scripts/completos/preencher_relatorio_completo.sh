#!/bin/bash

# script completo para executar todas as etapas e gerar relatório parcial
# uso: ./preencher_relatorio_completo.sh <ip_alvo1> <ip_alvo2>

if [ $# -lt 2 ]; then
    echo "uso: $0 <ip_alvo1> <ip_alvo2>"
    echo "exemplo: $0 192.168.1.105 192.168.1.1"
    exit 1
fi

ALVO1=$1
ALVO2=$2

echo "========================================="
echo "análise completa - todas as etapas"
echo "alvo 1: $ALVO1"
echo "alvo 2: $ALVO2"
echo "========================================="
echo ""

# etapa 1
echo "=== executando etapa 1: obtenção de informações ==="
./scripts/preencher_etapa1.sh $ALVO1 $ALVO2
echo ""

# etapa 2
echo "=== executando etapa 2: mapeamento e vulnerabilidades ==="
./scripts/preencher_etapa2.sh $ALVO1 $ALVO2
echo ""

# etapa 3
echo "=== executando etapa 3: análise de impacto ==="
./scripts/preencher_etapa3.sh
echo ""

# gerar resumo final
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESUMO_FILE="resumo_completo_$TIMESTAMP.txt"

cat > $RESUMO_FILE << EOF
=========================================
resumo completo da análise
data: $(date)
=========================================

alvo 1: $ALVO1
alvo 2: $ALVO2

=== etapa 1: obtenção de informações ===

resultados salvos em:
- alvo 1: resultados/alvo1/etapa1/
- alvo 2: resultados/alvo2/etapa1/

=== etapa 2: mapeamento e vulnerabilidades ===

resultados salvos em:
- alvo 1: resultados/alvo1/etapa2/
- alvo 2: resultados/alvo2/etapa2/

=== etapa 3: análise de impacto ===

consulte o arquivo etapa3_analise_*.txt para análise detalhada

=========================================
próximos passos:

1. revisar todos os resultados gerados
2. preencher relatorio.md com os resultados:
   - seção 2: etapa 1 (resultados acima)
   - seção 3: etapa 2 (resultados acima)
   - seção 4: etapa 3 (análise de impacto)
3. pesquisar vulnerabilidades em bases de dados cve
4. completar análise de impacto manualmente
5. adicionar conclusão e anexos
=========================================
EOF

echo "========================================="
echo "análise completa concluída!"
echo "========================================="
echo ""
echo "resumo salvo em: $RESUMO_FILE"
echo ""
echo "próximos passos:"
echo "1. revisar arquivo: $RESUMO_FILE"
echo "2. revisar todos os resultados em:"
echo "   - resultados/alvo1/"
echo "   - resultados/alvo2/"
echo "3. preencher relatorio.md com os resultados"
echo "4. pesquisar vulnerabilidades em bases de dados cve"
echo "5. completar análise de impacto manualmente"
echo ""

