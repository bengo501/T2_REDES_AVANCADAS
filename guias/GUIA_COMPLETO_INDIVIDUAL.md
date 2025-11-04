# guia completo para realizar o trabalho individualmente

este guia fornece um passo a passo completo e detalhado para você realizar o trabalho sozinho, do início ao fim.

## índice

1. [preparação inicial](#preparação-inicial)
2. [escolha dos alvos](#escolha-dos-alvos)
3. [etapa 1: obtenção de informações (alvo 1)](#etapa-1-obtenção-de-informações-alvo-1)
4. [etapa 2: mapeamento e vulnerabilidades (alvo 1)](#etapa-2-mapeamento-e-vulnerabilidades-alvo-1)
5. [etapa 1: obtenção de informações (alvo 2)](#etapa-1-obtenção-de-informações-alvo-2)
6. [etapa 2: mapeamento e vulnerabilidades (alvo 2)](#etapa-2-mapeamento-e-vulnerabilidades-alvo-2)
7. [etapa 3: análise de impacto e correções](#etapa-3-análise-de-impacto-e-correções)
8. [preenchimento do relatório](#preenchimento-do-relatório)
9. [preparação para apresentação](#preparação-para-apresentação)

---

## preparação inicial

### passo 1: instalar ferramentas necessárias

**opção 1: kali linux (recomendado - mais fácil)**

1. baixar virtualbox: https://www.virtualbox.org/
2. instalar virtualbox
3. baixar kali linux: https://www.kali.org/get-kali/ (escolher virtualbox 64-bit)
4. importar kali linux no virtualbox
5. iniciar kali linux (usuário: `kali`, senha: `kali`)
6. verificar ferramentas:
   ```bash
   nmap --version
   nikto --version
   whois --version
   ```

**opção 2: wsl + ubuntu (windows)**

1. abrir powershell como administrador
2. executar: `wsl --install`
3. reiniciar computador
4. instalar ubuntu da microsoft store
5. abrir ubuntu e executar:
   ```bash
   sudo apt update
   sudo apt install nmap nikto whois dnsutils curl -y
   ```

### passo 2: configurar diretório de trabalho

```bash
# navegar até o diretório do trabalho
cd "F:/Game Projects/Godot 4/T2_REDES_AVANCADAS"

# criar diretórios para resultados
mkdir -p resultados/alvo1
mkdir -p resultados/alvo2

# tornar scripts executáveis (se no linux)
chmod +x scripts/*.sh
```

### passo 3: verificar instalação

```bash
# verificar se ferramentas estão instaladas
./scripts/verificar_instalacao.sh

# ou manualmente:
nmap --version
nikto --version
whois --version
```

---

## escolha dos alvos

### sugestão de alvos para trabalho individual

**você precisa de 2 alvos. sugestões:**

#### alvo 1: seu celular (recomendado)

**vantagens:**
- você é o proprietário
- fácil de configurar
- sempre disponível
- aprendizado prático

**como descobrir ip:**
1. no celular: configurações → wifi → (i) ao lado do wifi → endereço ip
2. ou via computador:
   ```bash
   nmap -sn 192.168.1.0/24
   # ou ajuste para seu range de rede (ex: 192.168.0.0/24)
   ```

#### alvo 2: roteador wifi (recomendado)

**vantagens:**
- você é o proprietário
- geralmente tem várias portas abertas
- bom para análise de rede
- aprendizado prático

**como descobrir ip:**
- geralmente é o gateway padrão:
  ```bash
  # no windows
  ipconfig
  # procurar por "gateway padrão" (geralmente 192.168.1.1 ou 192.168.0.1)
  
  # no linux
  ip route | grep default
  ```

**alternativas para alvo 2:**
- smart tv (se tiver)
- impressora de rede (se tiver)
- servidor doméstico (se tiver)
- dispositivo iot (se tiver)
- outro celular/tablet

### passo 1: descobrir dispositivos na rede

```bash
# descobrir ip do computador
ip route get 8.8.8.8 | awk '{print $7; exit}'
# ou no windows: ipconfig

# descobrir range da rede (ajustar conforme necessário)
# exemplo: se seu ip é 192.168.1.100, range é 192.168.1.0/24

# descobrir todos os dispositivos na rede
nmap -sn 192.168.1.0/24
# ou ajuste para seu range (ex: 192.168.0.0/24)

# salvar resultado
nmap -sn 192.168.1.0/24 > dispositivos_rede.txt
```

**anotar:**
- alvo 1: [ip do celular] (exemplo: 192.168.1.105)
- alvo 2: [ip do roteador] (exemplo: 192.168.1.1)

---

## etapa 1: obtenção de informações (alvo 1)

### passo 1: criar diretório para alvo 1

```bash
mkdir -p resultados/alvo1/etapa1
cd resultados/alvo1/etapa1
```

### passo 2: definir ip do alvo 1

```bash
# substituir pelo ip real do seu celular
ALVO1="192.168.1.105"
```

### passo 3: executar coleta de informações

```bash
# ping para confirmar conectividade
ping -c 4 $ALVO1 > ping.txt

# dns reverso (se houver)
dig -x $ALVO1 > dns_reverso.txt

# nslookup
nslookup $ALVO1 > nslookup.txt

# anotar informações do dispositivo:
# - modelo do celular
# - versão do android/ios
# - fabricante
# - ip do celular
```

### passo 4: documentar resultados

**anotar no caderno ou arquivo:**
- ip do alvo 1: [ip]
- modelo: [modelo do celular]
- sistema operacional: [android/ios e versão]
- fabricante: [samsung, apple, etc.]

---

## etapa 2: mapeamento e vulnerabilidades (alvo 1)

### passo 1: criar diretório para varreduras

```bash
cd ../../
mkdir -p resultados/alvo1/etapa2
cd resultados/alvo1/etapa2
```

### passo 2: definir ip do alvo 1

```bash
ALVO1="192.168.1.105"  # substituir pelo ip real
```

### passo 3: executar varreduras

#### varredura rápida

```bash
nmap -F $ALVO1 -oN scan_rapido.txt
```

#### varredura completa (pode demorar)

```bash
# varredura completa com detecção de versões
nmap -sV -sC $ALVO1 -oN scan_completo.txt -oX scan_completo.xml

# tempo estimado: 2-5 minutos
```

#### detecção de sistema operacional (requer root)

```bash
# executar com sudo
sudo nmap -O $ALVO1 -oN scan_os.txt
```

#### varredura udp (requer root)

```bash
# executar com sudo
sudo nmap -sU --top-ports 100 $ALVO1 -oN scan_udp.txt
```

#### varredura de vulnerabilidades

```bash
nmap --script vuln $ALVO1 -oN scan_vuln.txt
```

### passo 4: testar serviços web (se houver)

```bash
# verificar se há porta 80/443 aberta
grep "80\|443" scan_completo.txt

# se houver, testar:
nikto -h http://$ALVO1 -output nikto_resultado.txt
curl -I http://$ALVO1 > headers.txt
curl -v http://$ALVO1 >> headers.txt

# testar porta específica (ex: 8080)
# se encontrar porta diferente, ajustar:
curl -I http://$ALVO1:8080
nikto -h http://$ALVO1:8080 -output nikto_8080.txt
```

### passo 5: analisar resultados

```bash
# ver portas abertas
grep "open" scan_completo.txt

# ver serviços detectados
grep "Service\|Version" scan_completo.txt

# criar tabela de serviços
# usar o formato:
# | porta | protocolo | serviço | versão | estado |
```

### passo 6: pesquisar vulnerabilidades

**para cada serviço/versão encontrada:**

1. anotar serviço e versão (ex: apache 2.4.41)
2. pesquisar em bases de dados:
   - cve database: https://cve.mitre.org/
   - nvd: https://nvd.nist.gov/
   - buscar: "[serviço] [versão] vulnerabilities"
3. anotar cves encontrados (se houver)

---

## etapa 1: obtenção de informações (alvo 2)

### passo 1: criar diretório para alvo 2

```bash
cd ../../..
mkdir -p resultados/alvo2/etapa1
cd resultados/alvo2/etapa1
```

### passo 2: definir ip do alvo 2

```bash
# substituir pelo ip real do roteador
ALVO2="192.168.1.1"  # ou 192.168.0.1 (depende da sua rede)
```

### passo 3: executar coleta de informações

```bash
# ping para confirmar conectividade
ping -c 4 $ALVO2 > ping.txt

# dns reverso
dig -x $ALVO2 > dns_reverso.txt

# nslookup
nslookup $ALVO2 > nslookup.txt

# anotar informações do dispositivo:
# - modelo do roteador
# - fabricante
# - ip do roteador
```

### passo 4: documentar resultados

**anotar:**
- ip do alvo 2: [ip]
- modelo: [modelo do roteador]
- fabricante: [tp-link, d-link, etc.]

---

## etapa 2: mapeamento e vulnerabilidades (alvo 2)

### passo 1: criar diretório para varreduras

```bash
cd ../../
mkdir -p resultados/alvo2/etapa2
cd resultados/alvo2/etapa2
```

### passo 2: definir ip do alvo 2

```bash
ALVO2="192.168.1.1"  # substituir pelo ip real
```

### passo 3: executar varreduras

#### varredura rápida

```bash
nmap -F $ALVO2 -oN scan_rapido.txt
```

#### varredura completa

```bash
nmap -sV -sC $ALVO2 -oN scan_completo.txt -oX scan_completo.xml
```

#### detecção de sistema operacional (requer root)

```bash
sudo nmap -O $ALVO2 -oN scan_os.txt
```

#### varredura udp (requer root)

```bash
sudo nmap -sU --top-ports 100 $ALVO2 -oN scan_udp.txt
```

#### varredura de vulnerabilidades

```bash
nmap --script vuln $ALVO2 -oN scan_vuln.txt
```

### passo 4: testar serviços web (roteadores geralmente têm)

```bash
# roteadores geralmente têm interface web na porta 80
nikto -h http://$ALVO2 -output nikto_resultado.txt
curl -I http://$ALVO2 > headers.txt
curl -v http://$ALVO2 >> headers.txt

# testar porta 443 (https) se houver
curl -I -k https://$ALVO2 > headers_https.txt
```

### passo 5: analisar resultados

```bash
# ver portas abertas
grep "open" scan_completo.txt

# ver serviços detectados
grep "Service\|Version" scan_completo.txt

# criar tabela de serviços
```

### passo 6: pesquisar vulnerabilidades

**para cada serviço/versão encontrada:**
- pesquisar em bases de dados cve
- anotar cves encontrados (se houver)

---

## etapa 3: análise de impacto e correções

### passo 1: compilar todas as vulnerabilidades encontradas

**criar lista de vulnerabilidades:**

```bash
# criar arquivo de resumo
cat > ../../../vulnerabilidades_encontradas.txt << EOF
=== vulnerabilidades encontradas ===

alvo 1: [ip do celular]
[listar vulnerabilidades encontradas]

alvo 2: [ip do roteador]
[listar vulnerabilidades encontradas]
EOF
```

### passo 2: analisar impacto de cada vulnerabilidade

**para cada vulnerabilidade encontrada, analisar:**

1. **o que um atacante poderia fazer?**
   - ex: "executar código remotamente"
   - ex: "obter acesso não autorizado"
   - ex: "causar negação de serviço"

2. **qual a complexidade do ataque?**
   - fácil: qualquer pessoa pode explorar
   - médio: requer conhecimento técnico
   - difícil: requer conhecimento avançado

3. **qual o impacto?**
   - crítico: acesso total ao sistema
   - alto: acesso a informações sensíveis
   - médio: divulgação de informações
   - baixo: impacto limitado

### passo 3: pesquisar correções e mitigações

**para cada vulnerabilidade:**

1. **pesquisar correção oficial:**
   - atualização de versão disponível?
   - patch específico disponível?
   - trabalho ao redor (workaround)?

2. **propor correção:**
   - atualizar para versão segura
   - aplicar patch
   - reconfigurar serviço

3. **propor mitigação temporária:**
   - desabilitar serviço (se não necessário)
   - bloquear acesso via firewall
   - usar controle de acesso

### passo 4: classificar severidade

**para cada vulnerabilidade, classificar:**

- **crítica:** permite execução remota de código, acesso total
- **alta:** permite acesso não autorizado, elevação de privilégios
- **média:** divulgação de informações, negação de serviço
- **baixa:** informações limitadas, impacto mínimo

**usar cvss se disponível:**
- 9.0-10.0: crítica
- 7.0-8.9: alta
- 4.0-6.9: média
- 0.0-3.9: baixa

---

## preenchimento do relatório

### passo 1: abrir template do relatório

```bash
# abrir relatorio.md no editor
# ou visualizar:
cat relatorio.md
```

### passo 2: preencher seção 1 - introdução

**alvos escolhidos:**

```markdown
#### alvo 1: [nome do dispositivo]
- **nome/identificação:** [modelo do celular]
- **endereço ip:** [ip do celular]
- **tipo:** dispositivo móvel
- **sistema operacional:** [android/ios e versão]
- **fabricante:** [samsung, apple, etc.]

#### alvo 2: [nome do dispositivo]
- **nome/identificação:** [modelo do roteador]
- **endereço ip:** [ip do roteador]
- **tipo:** roteador de rede
- **fabricante:** [tp-link, d-link, etc.]
```

**escopo do teste:**

```markdown
**dentro do escopo:**
- análise de portas abertas
- identificação de serviços expostos
- detecção de vulnerabilidades conhecidas
- análise de superfície de ataque

**fora do escopo:**
- exploração de vulnerabilidades
- acesso não autorizado
- modificação de configurações
```

**justificativa da escolha:**

```markdown
- alvo 1: dispositivo pessoal, fácil acesso, ambiente controlado
- alvo 2: dispositivo de rede, vários serviços expostos, relevante para aprendizado
```

### passo 3: preencher seção 2 - etapa 1

**para cada alvo:**

```markdown
### alvo 1: [nome]

**ferramentas utilizadas:**
- ping: confirmação de conectividade
- dig: dns reverso
- nslookup: resolução de nomes

**resultados:**
- ip do alvo: [ip]
- conectividade: confirmada (ping bem-sucedido)
- informações coletadas: [anotar]
```

### passo 4: preencher seção 3 - etapa 2

**para cada alvo:**

```markdown
### alvo 1: [nome]

**ferramentas utilizadas:**
- nmap: varredura de portas e detecção de versões
- nikto: scanner de vulnerabilidades web
- curl: análise de headers http

**serviços em execução:**

| porta | protocolo | serviço | versão | estado |
|-------|-----------|---------|--------|--------|
| [porta] | tcp/udp | [serviço] | [versão] | aberta |

**sistema operacional detectado:**
- sistema: [os detectado]
- confiança: [nível]
- evidências: [como foi detectado]

**superfície de ataque identificada:**
- portas abertas: [lista]
- serviços expostos: [lista]
- possíveis vetores de ataque: [lista]

**vulnerabilidades detectadas:**

| # | serviço/sistema | descrição da falha | severidade | cvss | cve |
|---|----------------|-------------------|------------|------|-----|
| 1 | [serviço] | [descrição] | [alta/média/baixa] | [pontuação] | [cve-id] |
```

### passo 5: preencher seção 4 - etapa 3

**para cada vulnerabilidade encontrada:**

```markdown
#### vulnerabilidade 1: [nome/título]

**descrição:**
[descrição detalhada da vulnerabilidade]

**análise do impacto:**
[explicar o que um atacante poderia fazer se explorasse essa falha]

**proposta de correção/mitigação:**
[descrever soluções recomendadas]

**prioridade:** [alta/média/baixa]
```

### passo 6: preencher seção 5 - conclusão

```markdown
### resumo geral dos achados

- número total de vulnerabilidades encontradas: [número]
- vulnerabilidades críticas: [número]
- vulnerabilidades altas: [número]
- vulnerabilidades médias: [número]
- vulnerabilidades baixas: [número]

### recomendações gerais

- [listar recomendações principais]

### importância das correções propostas

[explicar a importância de implementar as correções]
```

### passo 7: adicionar anexos

**incluir nos anexos:**
- screenshots de ferramentas
- logs completos das ferramentas
- comandos executados (documentar em `exemplo_comandos.md`)

---

## sequência completa de comandos

### script completo para alvo 1

```bash
#!/bin/bash
# script completo para análise do alvo 1

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
if grep -q "80\|443" scan_completo.txt; then
    nikto -h http://$ALVO1 -output nikto_resultado.txt 2>&1
    curl -I http://$ALVO1 > headers.txt 2>&1
fi

echo "análise do alvo 1 concluída!"
echo "resultados salvos em: resultados/alvo1/"
```

### script completo para alvo 2

```bash
#!/bin/bash
# script completo para análise do alvo 2

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

echo "análise do alvo 2 concluída!"
echo "resultados salvos em: resultados/alvo2/"
```

---

## cronograma sugerido

### semana 1: preparação e alvo 1

**dia 1-2: preparação**
- instalar kali linux ou ferramentas
- configurar ambiente
- descobrir dispositivos na rede
- escolher alvos

**dia 3-4: alvo 1 - etapa 1 e 2**
- executar etapa 1 (obtenção de informações)
- executar etapa 2 (mapeamento e vulnerabilidades)
- analisar resultados

### semana 2: alvo 2 e análise

**dia 1-2: alvo 2 - etapa 1 e 2**
- executar etapa 1 (obtenção de informações)
- executar etapa 2 (mapeamento e vulnerabilidades)
- analisar resultados

**dia 3-4: etapa 3**
- analisar impacto de vulnerabilidades
- pesquisar correções e mitigações
- classificar severidade

### semana 3: relatório e apresentação

**dia 1-3: relatório**
- preencher todas as seções
- adicionar anexos
- revisar e corrigir

**dia 4: apresentação**
- preparar slides
- ensaiar apresentação
- revisar conteúdo

---

## checklist final

### antes de começar

- [ ] ferramentas instaladas (nmap, nikto, whois, dig, curl)
- [ ] ambiente configurado (kali linux ou wsl)
- [ ] diretórios criados
- [ ] autorização obtida (se necessário)

### alvo 1

- [ ] ip do alvo 1 identificado
- [ ] etapa 1 completa (obtenção de informações)
- [ ] etapa 2 completa (mapeamento e vulnerabilidades)
- [ ] resultados analisados
- [ ] vulnerabilidades pesquisadas

### alvo 2

- [ ] ip do alvo 2 identificado
- [ ] etapa 1 completa (obtenção de informações)
- [ ] etapa 2 completa (mapeamento e vulnerabilidades)
- [ ] resultados analisados
- [ ] vulnerabilidades pesquisadas

### etapa 3

- [ ] todas as vulnerabilidades analisadas
- [ ] impacto de cada vulnerabilidade descrito
- [ ] correções propostas para cada vulnerabilidade
- [ ] severidade classificada

### relatório

- [ ] introdução completa
- [ ] etapa 1 documentada (ambos os alvos)
- [ ] etapa 2 documentada (ambos os alvos)
- [ ] etapa 3 documentada (todas as vulnerabilidades)
- [ ] conclusão completa
- [ ] anexos organizados
- [ ] revisão final

### apresentação

- [ ] slides preparados
- [ ] apresentação ensaiada
- [ ] tempo estimado verificado
- [ ] conteúdo revisado

---

## dicas importantes

### 1. documente tudo enquanto trabalha

- não deixe para documentar depois
- anote comandos executados
- salve todos os outputs
- tire screenshots importantes

### 2. seja organizado

- crie diretórios separados para cada alvo
- nomeie arquivos de forma clara
- mantenha estrutura organizada

### 3. não se preocupe se não encontrar muitas vulnerabilidades

- isso é um resultado válido
- dispositivos modernos são mais seguros
- documente que o dispositivo está bem protegido

### 4. use múltiplas ferramentas

- não dependa só de uma ferramenta
- valide resultados manualmente
- use diferentes abordagens

### 5. seja ético

- teste apenas dispositivos próprios
- obtenha autorização antes de testar
- não cause danos intencionais

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

**boa sorte com o trabalho!**

