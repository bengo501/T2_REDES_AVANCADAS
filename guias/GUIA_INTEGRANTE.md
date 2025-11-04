# guia prático para integrante do grupo

este documento fornece instruções específicas para você como integrante do grupo realizar sua parte do trabalho.

## softwares que você deve instalar

### opção 1: kali linux (recomendado - mais fácil)

**o que é:** sistema operacional completo com todas as ferramentas já instaladas.

**como instalar:**

1. **baixar kali linux:**
   - site: https://www.kali.org/get-kali/
   - escolher: kali linux virtual machines (para máquina virtual)
   - ou: kali linux live (para usb bootável)

2. **instalar em máquina virtual (recomendado):**
   - instalar virtualbox: https://www.virtualbox.org/
   - criar nova máquina virtual
   - usar imagem do kali baixada
   - configurar: 2gb ram mínimo, 20gb disco
   - iniciar kali linux

3. **verificar ferramentas instaladas:**
   ```bash
   nmap --version
   nikto --version
   whois --version
   dig --version
   ```

**vantagens:**
- ✅ todas as ferramentas já instaladas
- ✅ não modifica seu windows
- ✅ ambiente completo e pronto
- ✅ mais fácil para iniciantes

### opção 2: instalar ferramentas no windows (via wsl)

**passo 1: instalar wsl (windows subsystem for linux)**

```powershell
# no powershell como administrador
wsl --install
# reiniciar o computador
```

**passo 2: instalar ubuntu**

1. abrir microsoft store
2. procurar "ubuntu"
3. instalar ubuntu
4. abrir ubuntu e configurar usuário

**passo 3: instalar ferramentas**

```bash
# no ubuntu (wsl)
sudo apt update
sudo apt upgrade -y
sudo apt install nmap nikto whois dnsutils curl -y
```

**passo 4: verificar instalação**

```bash
nmap --version
nikto --version
whois --version
```

**vantagens:**
- ✅ funciona no windows
- ✅ não precisa de máquina virtual separada
- ⚠️ requer instalação manual de cada ferramenta

### opção 3: instalar ferramentas individuais no windows (limitado)

**problema:** algumas ferramentas não têm versão nativa para windows ou são limitadas.

**recomendação:** usar opção 1 ou 2 acima.

---

## lista completa de softwares necessários

### softwares obrigatórios (você precisa ter)

| software | obrigatório | o que faz | onde obter |
|----------|-------------|-----------|------------|
| **nmap** | ✅ sim | varredura de portas e rede | https://nmap.org/ ou kali linux |
| **whois** | ✅ sim | informações de registro | apt install whois |
| **dig/nslookup** | ✅ sim | consultas dns | apt install dnsutils |
| **curl** | ✅ sim | requisições http | geralmente pré-instalado |

### softwares recomendados (muito úteis)

| software | recomendado | o que faz | onde obter |
|----------|-------------|-----------|------------|
| **nikto** | ✅ sim | scanner de vulnerabilidades web | kali linux ou apt install nikto |
| **metasploit** | opcional | framework de exploração | kali linux |
| **wireshark** | opcional | análise de tráfego | https://www.wireshark.org/ |
| **git** | opcional | controle de versão | https://git-scm.com/ |

### resumo: o que você realmente precisa

**mínimo:**
1. **kali linux** (recomendado) - já inclui tudo
   ou
2. **wsl + ubuntu + ferramentas** - instalação manual

**ferramentas individuais se não usar kali:**
- nmap
- nikto
- whois
- dnsutils (dig, nslookup)
- curl

---

## divisão de trabalho entre integrantes

### sugestão de divisão para grupo de 4 integrantes

#### integrante 1: responsável pela etapa 1 (obtenção de informações)
**tarefas:**
- escolher primeiro alvo
- obter autorização para análise
- executar coleta de informações (etapa 1) para alvo 1
- documentar resultados da etapa 1 para alvo 1
- preencher seção do relatório: etapa 1 - alvo 1

**ferramentas necessárias:**
- whois
- dig / nslookup
- dnsrecon (opcional)
- theharvester (opcional)

#### integrante 2: responsável pela etapa 2 - alvo 1 (mapeamento e vulnerabilidades)
**tarefas:**
- executar varreduras de rede (nmap) no alvo 1
- identificar serviços em execução no alvo 1
- executar varreduras de vulnerabilidades no alvo 1
- documentar vulnerabilidades encontradas no alvo 1
- preencher seção do relatório: etapa 2 - alvo 1

**ferramentas necessárias:**
- nmap (obrigatório)
- nikto (se houver serviços web)
- metasploit (opcional)

#### integrante 3: responsável pelo alvo 2 completo
**tarefas:**
- escolher segundo alvo
- obter autorização para análise
- executar etapa 1 (coleta de informações) para alvo 2
- executar etapa 2 (mapeamento e vulnerabilidades) para alvo 2
- documentar resultados para alvo 2
- preencher seções do relatório: etapa 1 e 2 - alvo 2

**ferramentas necessárias:**
- todas as ferramentas (whois, dig, nmap, nikto)

#### integrante 4: responsável pela etapa 3 (análise de impacto) e organização
**tarefas:**
- analisar impacto de todas as vulnerabilidades encontradas
- pesquisar cves e informações sobre vulnerabilidades
- propor correções e mitigações
- organizar relatório completo
- preparar apresentação
- preencher seção do relatório: etapa 3 (todas as vulnerabilidades) e conclusão

**ferramentas necessárias:**
- principalmente pesquisa (cve database, nvd)
- pode usar ferramentas para validar pesquisas

### observações importantes

- **todos devem participar da escolha dos alvos**
- **todos devem estar presentes na apresentação**
- **todos devem conhecer o trabalho completo**
- **todos devem revisar o relatório final**
- **a divisão acima é sugestão - ajuste conforme necessário**

---

## sua parte: passo a passo detalhado

### escolha sua responsabilidade

você pode escolher uma das partes acima. vou fornecer um passo a passo completo para você como **integrante responsável pela etapa 2 do alvo 1** (mapeamento e vulnerabilidades), que é uma das partes mais importantes.

**se você escolher outra parte, o processo será similar - apenas as ferramentas e comandos mudam.**

---

## passo a passo: etapa 2 - mapeamento e vulnerabilidades (alvo 1)

### passo 1: preparar ambiente

**1.1 instalar kali linux (se ainda não tiver)**

1. baixar kali linux de https://www.kali.org/get-kali/
2. instalar em máquina virtual (virtualbox)
3. iniciar kali linux

**1.2 verificar ferramentas instaladas**

```bash
# abrir terminal no kali linux
nmap --version
nikto --version
whois --version
```

**1.3 configurar diretório de trabalho**

```bash
# criar diretório para resultados
mkdir -p ~/trabalho_seguranca/resultados/alvo1

# navegar até diretório
cd ~/trabalho_seguranca/resultados/alvo1
```

**1.4 obter informações do alvo**

você precisa saber do alvo 1:
- endereço ip (exemplo: 192.168.1.1)
- ou domínio (exemplo: exemplo.com)
- informações básicas (fornecidas pelo integrante 1)

**⚠️ importante:** você deve ter autorização antes de iniciar qualquer varredura.

### passo 2: executar varreduras de rede (nmap)

**2.1 varredura rápida de portas comuns**

```bash
# substitua 192.168.1.1 pelo ip do alvo 1
nmap -F 192.168.1.1 -oN scan_rapido.txt
```

**explicação:**
- `-F`: varredura rápida (1000 portas mais comuns)
- `-oN scan_rapido.txt`: salva resultado em arquivo texto

**2.2 varredura completa com detecção de versões**

```bash
# esta varredura pode demorar alguns minutos
nmap -sV -sC 192.168.1.1 -oN scan_completo.txt -oX scan_completo.xml
```

**explicação:**
- `-sV`: detecta versões de serviços
- `-sC`: executa scripts padrão do nmap
- `-oN scan_completo.txt`: salva em formato texto
- `-oX scan_completo.xml`: salva em formato xml (para análises)

**2.3 detecção de sistema operacional**

```bash
nmap -O 192.168.1.1 -oN scan_os.txt
```

**explicação:**
- `-O`: detecta sistema operacional

**2.4 varredura de todas as portas tcp (pode demorar muito)**

```bash
# esta varredura pode demorar horas - use apenas se necessário
nmap -p- 192.168.1.1 -oN scan_allports.txt
```

**2.5 varredura udp (portas mais comuns)**

```bash
nmap -sU --top-ports 100 192.168.1.1 -oN scan_udp.txt
```

**explicação:**
- `-sU`: varredura udp
- `--top-ports 100`: 100 portas udp mais comuns

### passo 3: analisar resultados do nmap

**3.1 visualizar resultados**

```bash
# ver resultado da varredura completa
cat scan_completo.txt

# ou usar less para navegar
less scan_completo.txt
```

**3.2 identificar portas abertas**

procurar por linhas como:
```
PORT     STATE    SERVICE    VERSION
22/tcp   open     ssh        OpenSSH 7.4
80/tcp   open     http       Apache 2.4.41
443/tcp  open     ssl/http   Apache 2.4.41
```

**3.3 criar tabela de serviços**

você deve criar uma tabela com:
| porta | protocolo | serviço | versão | estado |
|-------|-----------|---------|--------|--------|
| 22 | tcp | ssh | openssh 7.4 | aberta |
| 80 | tcp | http | apache 2.4.41 | aberta |

**3.4 identificar sistema operacional detectado**

procurar por linhas como:
```
OS details: Linux 3.x - 4.x
```

### passo 4: executar varreduras de vulnerabilidades

**4.1 se houver serviços web (portas 80, 443, 8080, etc.):**

```bash
# substitua http://192.168.1.1 pela url do alvo
nikto -h http://192.168.1.1 -output nikto_resultado.txt
```

**explicação:**
- `-h http://192.168.1.1`: url do alvo
- `-output nikto_resultado.txt`: salva resultado

**4.2 análise de headers http**

```bash
# análise de headers
curl -I http://192.168.1.1 > headers.txt
curl -v http://192.168.1.1 >> headers.txt
```

**4.3 varredura de vulnerabilidades com nmap scripts**

```bash
nmap --script vuln 192.168.1.1 -oN scan_vuln.txt
```

**explicação:**
- `--script vuln`: executa scripts de vulnerabilidade do nmap

### passo 5: pesquisar vulnerabilidades conhecidas

**5.1 para cada serviço/versão encontrada:**

1. **anotar:** serviço e versão (exemplo: apache 2.4.41)
2. **pesquisar em bases de dados:**
   - cve database: https://cve.mitre.org/
   - nvd: https://nvd.nist.gov/
   - exploit-db: https://www.exploit-db.com/

**5.2 exemplo de pesquisa:**

- serviço: apache 2.4.41
- pesquisar: "apache 2.4.41 vulnerabilities"
- procurar cves relacionados
- verificar se a versão é vulnerável

**5.3 criar lista de vulnerabilidades**

| # | serviço/sistema | descrição da falha | severidade | cvss | cve |
|---|----------------|-------------------|------------|------|-----|
| 1 | apache 2.4.41 | versão vulnerável a cve-2021-xxxxx | alta | 7.5 | cve-2021-xxxxx |

### passo 6: documentar resultados

**6.1 criar resumo das descobertas**

```bash
# criar arquivo de resumo
cat > resumo_descobertas.txt << EOF
=== serviços em execução ===
[lista de serviços encontrados]

=== sistema operacional ===
[os detectado]

=== vulnerabilidades encontradas ===
[lista de vulnerabilidades]
EOF
```

**6.2 organizar arquivos**

```
resultados/alvo1/
├── scan_rapido.txt
├── scan_completo.txt
├── scan_os.txt
├── nikto_resultado.txt
├── headers.txt
├── scan_vuln.txt
└── resumo_descobertas.txt
```

**6.3 preencher seção do relatório**

abrir `relatorio.md` e preencher:
- seção 3.2 resultados e descobertas - alvo 1
- tabela de serviços em execução
- sistema operacional detectado
- superfície de ataque identificada
- tabela de vulnerabilidades detectadas

---

## sequência completa de comandos (copiar e colar)

### configuração inicial (executar uma vez)

```bash
# criar diretório de trabalho
mkdir -p ~/trabalho_seguranca/resultados/alvo1
cd ~/trabalho_seguranca/resultados/alvo1

# verificar ferramentas
nmap --version
nikto --version
```

### comandos para executar (substituir ip do alvo)

```bash
# definir ip do alvo (substitua pelo ip real)
ALVO="192.168.1.1"

# etapa 1: varredura rápida
echo "=== varredura rápida ==="
nmap -F $ALVO -oN scan_rapido.txt

# etapa 2: varredura completa (pode demorar)
echo "=== varredura completa ==="
nmap -sV -sC $ALVO -oN scan_completo.txt -oX scan_completo.xml

# etapa 3: detecção de os
echo "=== detecção de os ==="
nmap -O $ALVO -oN scan_os.txt

# etapa 4: varredura udp
echo "=== varredura udp ==="
nmap -sU --top-ports 100 $ALVO -oN scan_udp.txt

# etapa 5: se houver serviço web
echo "=== varredura web ==="
nikto -h http://$ALVO -output nikto_resultado.txt

# etapa 6: headers http
echo "=== análise de headers ==="
curl -I http://$ALVO > headers.txt
curl -v http://$ALVO >> headers.txt

# etapa 7: varredura de vulnerabilidades
echo "=== varredura de vulnerabilidades ==="
nmap --script vuln $ALVO -oN scan_vuln.txt

# exibir resumo
echo "=== resumo ==="
echo "arquivos criados:"
ls -lh *.txt *.xml 2>/dev/null
```

### comandos para analisar resultados

```bash
# ver portas abertas
grep "open" scan_completo.txt

# ver serviços detectados
grep "Service" scan_completo.txt

# ver os detectado
grep -i "os" scan_os.txt

# ver vulnerabilidades do nikto
grep -i "vulnerable\|risk" nikto_resultado.txt

# contar portas abertas
grep -c "open" scan_completo.txt
```

---

## se você escolher outra parte do trabalho

### se você for responsável pela etapa 1 (obtenção de informações)

**comandos principais:**

```bash
# definir alvo
ALVO="exemplo.com"  # ou ip

# criar diretório
mkdir -p ~/trabalho_seguranca/resultados/alvo1/etapa1
cd ~/trabalho_seguranca/resultados/alvo1/etapa1

# whois
whois $ALVO > whois.txt

# dns lookups
dig $ALVO > dns_a.txt
dig $ALVO mx > dns_mx.txt
dig $ALVO ns > dns_ns.txt
dig $ALVO txt > dns_txt.txt

# nslookup
nslookup $ALVO > nslookup.txt

# exibir resultados
cat whois.txt
cat dns_a.txt
```

**documentar:** seção 2 do relatório (etapa 1).

### se você for responsável pela etapa 3 (análise de impacto)

**tarefas principais:**

1. **receber lista de vulnerabilidades** dos outros integrantes
2. **pesquisar cada vulnerabilidade:**
   - cve database: https://cve.mitre.org/
   - nvd: https://nvd.nist.gov/
   - buscar: "cve-xxxx-xxxxx"
3. **analisar impacto:**
   - o que um atacante poderia fazer?
   - qual o risco?
   - qual a complexidade do ataque?
4. **propor correções:**
   - atualização de versão
   - patch específico
   - mitigação temporária
5. **documentar:** seção 4 do relatório (etapa 3).

**comandos úteis (para validar pesquisas):**

```bash
# pesquisar versão de serviço específica
# usar navegador para:
# https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=apache+2.4.41
# https://nvd.nist.gov/vuln/search?query=apache+2.4.41
```

---

## checklist para você

### antes de começar

- [ ] escolhi minha parte do trabalho
- [ ] instalei kali linux ou ferramentas necessárias
- [ ] verifiquei se ferramentas estão funcionando
- [ ] obtive autorização para análise
- [ ] tenho informações do alvo (ip ou domínio)
- [ ] criei diretório de trabalho

### durante execução

- [ ] executei varreduras básicas
- [ ] executei varreduras completas
- [ ] analisei resultados
- [ ] identifiquei serviços em execução
- [ ] identifiquei vulnerabilidades
- [ ] pesquisei vulnerabilidades em bases de dados
- [ ] criei tabelas de serviços
- [ ] criei tabela de vulnerabilidades

### documentação

- [ ] salvei todos os resultados
- [ ] organizei arquivos
- [ ] preenchi seção do relatório
- [ ] incluí tabelas formatadas
- [ ] expliquei métodos utilizados
- [ ] anotei comandos executados

### antes de entregar

- [ ] revisei minha parte do relatório
- [ ] verifiquei se está completo
- [ ] conferi tabelas e informações
- [ ] compartilhei com o grupo
- [ ] preparei apresentação da minha parte

---

## dicas importantes

### segurança e ética

1. **nunca teste sem autorização**
2. **não explore vulnerabilidades** (apenas identifique)
3. **use ambientes controlados**
4. **não cause danos** aos sistemas
5. **documente tudo** para apresentação

### qualidade do trabalho

1. **seja detalhado** nas análises
2. **cite referências** (cves, bases de dados)
3. **explique o processo** claramente
4. **use múltiplas ferramentas** para validar
5. **valide resultados manualmente** quando possível

### trabalho em equipe

1. **comunique-se** com o grupo regularmente
2. **compartilhe resultados** conforme obtém
3. **ajude outros integrantes** se necessário
4. **revise trabalho de outros** antes de finalizar
5. **coordenem apresentação** juntos

---

## suporte e recursos

### documentação

- **nmap:** https://nmap.org/docs.html
- **nikto:** https://cirt.net/nikto2-docs/
- **kali linux:** https://www.kali.org/docs/

### bases de dados

- **cve database:** https://cve.mitre.org/
- **nvd:** https://nvd.nist.gov/
- **exploit-db:** https://www.exploit-db.com/

### ajuda

- **fóruns de segurança:** stack overflow, reddit
- **documentação online:** tutoriais youtube
- **comunidade:** grupos de estudo

---

## resumo rápido

**softwares a instalar:**
1. **kali linux** (recomendado - tudo incluído)
   ou
2. **wsl + ubuntu + ferramentas** (nmap, nikto, whois, dig, curl)

**sua parte (exemplo - etapa 2):**
1. preparar ambiente (kali linux)
2. executar varreduras nmap
3. executar varreduras de vulnerabilidades
4. analisar resultados
5. pesquisar vulnerabilidades conhecidas
6. documentar no relatório

**comandos principais:**
- `nmap -sV -sC IP` - varredura completa
- `nikto -h http://IP` - scanner web
- `nmap --script vuln IP` - vulnerabilidades

**boa sorte com seu trabalho!**


