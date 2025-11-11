#!/bin/bash

set -euo pipefail

# script de coleta de informações - etapa 1
# uso:
#   ./coleta_informacoes.sh <alvo>
#   ./coleta_informacoes.sh --local [nome_alvo]

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

run_and_save() {
    local outfile=$1
    shift
    local cmd=("$@")

    {
        echo "\$ ${cmd[*]}"
        if command_exists "${cmd[0]}"; then
            "${cmd[@]}"
        else
            echo "comando '${cmd[0]}' não encontrado"
        fi
    } >"$outfile" 2>&1
}

mostrar_uso() {
    cat <<EOF
uso: $0 <alvo>
     $0 --local [nome_alvo]

exemplos:
  $0 exemplo.com
  $0 --local desktop_principal
EOF
}

if [ "$#" -eq 0 ]; then
    mostrar_uso
    exit 1
fi

ALVO=""
COLETA_LOCAL=false

if [ "$1" = "--local" ]; then
    COLETA_LOCAL=true
    shift
    if [ "$#" -ge 1 ]; then
        ALVO=$1
        shift
    else
        ALVO=$(hostname 2>/dev/null || echo "alvo_local")
    fi
else
    ALVO=$1
    shift
fi

if [ "$#" -ne 0 ]; then
    echo "argumentos extras: $*"
    mostrar_uso
    exit 1
fi

SLUG=${ALVO//[^a-zA-Z0-9]/_}
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DIR_RESULTADOS="resultados/${TIMESTAMP}_${SLUG}"
mkdir -p "$DIR_RESULTADOS"

echo "=== coletando informações para $ALVO ==="
echo "modo local: $COLETA_LOCAL"
echo "resultados serão salvos em: $DIR_RESULTADOS"
echo ""

if [ "$COLETA_LOCAL" = false ]; then
    echo "[*] executando whois..."
    run_and_save "$DIR_RESULTADOS/whois.txt" whois "$ALVO"
    echo "    salvo em: $DIR_RESULTADOS/whois.txt"

    echo "[*] executando dns lookup (registro a)..."
    run_and_save "$DIR_RESULTADOS/dns_a.txt" dig "$ALVO"
    echo "    salvo em: $DIR_RESULTADOS/dns_a.txt"

    echo "[*] executando dns lookup (registro mx)..."
    run_and_save "$DIR_RESULTADOS/dns_mx.txt" dig "$ALVO" mx
    echo "    salvo em: $DIR_RESULTADOS/dns_mx.txt"

    echo "[*] executando dns lookup (registro ns)..."
    run_and_save "$DIR_RESULTADOS/dns_ns.txt" dig "$ALVO" ns
    echo "    salvo em: $DIR_RESULTADOS/dns_ns.txt"

    echo "[*] executando dns lookup (registro txt)..."
    run_and_save "$DIR_RESULTADOS/dns_txt.txt" dig "$ALVO" txt
    echo "    salvo em: $DIR_RESULTADOS/dns_txt.txt"

    echo "[*] executando nslookup..."
    run_and_save "$DIR_RESULTADOS/nslookup.txt" nslookup "$ALVO"
    echo "    salvo em: $DIR_RESULTADOS/nslookup.txt"

    echo "[*] executando ping..."
    run_and_save "$DIR_RESULTADOS/ping.txt" ping -c 6 "$ALVO"
    echo "    salvo em: $DIR_RESULTADOS/ping.txt"

    if command_exists traceroute; then
        echo "[*] executando traceroute..."
        run_and_save "$DIR_RESULTADOS/traceroute.txt" traceroute "$ALVO"
        echo "    salvo em: $DIR_RESULTADOS/traceroute.txt"
    elif command_exists tracepath; then
        echo "[*] executando tracepath..."
        run_and_save "$DIR_RESULTADOS/tracepath.txt" tracepath "$ALVO"
        echo "    salvo em: $DIR_RESULTADOS/tracepath.txt"
    else
        echo "    nenhuma ferramenta de traceroute encontrada"
    fi
else
    SUBDIR_LOCAL="$DIR_RESULTADOS/local"
    mkdir -p "$SUBDIR_LOCAL"

    echo "[*] coletando informações do sistema local..."
    run_and_save "$SUBDIR_LOCAL/hostname.txt" hostnamectl
    run_and_save "$SUBDIR_LOCAL/uname.txt" uname -a
    run_and_save "$SUBDIR_LOCAL/ip_addr.txt" ip addr show
    run_and_save "$SUBDIR_LOCAL/ip_route.txt" ip route show
    run_and_save "$SUBDIR_LOCAL/arp.txt" arp -n

    if command_exists ss; then
        run_and_save "$SUBDIR_LOCAL/portas_tcp_udp.txt" ss -tulpen
    else
        run_and_save "$SUBDIR_LOCAL/portas_tcp_udp.txt" netstat -tulpen
    fi

    run_and_save "$SUBDIR_LOCAL/resolv.conf" cat /etc/resolv.conf

    if command_exists ping; then
        run_and_save "$SUBDIR_LOCAL/ping_loopback.txt" ping -c 6 127.0.0.1
    fi
fi

echo ""
echo "=== coleta de informações concluída ==="
echo "verifique os resultados em: $DIR_RESULTADOS/"
echo ""

