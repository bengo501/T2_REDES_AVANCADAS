#!/bin/bash

# script para descobrir dispositivos na rede local
# uso: ./descobrir_dispositivos_rede.sh

echo "========================================="
echo "descoberta de dispositivos na rede local"
echo "========================================="
echo ""

# descobrir ip do computador
echo "[*] descobrindo ip do computador..."
IP_COMPUTADOR=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $7; exit}' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')

if [ -z "$IP_COMPUTADOR" ]; then
    # tentar método alternativo
    IP_COMPUTADOR=$(hostname -I | awk '{print $1}')
fi

if [ -z "$IP_COMPUTADOR" ]; then
    echo "erro: não foi possível descobrir ip do computador"
    echo "por favor, informe manualmente o range da rede"
    echo "exemplo: 192.168.1.0/24"
    read -p "digite o range da rede (ex: 192.168.1.0/24): " RANGE_REDE
else
    # extrair range da rede (assumir /24)
    RANGE_REDE=$(echo $IP_COMPUTADOR | sed 's/\.[0-9]*$/\.0\/24/')
    echo "    ip do computador: $IP_COMPUTADOR"
    echo "    range da rede detectado: $RANGE_REDE"
fi

echo ""
echo "[*] varrendo rede para descobrir dispositivos..."
echo "    isso pode demorar alguns minutos..."
echo ""

# verificar se nmap está instalado
if ! command -v nmap >/dev/null 2>&1; then
    echo "erro: nmap não encontrado"
    echo "instale com: sudo apt install nmap"
    exit 1
fi

# executar varredura ping
echo "=== varredura ping (descoberta de hosts) ==="
nmap -sn $RANGE_REDE | tee scan_dispositivos.txt

echo ""
echo "=== dispositivos encontrados ==="
echo ""

# extrair informações dos dispositivos
grep -E "Nmap scan report|MAC Address|Host is up" scan_dispositivos.txt | while read line; do
    if [[ $line =~ "Nmap scan report" ]]; then
        IP=$(echo $line | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
        HOSTNAME=$(echo $line | sed 's/.*for //' | sed 's/ ([0-9].*//')
        echo ""
        echo "dispositivo: $HOSTNAME"
        echo "  ip: $IP"
    elif [[ $line =~ "MAC Address" ]]; then
        MAC=$(echo $line | grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}')
        VENDOR=$(echo $line | sed 's/.*MAC Address: [^ ]* //')
        echo "  mac: $MAC"
        echo "  fabricante: $VENDOR"
    fi
done

echo ""
echo "========================================="
echo "resumo:"
echo "========================================="
echo ""

# contar dispositivos encontrados
NUM_HOSTS=$(grep -c "Nmap scan report" scan_dispositivos.txt 2>/dev/null || echo "0")
echo "total de dispositivos encontrados: $NUM_HOSTS"
echo ""

# listar ips encontrados
echo "ips encontrados:"
grep "Nmap scan report" scan_dispositivos.txt | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | while read ip; do
    echo "  - $ip"
done

echo ""
echo "========================================="
echo "próximos passos:"
echo "========================================="
echo ""
echo "1. identificar qual dispositivo é o celular:"
echo "   - procurar por fabricante (samsung, apple, etc.)"
echo "   - ou pelo nome do dispositivo (android-xxxxx, iphone-xxxxx)"
echo ""
echo "2. anotar o ip do celular"
echo ""
echo "3. executar análise no celular:"
echo "   ./scripts/minha_parte_trabalho.sh [ip_do_celular]"
echo ""
echo "4. ou usar comandos manuais:"
echo "   nmap -sV -sC [ip_do_celular] -oN scan_celular.txt"
echo ""
echo "========================================="
echo "resultados salvos em: scan_dispositivos.txt"
echo "========================================="
echo ""

