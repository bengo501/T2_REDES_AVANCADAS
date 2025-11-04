# passo a passo para preencher o relatório - etapas 1, 2 e 3

guia detalhado para executar as etapas 1, 2 e 3 e preencher o relatório automaticamente.

## índice

1. [preparação inicial](#preparação-inicial)
2. [etapa 1: obtenção de informações](#etapa-1-obtenção-de-informações)
3. [etapa 2: mapeamento e vulnerabilidades](#etapa-2-mapeamento-e-vulnerabilidades)
4. [etapa 3: análise de impacto](#etapa-3-análise-de-impacto)
5. [preenchimento automático do relatório](#preenchimento-automático-do-relatório)

---

## preparação inicial

### passo 1: definir os alvos

**anotar informações dos alvos:**

```bash
# alvo 1 (exemplo: celular)
ALVO1_IP="192.168.1.105"
ALVO1_NOME="celular android"
ALVO1_MODELO="samsung galaxy s21"
ALVO1_SO="android 13"

# alvo 2 (exemplo: roteador)
ALVO2_IP="192.168.1.1"
ALVO2_NOME="roteador wifi"
ALVO2_MODELO="tp-link archer c6"
ALVO2_SO="linux (firmware customizado)"
```

### passo 2: executar scripts de análise

```bash
# tornar scripts executáveis
chmod +x scripts/preencher_etapa1.sh
chmod +x scripts/preencher_etapa2.sh
chmod +x scripts/preencher_etapa3.sh
chmod +x scripts/preencher_relatorio_completo.sh

# executar análise completa
./scripts/preencher_relatorio_completo.sh $ALVO1_IP $ALVO2_IP
```

---

## etapa 1: obtenção de informações

### passo 1: executar coleta de informações

**para cada alvo:**

```bash
# alvo 1
cd resultados/alvo1/etapa1
ping -c 4 $ALVO1_IP > ping.txt
dig -x $ALVO1_IP > dns_reverso.txt 2>&1
nslookup $ALVO1_IP > nslookup.txt 2>&1

# alvo 2
cd ../../alvo2/etapa1
ping -c 4 $ALVO2_IP > ping.txt
dig -x $ALVO2_IP > dns_reverso.txt 2>&1
nslookup $ALVO2_IP > nslookup.txt 2>&1
```

**ou usar script:**

```bash
./scripts/preencher_etapa1.sh $ALVO1_IP $ALVO2_IP
```

### passo 2: analisar resultados

**para cada alvo, verificar:**

```bash
# alvo 1
cat resultados/alvo1/etapa1/ping.txt
cat resultados/alvo1/etapa1/dns_reverso.txt
cat resultados/alvo1/etapa1/nslookup.txt

# alvo 2
cat resultados/alvo2/etapa1/ping.txt
cat resultados/alvo2/etapa1/dns_reverso.txt
cat resultados/alvo2/etapa1/nslookup.txt
```

### passo 3: preencher seção 2 do relatório

**abrir `relatorio.md` e preencher:**

**seção 2.1 - métodos e ferramentas:**

```markdown
### 2.1 métodos e ferramentas utilizadas

**ferramentas:**
- **ping:** confirmação de conectividade e latência
- **dig:** consultas dns reverso (ptr records)
- **nslookup:** resolução de nomes e informações dns

**técnicas:**
- **varredura de conectividade:** ping para confirmar que o alvo está ativo
- **dns reverso:** tentativa de identificar hostname do alvo
- **resolução de nomes:** obtenção de informações dns básicas
```

**seção 2.2 - resultados:**

**para alvo 1:**
```markdown
#### alvo 1

**ping:**
```
[inserir conteúdo de resultados/alvo1/etapa1/ping.txt]
```

**dns reverso:**
```
[inserir conteúdo de resultados/alvo1/etapa1/dns_reverso.txt]
```

**nslookup:**
```
[inserir conteúdo de resultados/alvo1/etapa1/nslookup.txt]
```

**análise:**
- ip do alvo: [ip]
- conectividade: confirmada (ping bem-sucedido)
- latência: [valor] ms
- hostname: [se encontrado, ou "não identificado"]
```

**para alvo 2:**
```markdown
#### alvo 2

[mesmo formato do alvo 1]
```

---

## etapa 2: mapeamento e vulnerabilidades

### passo 1: executar varreduras

**para cada alvo:**

```bash
# alvo 1
cd resultados/alvo1/etapa2
nmap -F $ALVO1_IP -oN scan_rapido.txt
nmap -sV -sC $ALVO1_IP -oN scan_completo.txt -oX scan_completo.xml
sudo nmap -O $ALVO1_IP -oN scan_os.txt 2>/dev/null
sudo nmap -sU --top-ports 100 $ALVO1_IP -oN scan_udp.txt 2>/dev/null
nmap --script vuln $ALVO1_IP -oN scan_vuln.txt

# se houver serviço web
if grep -q "80\|443\|8080" scan_completo.txt; then
    nikto -h http://$ALVO1_IP -output nikto_resultado.txt 2>&1
    curl -I http://$ALVO1_IP > headers.txt 2>&1
fi

# alvo 2
cd ../../alvo2/etapa2
nmap -F $ALVO2_IP -oN scan_rapido.txt
nmap -sV -sC $ALVO2_IP -oN scan_completo.txt -oX scan_completo.xml
sudo nmap -O $ALVO2_IP -oN scan_os.txt 2>/dev/null
sudo nmap -sU --top-ports 100 $ALVO2_IP -oN scan_udp.txt 2>/dev/null
nmap --script vuln $ALVO2_IP -oN scan_vuln.txt

# roteadores geralmente têm serviço web
nikto -h http://$ALVO2_IP -output nikto_resultado.txt 2>&1
curl -I http://$ALVO2_IP > headers.txt 2>&1
curl -I -k https://$ALVO2_IP > headers_https.txt 2>&1
```

**ou usar script:**

```bash
./scripts/preencher_etapa2.sh $ALVO1_IP $ALVO2_IP
```

### passo 2: analisar resultados

**extrair informações de cada alvo:**

```bash
# alvo 1 - portas abertas
grep "open" resultados/alvo1/etapa2/scan_completo.txt

# alvo 1 - serviços detectados
grep "Service\|Version" resultados/alvo1/etapa2/scan_completo.txt

# alvo 1 - sistema operacional
cat resultados/alvo1/etapa2/scan_os.txt | grep -i "os\|running"

# alvo 1 - vulnerabilidades
grep -i "vulnerable\|risk\|cve" resultados/alvo1/etapa2/scan_vuln.txt

# alvo 2 (mesmo processo)
grep "open" resultados/alvo2/etapa2/scan_completo.txt
# ... etc
```

### passo 3: criar tabelas de serviços

**para cada alvo, criar tabela:**

**exemplo para alvo 1:**

```markdown
| porta | protocolo | serviço | versão | estado |
|-------|-----------|---------|--------|--------|
| 8200 | tcp | trivnet1 | não identificada | aberta |
```

**como extrair informações:**

```bash
# extrair informações de portas abertas
grep "open" scan_completo.txt | awk '{print $1, $2, $3, $4, "aberta"}'
```

### passo 4: identificar sistema operacional

**verificar resultados:**

```bash
# alvo 1
cat resultados/alvo1/etapa2/scan_os.txt | grep -i "os details\|running\|os cpe"

# alvo 2
cat resultados/alvo2/etapa2/scan_os.txt | grep -i "os details\|running\|os cpe"
```

**preencher no relatório:**

```markdown
**sistemas operacionais detectados:**

- sistema: [nome e versão]
- confiança: [nível de confiança]
- evidências: [como foi detectado]
```

### passo 5: identificar superfície de ataque

**analisar portas abertas:**

```markdown
**superfície de ataque identificada:**

- portas abertas: [lista de portas]
- serviços expostos: [lista de serviços]
- possíveis vetores de ataque:
  - [porta] - [serviço] - [risco potencial]
  - [porta] - [serviço] - [risco potencial]
```

### passo 6: criar tabela de vulnerabilidades

**pesquisar vulnerabilidades para cada serviço:**

1. **anotar serviço e versão** (ex: apache 2.4.41)
2. **pesquisar em bases de dados:**
   - cve database: https://cve.mitre.org/
   - nvd: https://nvd.nist.gov/
   - buscar: "[serviço] [versão] vulnerabilities"
3. **anotar cves encontrados**

**preencher tabela:**

```markdown
| # | serviço/sistema afetado | descrição da falha | severidade | cvss | referência (cve) |
|---|------------------------|-------------------|------------|------|------------------|
| 1 | [serviço] | [descrição] | [alta/média/baixa] | [pontuação] | [cve-id] |
```

**se não encontrar vulnerabilidades:**

```markdown
**vulnerabilidades detectadas:**

nenhuma vulnerabilidade conhecida foi detectada nos scans realizados. 
o dispositivo parece estar atualizado e relativamente seguro.
```

### passo 7: preencher seção 3 do relatório

**seção 3.1 - tipos de varreduras:**

```markdown
### 3.1 tipos de varreduras e ferramentas utilizadas

**varredura de portas:**
- ferramenta: nmap
- técnica: varredura tcp (syn scan) e udp (top 100 portas)
- varredura rápida (-F): 100 portas mais comuns
- varredura completa (-sV -sC): todas as 1000 portas padrão com detecção de versões

**identificação de serviços:**
- ferramenta: nmap (-sV)
- detecção automática de versões de serviços

**detecção de versões:**
- ferramenta: nmap service detection
- análise de banners e respostas de serviços

**detecção de sistema operacional:**
- ferramenta: nmap (-O)
- requer privilégios root

**varredura de vulnerabilidades:**
- ferramenta: nmap (--script vuln)
- scripts de vulnerabilidade do nmap
- ferramenta: nikto (para serviços web)
- scanner de vulnerabilidades web

**análise de headers http:**
- ferramenta: curl
- análise de headers e respostas http
```

**seção 3.2 - resultados:**

```markdown
### 3.2 resultados e descobertas

#### alvo 1

**serviços em execução:**
[inserir tabela criada no passo 3]

**sistemas operacionais detectados:**
[inserir informações do passo 4]

**superfície de ataque identificada:**
[inserir análise do passo 5]

**vulnerabilidades detectadas:**
[inserir tabela do passo 6]

#### alvo 2

[mesmo formato do alvo 1]
```

---

## etapa 3: análise de impacto

### passo 1: compilar todas as vulnerabilidades encontradas

**criar lista:**

```bash
# criar arquivo com todas as vulnerabilidades
cat > vulnerabilidades_encontradas.txt << EOF
=== vulnerabilidades encontradas ===

alvo 1: [ip]
[listar vulnerabilidades do alvo 1]

alvo 2: [ip]
[listar vulnerabilidades do alvo 2]
EOF
```

### passo 2: analisar impacto de cada vulnerabilidade

**para cada vulnerabilidade, analisar:**

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
   - workaround disponível?

2. **propor correção:**
   - atualizar para versão segura
   - aplicar patch
   - reconfigurar serviço

3. **propor mitigação temporária:**
   - desabilitar serviço (se não necessário)
   - bloquear acesso via firewall
   - usar controle de acesso

### passo 4: classificar severidade

**para cada vulnerabilidade:**

- **crítica:** permite execução remota de código, acesso total
- **alta:** permite acesso não autorizado, elevação de privilégios
- **média:** divulgação de informações, negação de serviço
- **baixa:** informações limitadas, impacto mínimo

**usar cvss se disponível:**
- 9.0-10.0: crítica
- 7.0-8.9: alta
- 4.0-6.9: média
- 0.0-3.9: baixa

### passo 5: preencher seção 4 do relatório

**para cada vulnerabilidade encontrada:**

```markdown
#### vulnerabilidade 1: [nome/título]

**descrição:**
[descrição detalhada da vulnerabilidade]
- serviço afetado: [nome do serviço]
- versão afetada: [versão]
- cve: [cve-id]
- cvss: [pontuação]

**análise do impacto:**
[explicar o que um atacante poderia fazer se explorasse essa falha]
- cenário de ataque: [descrever passo a passo]
- complexidade: [fácil/médio/difícil]
- impacto no sistema: [crítico/alto/médio/baixo]
- consequências: [listar possíveis consequências]

**proposta de correção/mitigação:**

**correção recomendada:**
- atualizar [serviço] para versão [versão segura]
- aplicar patch [nome do patch]
- reconfigurar [serviço] conforme [especificações]

**mitigação temporária:**
- desabilitar [serviço] se não estiver em uso
- bloquear acesso via firewall na porta [porta]
- implementar controle de acesso

**prioridade:** [alta/média/baixa]
```

**se não encontrar vulnerabilidades:**

```markdown
### 4.1 vulnerabilidades do alvo 1

**nenhuma vulnerabilidade conhecida foi detectada.**

**análise:**
o dispositivo parece estar relativamente seguro, com:
- poucas portas abertas
- serviços atualizados
- configuração adequada de firewall

**recomendações:**
- manter atualizações regulares
- monitorar logs de segurança
- manter configurações de firewall ativas
```

---

## preenchimento automático do relatório

### passo 1: executar script completo

```bash
# tornar script executável
chmod +x scripts/preencher_relatorio_completo.sh

# executar análise completa e preencher relatório
./scripts/preencher_relatorio_completo.sh $ALVO1_IP $ALVO2_IP
```

**o script vai:**
1. executar etapa 1 (obtenção de informações)
2. executar etapa 2 (mapeamento e vulnerabilidades)
3. analisar resultados
4. gerar relatório parcial preenchido

### passo 2: revisar e completar relatório

**o script gera um relatório parcial. você precisa:**

1. **revisar informações geradas**
2. **completar seções que requerem análise manual:**
   - análise de impacto (etapa 3)
   - propostas de correção (requer pesquisa)
   - conclusão (requer reflexão)

3. **adicionar informações adicionais:**
   - screenshots
   - logs completos
   - comandos executados

### passo 3: finalizar relatório

**verificar:**
- [ ] todas as seções preenchidas
- [ ] tabelas formatadas corretamente
- [ ] informações consistentes
- [ ] ortografia e formatação corretas
- [ ] anexos incluídos

---

## checklist final

### etapa 1

- [ ] coleta de informações executada (ambos os alvos)
- [ ] resultados analisados
- [ ] seção 2.1 preenchida (métodos e ferramentas)
- [ ] seção 2.2 preenchida (resultados)

### etapa 2

- [ ] varreduras executadas (ambos os alvos)
- [ ] serviços identificados
- [ ] sistema operacional detectado
- [ ] superfície de ataque identificada
- [ ] vulnerabilidades pesquisadas
- [ ] seção 3.1 preenchida (tipos de varreduras)
- [ ] seção 3.2 preenchida (resultados e descobertas)

### etapa 3

- [ ] todas as vulnerabilidades analisadas
- [ ] impacto de cada vulnerabilidade descrito
- [ ] correções propostas
- [ ] mitigações propostas
- [ ] severidade classificada
- [ ] seção 4 preenchida (análise de impacto)

### relatório completo

- [ ] introdução completa
- [ ] etapa 1 completa
- [ ] etapa 2 completa
- [ ] etapa 3 completa
- [ ] conclusão completa
- [ ] anexos incluídos
- [ ] revisão final realizada

---

## comandos rápidos de referência

### executar todas as etapas

```bash
# definir alvos
ALVO1_IP="192.168.1.105"
ALVO2_IP="192.168.1.1"

# executar análise completa
./scripts/preencher_relatorio_completo.sh $ALVO1_IP $ALVO2_IP
```

### analisar resultados

```bash
# portas abertas
grep "open" resultados/alvo1/etapa2/scan_completo.txt
grep "open" resultados/alvo2/etapa2/scan_completo.txt

# serviços detectados
grep "Service\|Version" resultados/alvo1/etapa2/scan_completo.txt
grep "Service\|Version" resultados/alvo2/etapa2/scan_completo.txt

# vulnerabilidades
grep -i "vulnerable\|risk\|cve" resultados/alvo1/etapa2/scan_vuln.txt
grep -i "vulnerable\|risk\|cve" resultados/alvo2/etapa2/scan_vuln.txt
```

---

**boa sorte com o preenchimento do relatório!**

