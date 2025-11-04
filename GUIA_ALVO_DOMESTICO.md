# guia: descobrindo seu alvo em ambiente doméstico

este guia explica como descobrir o alvo e realizar a análise em ambiente doméstico, usando seu celular como alvo.

## posso usar meu celular como alvo?

**sim, você pode usar seu celular como alvo!** mas há algumas considerações importantes:

### vantagens

- ✅ ambiente controlado (seu próprio dispositivo)
- ✅ não precisa de autorização externa
- ✅ fácil de resetar se algo der errado
- ✅ aprendizado prático
- ✅ permite testar em ambiente real

### considerações importantes

⚠️ **atenção:**
- você deve ser o **proprietário** do dispositivo
- você deve ter **autorização** para testar
- use apenas em **rede doméstica** (não em redes públicas)
- **não compartilhe** resultados com terceiros sem autorização
- esteja ciente de que pode **afetar o dispositivo** temporariamente

---

## passo 1: descobrir o ip do celular

### método 1: descobrir ip via celular android

**passo a passo:**

1. **abrir configurações** no celular
2. **ir para:** conexões / wifi (ou configurações de rede)
3. **tocar no wifi conectado** (ou no ícone de engrenagem)
4. **procurar por:** "detalhes da rede" ou "informações do ip"
5. **anotar o ip:** aparecerá como "endereço ip" (exemplo: 192.168.1.105)

**ou:**

1. **abrir configurações**
2. **ir para:** sobre o telefone / informações do sistema
3. **procurar por:** status / informações do dispositivo
4. **anotar o ip:** aparecerá como "endereço ip"

### método 2: descobrir ip via celular ios (iphone)

**passo a passo:**

1. **abrir configurações**
2. **ir para:** wifi
3. **tocar no ícone (i)** ao lado do wifi conectado
4. **anotar o ip:** aparecerá como "endereço ip" (exemplo: 192.168.1.105)

### método 3: descobrir ip via computador (mais fácil)

**no windows:**

```powershell
# abrir powershell ou cmd
arp -a

# ou usar comando específico
ping -4 [nome_do_dispositivo]
```

**no linux/mac:**

```bash
# descobrir dispositivos na rede
arp -a

# ou usar nmap para descobrir
nmap -sn 192.168.1.0/24

# ou usar arp-scan
sudo arp-scan --local
```

**identificar o celular:**
- procurar por nome do dispositivo (ex: "android-xxxxx", "iphone-xxxxx")
- ou pelo fabricante (ex: "samsung", "apple")

### método 4: usar aplicativo no celular

**android:**
- instalar app: "ip tools: network utilities"
- ou: "network info ii"
- mostrará o ip do dispositivo

**ios:**
- instalar app: "network analyzer"
- ou: "fing"
- mostrará o ip do dispositivo

---

## passo 2: confirmar que celular e computador estão na mesma rede

### verificar ip do computador

**no windows:**

```powershell
ipconfig
```

procurar por:
- **adaptador de rede sem fio wifi:**
  - endereço ipv4: 192.168.1.xxx (exemplo)
  - máscara de sub-rede: 255.255.255.0
  - gateway padrão: 192.168.1.1

**no linux/mac:**

```bash
ifconfig
# ou
ip addr show
```

procurar por:
- **wlan0** ou **en0:**
  - inet: 192.168.1.xxx (exemplo)
  - netmask: 255.255.255.0

### verificar se estão na mesma rede

**celular e computador devem ter:**
- mesmo prefixo de rede (ex: ambos começando com 192.168.1.x)
- mesmo gateway (ex: ambos 192.168.1.1)

**exemplo:**
- computador: 192.168.1.100
- celular: 192.168.1.105
- gateway: 192.168.1.1
- ✅ mesma rede

---

## passo 3: preparar o celular para análise

### configurações recomendadas no celular

**android:**

1. **ativar wifi** (se não estiver)
2. **desabilitar vpn** (se estiver usando)
3. **permitir conexões locais:**
   - configurações > wifi > configurações avançadas
   - permitir conexões locais (se houver opção)
4. **desabilitar firewall temporariamente** (se houver)
5. **manter celular conectado** durante toda a análise

**ios (iphone):**

1. **ativar wifi** (se não estiver)
2. **desabilitar vpn** (se estiver usando)
3. **permitir conexões locais:**
   - configurações > wifi > (i) ao lado do wifi
   - verificar se está conectado
4. **manter celular conectado** durante toda a análise

### anotar informações do celular

**anotar:**
- modelo do celular
- versão do sistema operacional
- ip do celular (ex: 192.168.1.105)
- fabricante (ex: samsung, apple, xiaomi)

---

## passo 4: executar análise no computador

### passo 4.1: descobrir o ip do celular (se ainda não tiver)

**usando nmap para descobrir dispositivos:**

```bash
# descobrir todos os dispositivos na rede
nmap -sn 192.168.1.0/24

# substituir 192.168.1.0/24 pelo seu range de rede
# exemplo: se seu computador é 192.168.1.100, use 192.168.1.0/24
```

**identificar o celular:**
- procurar por nome do dispositivo
- ou pelo fabricante
- anotar o ip encontrado

### passo 4.2: executar varreduras no celular

**usando o script fornecido:**

```bash
# tornar script executável (se no linux)
chmod +x scripts/minha_parte_trabalho.sh

# executar análise (substitua pelo ip do celular)
./scripts/minha_parte_trabalho.sh 192.168.1.105
```

**ou usando comandos manuais:**

```bash
# criar diretório
mkdir -p resultados/celular
cd resultados/celular

# definir ip do celular (substitua pelo ip real)
CELULAR="192.168.1.105"

# varredura rápida
nmap -F $CELULAR -oN scan_rapido.txt

# varredura completa (pode demorar)
nmap -sV -sC $CELULAR -oN scan_completo.txt

# detecção de sistema operacional
nmap -O $CELULAR -oN scan_os.txt

# varredura udp
nmap -sU --top-ports 100 $CELULAR -oN scan_udp.txt

# verificar se há serviços web
grep "80\|443\|8080" scan_completo.txt

# se houver serviço web
nikto -h http://$CELULAR -output nikto_resultado.txt

# varredura de vulnerabilidades
nmap --script vuln $CELULAR -oN scan_vuln.txt
```

### passo 4.3: analisar resultados

**ver portas abertas:**

```bash
grep "open" scan_completo.txt
```

**ver serviços detectados:**

```bash
grep "Service\|Version" scan_completo.txt
```

**ver sistema operacional:**

```bash
grep -i "os\|running" scan_os.txt
```

**ver vulnerabilidades:**

```bash
grep -i "vulnerable\|risk\|cve" scan_vuln.txt
```

---

## passo 5: descobrir informações do celular

### coleta de informações (etapa 1)

**se o celular tiver nome de domínio ou hostname:**

```bash
# definir hostname do celular (se houver)
HOSTNAME="android-xxxxx"  # ou iphone-xxxxx

# nslookup
nslookup $HOSTNAME

# dig (se houver domínio)
dig $HOSTNAME

# ping para confirmar
ping -c 4 $HOSTNAME
```

**coletar informações básicas:**

```bash
# criar diretório
mkdir -p resultados/celular/etapa1
cd resultados/celular/etapa1

# definir ip do celular
CELULAR="192.168.1.105"

# ping para confirmar conectividade
ping -c 4 $CELULAR > ping.txt

# dns reverso (se houver)
dig -x $CELULAR > dns_reverso.txt

# anotar informações:
# - modelo do celular
# - versão do android/ios
# - fabricante
# - ip do celular
```

---

## passo 6: documentar no relatório

### preencher relatorio.md

**seção 1: introdução**

```markdown
#### alvo 1: celular android/ios

- **nome/identificação:** [modelo do celular]
- **endereço ip:** 192.168.1.105
- **tipo:** dispositivo móvel
- **sistema operacional:** android 13 / ios 17
- **fabricante:** samsung / apple / etc.
- **escopo do teste:**
  - **dentro do escopo:**
    - análise de portas abertas
    - identificação de serviços expostos
    - detecção de vulnerabilidades conhecidas
    - análise de superfície de ataque
  - **fora do escopo:**
    - exploração de vulnerabilidades
    - acesso não autorizado
    - modificação de configurações
```

**seção 2: etapa 1 - obtenção de informações**

```markdown
### alvo 1: celular

**ferramentas utilizadas:**
- ping: confirmação de conectividade
- nmap: descoberta de dispositivos na rede
- dig: dns reverso (se aplicável)

**resultados:**
- ip do celular: 192.168.1.105
- conectividade: confirmada (ping bem-sucedido)
- hostname: android-xxxxx (ou iphone-xxxxx)
```

**seção 3: etapa 2 - mapeamento e vulnerabilidades**

```markdown
### alvo 1: celular

**serviços em execução:**

| porta | protocolo | serviço | versão | estado |
|-------|-----------|---------|--------|--------|
| [porta] | tcp/udp | [serviço] | [versão] | aberta/fechada |

**sistema operacional detectado:**
- sistema: android 13 / ios 17
- confiança: [nível]
- evidências: [como foi detectado]

**vulnerabilidades detectadas:**

| # | serviço/sistema | descrição | severidade | cvss | cve |
|---|----------------|-----------|------------|------|-----|
| 1 | [serviço] | [descrição] | [alta/média/baixa] | [pontuação] | [cve-id] |
```

---

## considerações importantes

### segurança e ética

1. **você é o proprietário?**
   - ✅ sim: pode testar
   - ❌ não: precisa de autorização explícita

2. **rede doméstica?**
   - ✅ sim: seguro para testar
   - ❌ não: não teste em redes públicas

3. **compartilhamento de resultados?**
   - ✅ apenas para o trabalho acadêmico
   - ❌ não compartilhe com terceiros sem autorização

### limitações de análise em celular

**celulares geralmente têm:**
- poucas portas abertas (por segurança)
- firewall ativo
- serviços limitados expostos
- pode ser difícil encontrar vulnerabilidades

**mas ainda é válido para:**
- aprendizado prático
- entender como funciona análise de rede
- identificar serviços expostos
- detectar superfície de ataque

### o que você pode encontrar

**possíveis descobertas:**
- porta 22 (ssh) - se houver serviço de depuração
- porta 80/443 (http/https) - se houver servidor web
- porta 5555 (adb) - se houver android debugging
- porta 8080 (http alternativo) - se houver serviço web
- serviços de mídia (dlna, airplay, etc.)

**vulnerabilidades possíveis:**
- versões desatualizadas de serviços
- configurações inseguras
- serviços expostos desnecessariamente
- informações de sistema divulgadas

---

## exemplo prático completo

### exemplo: descobrir e analisar celular android

**passo 1: descobrir ip do celular**

```bash
# no computador, descobrir dispositivos na rede
nmap -sn 192.168.1.0/24

# resultado exemplo:
# Nmap scan report for 192.168.1.105
# Host is up (0.001s latency).
# MAC Address: AA:BB:CC:DD:EE:FF (Samsung Electronics)
```

**passo 2: executar análise**

```bash
# criar diretório
mkdir -p resultados/celular_android
cd resultados/celular_android

# definir ip
CELULAR="192.168.1.105"

# varredura completa
nmap -sV -sC $CELULAR -oN scan_completo.txt

# resultados exemplo:
# PORT     STATE    SERVICE    VERSION
# 5555/tcp open     adb        Android Debug Bridge
# 8080/tcp open     http-proxy HTTP Proxy
```

**passo 3: analisar resultados**

```bash
# ver portas abertas
grep "open" scan_completo.txt

# ver serviços
grep "Service\|Version" scan_completo.txt

# pesquisar vulnerabilidades
# usar cve database para pesquisar:
# - android debug bridge vulnerabilities
# - http proxy vulnerabilities
```

**passo 4: documentar**

- criar tabela de serviços
- identificar vulnerabilidades conhecidas
- analisar impacto
- propor correções

---

## dicas importantes

### 1. use ferramentas apropriadas

- **nmap:** varredura de portas
- **nikto:** vulnerabilidades web (se houver serviço web)
- **arp-scan:** descoberta de dispositivos
- **wireshark:** análise de tráfego (opcional)

### 2. documente tudo

- anote ip do celular
- anote modelo e versão do sistema
- salve todos os outputs
- tire screenshots importantes

### 3. seja ético

- teste apenas seu próprio dispositivo
- não compartilhe resultados sem autorização
- use apenas para fins educacionais
- não cause danos intencionais

### 4. aprenda com os resultados

- mesmo que não encontre muitas vulnerabilidades, isso é um resultado válido
- celulares modernos são mais seguros (menos portas abertas)
- documente o que encontrou e o que não encontrou
- explique por que o dispositivo está seguro

---

## resumo rápido

### descobrir ip do celular

**método mais fácil:**
1. abrir configurações no celular
2. wifi > (i) ao lado do wifi conectado
3. anotar "endereço ip"

**ou via computador:**
```bash
nmap -sn 192.168.1.0/24
```

### executar análise

```bash
# definir ip do celular
CELULAR="192.168.1.105"

# varredura completa
nmap -sV -sC $CELULAR -oN scan_completo.txt

# varredura de vulnerabilidades
nmap --script vuln $CELULAR -oN scan_vuln.txt
```

### documentar

- preencher relatorio.md com resultados
- criar tabelas de serviços
- identificar vulnerabilidades
- analisar impacto

---

## perguntas frequentes

### posso usar meu celular como alvo?

**sim**, desde que você seja o proprietário e tenha autorização.

### é seguro fazer isso?

**sim**, se for em rede doméstica e você for o proprietário do dispositivo.

### vou encontrar muitas vulnerabilidades?

**provavelmente não**, celulares modernos são mais seguros. isso é um resultado válido - documente que o dispositivo está bem protegido.

### o que fazer se não encontrar vulnerabilidades?

**documente isso!** explique que o dispositivo está bem configurado, com poucas portas abertas e serviços atualizados. isso também é um resultado válido.

### posso usar outro dispositivo como alvo?

**sim**, você pode usar:
- outro celular
- tablet
- smart tv
- roteador
- impressora de rede
- qualquer dispositivo na sua rede doméstica (com autorização)

---

**boa análise!**

