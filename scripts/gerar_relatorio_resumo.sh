#!/bin/bash

# script para gerar resumo dos resultados encontrados
# ajuda a consolidar informações para o relatório

echo "=== gerador de resumo de resultados ==="
echo ""

# procurar por resultados do nmap
echo "=== resultados de varreduras nmap encontrados ==="
find resultados -name "nmap_*.txt" -type f | while read file; do
    echo ""
    echo "arquivo: $file"
    echo "---"
    grep -E "^[0-9]+/(tcp|udp)" "$file" | head -20
done

echo ""
echo "=== serviços detectados ==="
find resultados -name "nmap_version_*.txt" -type f -exec grep -h "open\|filtered\|closed" {} \; | sort -u

echo ""
echo "=== sistemas operacionais detectados ==="
find resultados -name "nmap_os_*.txt" -type f -exec grep -h -i "os\|running\|os details" {} \;

echo ""
echo "=== vulnerabilidades web detectadas (nikto) ==="
find resultados -name "nikto_*.txt" -type f | while read file; do
    echo ""
    echo "arquivo: $file"
    echo "---"
    grep -i "vulnerable\|vulnerability\|risk" "$file" | head -10
done

echo ""
echo "=== informações dns coletadas ==="
find resultados -name "dns_*.txt" -type f | while read file; do
    echo ""
    echo "arquivo: $file"
    echo "---"
    head -10 "$file"
done

echo ""
echo "=== resumo gerado ==="
echo "use estas informações para preencher o relatório"

