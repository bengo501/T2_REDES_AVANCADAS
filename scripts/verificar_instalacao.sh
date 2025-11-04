#!/bin/bash

# script para verificar se todas as ferramentas necessárias estão instaladas

echo "========================================="
echo "verificação de ferramentas instaladas"
echo "========================================="
echo ""

# lista de ferramentas necessárias
FERAMENTAS=("nmap" "nikto" "whois" "dig" "curl")
FERAMENTAS_OPCIONAIS=("metasploit" "wireshark" "dnsrecon" "theharvester")

# verificar ferramentas obrigatórias
echo "ferramentas obrigatórias:"
echo "------------------------"

TODAS_OK=true
for ferramenta in "${FERAMENTAS[@]}"; do
    if command -v "$ferramenta" >/dev/null 2>&1; then
        echo "✅ $ferramenta: instalado"
        # tentar mostrar versão
        if [ "$ferramenta" = "nmap" ]; then
            nmap --version 2>/dev/null | head -1
        elif [ "$ferramenta" = "nikto" ]; then
            nikto -Version 2>/dev/null | head -1 || echo "    (versão não disponível)"
        elif [ "$ferramenta" = "dig" ]; then
            dig -v 2>/dev/null | head -1 || echo "    (versão não disponível)"
        elif [ "$ferramenta" = "curl" ]; then
            curl --version 2>/dev/null | head -1
        else
            echo "    (verificado)"
        fi
    else
        echo "❌ $ferramenta: não encontrado"
        TODAS_OK=false
        # sugerir instalação
        if command -v apt >/dev/null 2>&1; then
            if [ "$ferramenta" = "dig" ]; then
                echo "    instalar com: sudo apt install dnsutils"
            else
                echo "    instalar com: sudo apt install $ferramenta"
            fi
        fi
    fi
    echo ""
done

# verificar ferramentas opcionais
echo "ferramentas opcionais:"
echo "------------------------"

for ferramenta in "${FERAMENTAS_OPCIONAIS[@]}"; do
    if command -v "$ferramenta" >/dev/null 2>&1; then
        echo "✅ $ferramenta: instalado"
    else
        echo "⚠️  $ferramenta: não encontrado (opcional)"
    fi
done

echo ""
echo "========================================="

# resultado final
if [ "$TODAS_OK" = true ]; then
    echo "✅ todas as ferramentas obrigatórias estão instaladas!"
    echo "você está pronto para começar o trabalho."
else
    echo "❌ algumas ferramentas obrigatórias estão faltando."
    echo "instale as ferramentas faltantes antes de continuar."
    echo ""
    echo "sugestão rápida:"
    if command -v apt >/dev/null 2>&1; then
        echo "sudo apt install nmap nikto whois dnsutils curl"
    elif command -v yum >/dev/null 2>&1; then
        echo "sudo yum install nmap nikto whois bind-utils curl"
    else
        echo "instale as ferramentas manualmente conforme seu sistema."
    fi
fi

echo "========================================="
echo ""


