# sequência completa de comandos para o trabalho

esta é a sequência completa de comandos para executar o trabalho do início ao fim.

## pré-requisitos

### 1. instalar ferramentas

**kali linux (recomendado):**
- já vem com tudo instalado

**ou wsl + ubuntu:**
```bash
sudo apt update
sudo apt install nmap nikto whois dnsutils curl -y
```

### 2. configurar diretório de trabalho

```bash
cd "F:/Game Projects/Godot 4/T2_REDES_AVANCADAS"
mkdir -p resultados/alvo1 resultados/alvo2
chmod +x scripts/*.sh
```

---

## passo 1: descobrir dispositivos na rede

```bash
# descobrir ip do computador
ip route get 8.8.8.8 | awk '{print $7; exit}'
# no windows: ipconfig

# descobrir todos os dispositivos na rede
# ajustar range conforme sua rede (ex: 192.168.0.0/24 ou 192.168.1.0/24)
nmap -sn 192.168.1.0/24

# salvar resultado
nmap -sn 192.168.1.0/24 > dispositivos_rede.txt
```

**anotar:**
- alvo 1 (celular): [ip] (exemplo: 192.168.1.105)
- alvo 2 (roteador): [ip] (exemplo: 192.168.1.1)

---

## passo 2: análise do alvo 1 (celular)

### método 1: usar script automatizado (recomendado)

```bash
# tornar script executável
chmod +x scripts/analise_completa_alvo1.sh

# executar análise (substituir pelo ip do celular)
./scripts/analise_completa_alvo1.sh 192.168.1.105
```

### método 2: comandos manuais (para aprender)

```bash
# definir ip do alvo 1
ALVO1="192.168.1.105"  # substituir pelo ip real

# criar diretórios
mkdir -p resultados/alvo1/etapa1
mkdir -p resultados/alvo1/etapa2

# etapa 1: obtenção de informações
cd resultados/alvo1/etapa1
ping -c 4 $ALVO1 > ping.txt
dig -x $ALVO1 > dns_reverso.txt 2>&1
nslookup $ALVO1 > nslookup.txt 2>&1

# etapa 2: mapeamento e vulnerabilidades
cd ../etapa2
nmap -F $ALVO1 -oN scan_rapido.txt
nmap -sV -sC $ALVO1 -oN scan_completo.txt -oX scan_completo.xml
sudo nmap -O $ALVO1 -oN scan_os.txt 2>/dev/null
sudo nmap -sU --top-ports 100 $ALVO1 -oN scan_udp.txt 2>/dev/null
nmap --script vuln $ALVO1 -oN scan_vuln.txt

# testar serviços web (se houver)
if grep -q "80\|443\|8080" scan_completo.txt; then
    nikto -h http://$ALVO1 -output nikto_resultado.txt 2>&1
    curl -I http://$ALVO1 > headers.txt 2>&1
fi
```

---

## passo 3: análise do alvo 2 (roteador)

### método 1: usar script automatizado (recomendado)

```bash
# tornar script executável
chmod +x scripts/analise_completa_alvo2.sh

# executar análise (substituir pelo ip do roteador)
./scripts/analise_completa_alvo2.sh 192.168.1.1
```

### método 2: comandos manuais (para aprender)

```bash
# definir ip do alvo 2
ALVO2="192.168.1.1"  # substituir pelo ip real

# criar diretórios
mkdir -p resultados/alvo2/etapa1
mkdir -p resultados/alvo2/etapa2

# etapa 1: obtenção de informações
cd resultados/alvo2/etapa1
ping -c 4 $ALVO2 > ping.txt
dig -x $ALVO2 > dns_reverso.txt 2>&1
nslookup $ALVO2 > nslookup.txt 2>&1

# etapa 2: mapeamento e vulnerabilidades
cd ../etapa2
nmap -F $ALVO2 -oN scan_rapido.txt
nmap -sV -sC $ALVO2 -oN scan_completo.txt -oX scan_completo.xml
sudo nmap -O $ALVO2 -oN scan_os.txt 2>/dev/null
sudo nmap -sU --top-ports 100 $ALVO2 -oN scan_udp.txt 2>/dev/null
nmap --script vuln $ALVO2 -oN scan_vuln.txt

# testar serviços web (roteadores geralmente têm)
nikto -h http://$ALVO2 -output nikto_resultado.txt 2>&1
curl -I http://$ALVO2 > headers.txt 2>&1
curl -I -k https://$ALVO2 > headers_https.txt 2>&1
```

---

## passo 4: analisar resultados

### para alvo 1

```bash
cd resultados/alvo1/etapa2

# ver portas abertas
grep "open" scan_completo.txt

# ver serviços detectados
grep "Service\|Version" scan_completo.txt

# ver sistema operacional
cat scan_os.txt | grep -i "os\|running"

# ver vulnerabilidades
grep -i "vulnerable\|risk\|cve" scan_vuln.txt
```

### para alvo 2

```bash
cd resultados/alvo2/etapa2

# ver portas abertas
grep "open" scan_completo.txt

# ver serviços detectados
grep "Service\|Version" scan_completo.txt

# ver sistema operacional
cat scan_os.txt | grep -i "os\|running"

# ver vulnerabilidades
grep -i "vulnerable\|risk\|cve" scan_vuln.txt
```

---

## passo 5: pesquisar vulnerabilidades

**para cada serviço/versão encontrada:**

1. **anotar serviço e versão** (ex: apache 2.4.41, openssh 7.4)

2. **pesquisar em bases de dados:**
   - cve database: https://cve.mitre.org/
   - nvd: https://nvd.nist.gov/
   - buscar: "[serviço] [versão] vulnerabilities"

3. **anotar cves encontrados** (se houver)

**exemplo de pesquisa:**
- serviço: apache 2.4.41
- buscar: "apache 2.4.41 vulnerabilities"
- verificar: https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=apache+2.4.41

---

## passo 6: criar tabelas de resultados

### tabela de serviços em execução

**para cada alvo, criar tabela:**

| porta | protocolo | serviço | versão | estado |
|-------|-----------|---------|--------|--------|
| 22 | tcp | ssh | openssh 7.4 | aberta |
| 80 | tcp | http | apache 2.4.41 | aberta |
| 443 | tcp | https | apache 2.4.41 | aberta |

### tabela de vulnerabilidades

| # | serviço/sistema | descrição da falha | severidade | cvss | cve |
|---|----------------|-------------------|------------|------|-----|
| 1 | apache 2.4.41 | versão vulnerável a cve-2021-xxxxx | alta | 7.5 | cve-2021-xxxxx |
| 2 | openssh 7.4 | versão antiga, múltiplas vulnerabilidades | média | 5.3 | cve-2020-xxxxx |

---

## passo 7: análise de impacto (etapa 3)

**para cada vulnerabilidade encontrada:**

1. **analisar impacto:**
   - o que um atacante poderia fazer?
   - qual a complexidade do ataque?
   - qual o impacto no sistema?

2. **propor correção:**
   - atualização de versão
   - patch específico
   - reconfiguração do serviço

3. **propor mitigação:**
   - desabilitar serviço (se não necessário)
   - bloquear acesso via firewall
   - usar controle de acesso

4. **classificar severidade:**
   - crítica: execução remota de código, acesso total
   - alta: acesso não autorizado, elevação de privilégios
   - média: divulgação de informações, negação de serviço
   - baixa: informações limitadas, impacto mínimo

---

## passo 8: preencher relatório

### abrir template do relatório

```bash
# abrir relatorio.md no editor
# ou visualizar:
cat relatorio.md
```

### preencher seções

**seção 1: introdução**
- informações dos dois alvos
- escopo do teste
- justificativa da escolha

**seção 2: etapa 1**
- ferramentas utilizadas
- resultados para cada alvo

**seção 3: etapa 2**
- ferramentas utilizadas
- tabela de serviços em execução
- sistema operacional detectado
- superfície de ataque
- tabela de vulnerabilidades

**seção 4: etapa 3**
- análise de impacto para cada vulnerabilidade
- proposta de correção/mitigação
- prioridade

**seção 5: conclusão**
- resumo geral dos achados
- recomendações gerais
- importância das correções

---

## comandos rápidos de referência

### descobrir dispositivos na rede

```bash
nmap -sn 192.168.1.0/24
```

### varredura completa

```bash
nmap -sV -sC [ip] -oN scan_completo.txt
```

### detecção de os (requer root)

```bash
sudo nmap -O [ip] -oN scan_os.txt
```

### varredura de vulnerabilidades

```bash
nmap --script vuln [ip] -oN scan_vuln.txt
```

### scanner web

```bash
nikto -h http://[ip] -output nikto.txt
```

### análise de headers

```bash
curl -I http://[ip] > headers.txt
```

---

## sequência completa rápida (usando scripts)

```bash
# 1. descobrir dispositivos na rede
nmap -sn 192.168.1.0/24 > dispositivos_rede.txt

# 2. análise do alvo 1 (celular)
chmod +x scripts/analise_completa_alvo1.sh
./scripts/analise_completa_alvo1.sh 192.168.1.105

# 3. análise do alvo 2 (roteador)
chmod +x scripts/analise_completa_alvo2.sh
./scripts/analise_completa_alvo2.sh 192.168.1.1

# 4. analisar resultados
grep "open" resultados/alvo1/etapa2/scan_completo*.txt
grep "open" resultados/alvo2/etapa2/scan_completo*.txt

# 5. pesquisar vulnerabilidades em bases de dados cve
# 6. preencher relatorio.md
```

---

## checklist final

- [ ] ferramentas instaladas
- [ ] dispositivos na rede identificados
- [ ] alvo 1: etapa 1 completa
- [ ] alvo 1: etapa 2 completa
- [ ] alvo 2: etapa 1 completa
- [ ] alvo 2: etapa 2 completa
- [ ] vulnerabilidades pesquisadas
- [ ] análise de impacto realizada
- [ ] relatório completo
- [ ] apresentação preparada

---

**boa sorte com o trabalho!**

