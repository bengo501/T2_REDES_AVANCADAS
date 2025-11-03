# passo a passo detalhado - análise de vulnerabilidades

este documento fornece um guia completo e detalhado de como executar o trabalho de análise de vulnerabilidades conforme o enunciado.

## índice

1. [visão geral](#visão-geral)
2. [preparação do ambiente](#preparação-do-ambiente)
3. [etapa 1: obtenção de informações](#etapa-1-obtenção-de-informações)
4. [etapa 2: mapeamento da rede e identificação de vulnerabilidades](#etapa-2-mapeamento-da-rede-e-identificação-de-vulnerabilidades)
5. [etapa 3: documentação e análise de impacto](#etapa-3-documentação-e-análise-de-impacto)
6. [elaboração do relatório](#elaboração-do-relatório)
7. [preparação para apresentação](#preparação-para-apresentação)

---

## visão geral

### objetivo do trabalho

realizar análise de vulnerabilidades em **dois alvos reais**, identificando falhas de segurança, classificando riscos e propondo soluções.

### requisitos

- **grupo:** até 4 componentes
- **alvos:** dois equipamentos (rede doméstica ou laboratório sala 301)
- **entrega:** relatório completo + apresentação (11/11)
- **obrigatório:** todos do grupo presentes na apresentação

### estrutura do trabalho

1. **escolha dos alvos** (antes de começar)
2. **etapa 1:** obtenção de informações
3. **etapa 2:** mapeamento e identificação de vulnerabilidades
4. **etapa 3:** análise de impacto e propostas de correção
5. **documentação:** relatório completo
6. **apresentação:** explicação da abordagem e resultados

---

## preparação do ambiente

### passo 1: obter autorização

⚠️ **crítico:** antes de qualquer varredura, você deve:

1. **para rede doméstica:**
   - obter autorização do proprietário/administrador
   - confirmar que os equipamentos podem ser testados
   - informar que testes de segurança serão realizados

2. **para laboratório sala 301:**
   - obter autorização do professor/coordenador
   - verificar regras específicas do laboratório
   - confirmar horários permitidos para testes

3. **documentar a autorização:**
   - anotar data, hora e quem autorizou
   - manter registro para apresentação

### passo 2: escolher os alvos

escolha dois alvos para análise:

**sugestões de alvos:**

1. **opção 1 - rede doméstica:**
   - roteador wifi pessoal
   - servidor doméstico (se tiver)
   - iot devices (smart tv, câmeras, etc.)
   - impressora de rede

2. **opção 2 - laboratório:**
   - servidores do laboratório sala 301
   - equipamentos de rede disponíveis
   - dispositivos autorizados pelo professor

**critérios para escolha:**
- acessibilidade (você tem autorização e acesso?)
- relevância (permite aplicar técnicas aprendidas?)
- segurança (não causará problemas operacionais?)
- aprendizado (ensina conceitos importantes?)

**anote informações básicas:**
- nome/identificação do alvo
- endereço ip (se conhecido)
- domínio (se aplicável)
- tipo de equipamento/serviço

### passo 3: preparar ambiente de trabalho

**opção a: usar kali linux (recomendado)**

kali linux já vem com todas as ferramentas instaladas:

1. **instalar kali linux:**
   - baixar imagem de: https://www.kali.org/
   - instalar em máquina virtual (virtualbox/vmware)
   - ou instalar como dual boot (cuidado!)
   - ou usar live usb (bootável)

2. **verificar ferramentas:**
   ```bash
   nmap --version
   nikto --version
   whois --version
   ```

**opção b: instalar ferramentas em ubuntu/debian**

se preferir usar ubuntu ou outra distribuição:

```bash
# atualizar sistema
sudo apt update && sudo apt upgrade -y

# instalar ferramentas principais
sudo apt install -y nmap nikto whois dnsutils curl

# instalar ferramentas adicionais
sudo apt install -y wireshark tcpdump metasploit-framework

# instalar via python pip (se necessário)
pip install dnsrecon theharvester
```

**opção c: usar windows subsystem for linux (wsl)**

para windows:

1. instalar wsl e ubuntu
2. seguir opção b acima

### passo 4: configurar estrutura do projeto

1. **navegar até o diretório do projeto:**
   ```bash
   cd "F:/Game Projects/Godot 4/T2_REDES_AVANCADAS"
   ```

2. **criar diretório para resultados:**
   ```bash
   mkdir -p resultados
   ```

3. **tornar scripts executáveis (se no linux):**
   ```bash
   chmod +x scripts/*.sh
   ```

4. **abrir o template do relatório:**
   - abrir `relatorio.md` no editor de texto
   - começar a preencher com informações dos alvos escolhidos

---

## etapa 1: obtenção de informações

**objetivo:** coletar informações básicas sobre os alvos usando ferramentas públicas.

### passo 1.1: identificar informações do alvo

**para cada alvo, anote:**

- endereço ip (se conhecido)
- domínio (se aplicável)
- tipo de equipamento (roteador, servidor, etc.)
- localização (rede doméstica / laboratório)

### passo 1.2: executar coleta de informações

**método manual (recomendado para aprendizado):**

#### alvo 1: exemplo.com (ou ip 192.168.1.1)

```bash
# 1. consulta whois (informações de registro)
whois exemplo.com
# ou para ip:
whois 192.168.1.1

# 2. consultas dns
# registro a (endereço)
dig exemplo.com
dig exemplo.com +short

# registro mx (mail exchange)
dig exemplo.com mx
dig exemplo.com mx +short

# registro ns (name servers)
dig exemplo.com ns
dig exemplo.com ns +short

# registro txt (text records)
dig exemplo.com txt
dig exemplo.com txt +short

# 3. consulta alternativa com nslookup
nslookup exemplo.com

# 4. dns reverso (se for ip)
dig -x 192.168.1.1
```

**método automatizado (usando script):**

```bash
# usar o script fornecido
./scripts/coleta_informacoes.sh exemplo.com
# ou para ip:
./scripts/coleta_informacoes.sh 192.168.1.1
```

**resultados salvos em:** `resultados/<alvo>/`

### passo 1.3: documentar resultados da etapa 1

**para cada alvo, documente:**

1. **informações encontradas:**
   - registrante/organização (whois)
   - servidores dns
   - registros mx, ns, txt
   - endereços ip associados

2. **onde documentar:**
   - abrir `relatorio.md`
   - preencher seção **2. etapa 1 - obtenção de informações**
   - copiar outputs relevantes (não tudo, apenas o importante)
   - explicar o que cada ferramenta revelou

3. **ferramentas utilizadas:**
   - listar: whois, dig, nslookup
   - explicar propósito de cada uma
   - justificar escolha das ferramentas

### passo 1.4: repetir para alvo 2

executar os mesmos passos para o segundo alvo escolhido.

---

## etapa 2: mapeamento da rede e identificação de vulnerabilidades

**objetivo:** identificar serviços expostos, sistemas operacionais e vulnerabilidades.

### passo 2.1: varredura de portas

**esta é a etapa mais importante!**

#### para cada alvo:

**varredura básica com nmap:**

```bash
# varredura rápida de portas comuns
nmap -F 192.168.1.1

# varredura completa com detecção de versões
nmap -sV -sC 192.168.1.1

# salvar resultados
nmap -sV -sC 192.168.1.1 -oN resultados/alvo1_nmap.txt
```

**varredura completa (pode demorar):**

```bash
# todas as portas (tcp)
nmap -p- 192.168.1.1 -oN resultados/alvo1_allports.txt

# detecção de sistema operacional
nmap -O 192.168.1.1 -oN resultados/alvo1_os.txt
```

**varredura udp:**

```bash
# portas udp mais comuns
nmap -sU --top-ports 100 192.168.1.1 -oN resultados/alvo1_udp.txt
```

**método automatizado:**

```bash
./scripts/varredura_nmap.sh 192.168.1.1
```

### passo 2.2: identificar serviços em execução

**analisar resultados do nmap:**

1. **portas abertas:**
   - listar todas as portas encontradas
   - identificar protocolo (tcp/udp)
   - identificar serviço em execução

2. **versões de serviços:**
   - anotar versões detectadas (ex: apache 2.4.41)
   - verificar se são versões antigas/vulneráveis

3. **sistema operacional:**
   - anotar os detectado (ex: linux 3.x)
   - nível de confiança da detecção

**criar tabela de serviços:**

| porta | protocolo | serviço | versão | estado |
|-------|-----------|---------|--------|--------|
| 22 | tcp | ssh | openssh 7.4 | aberta |
| 80 | tcp | http | apache 2.4.41 | aberta |
| 443 | tcp | https | apache 2.4.41 | aberta |

### passo 2.3: varredura de vulnerabilidades

**se o alvo tiver serviços web (portas 80, 443, 8080, etc.):**

```bash
# nikto - scanner de vulnerabilidades web
nikto -h http://192.168.1.1 -output resultados/alvo1_nikto.txt

# whatweb - identificação de tecnologias web
whatweb http://192.168.1.1 -v > resultados/alvo1_whatweb.txt

# análise de headers http
curl -I http://192.168.1.1 > resultados/alvo1_headers.txt
curl -v http://192.168.1.1 >> resultados/alvo1_headers.txt
```

**método automatizado:**

```bash
./scripts/varredura_web.sh http://192.168.1.1
```

**para outros serviços específicos:**

- **serviços smb/samba:** `enum4linux -a 192.168.1.1`
- **serviços snmp:** `snmpwalk -v2c -c public 192.168.1.1`
- **serviços ftp:** `nmap --script ftp-anon 192.168.1.1`

### passo 2.4: pesquisar vulnerabilidades conhecidas

**para cada serviço/versão encontrada:**

1. **pesquisar em bases de dados:**
   - **cve database:** https://cve.mitre.org/
   - **nvd:** https://nvd.nist.gov/
   - **exploit-db:** https://www.exploit-db.com/

2. **usar ferramentas automáticas:**
   ```bash
   # nmap com scripts de vulnerabilidade
   nmap --script vuln 192.168.1.1
   
   # metasploit (se disponível)
   msfconsole
   use auxiliary/scanner/discovery/udp_sweep
   ```

3. **verificar versões vulneráveis:**
   - comparar versão detectada com versões conhecidas vulneráveis
   - procurar cves específicos para a versão

### passo 2.5: documentar vulnerabilidades encontradas

**criar tabela de vulnerabilidades:**

| # | serviço/sistema | descrição da falha | severidade | cvss | cve |
|---|----------------|-------------------|------------|------|-----|
| 1 | apache 2.4.41 | versão vulnerável a cve-2021-xxxxx | alta | 7.5 | cve-2021-xxxxx |
| 2 | ssh openssh 7.4 | versão antiga, múltiplas vulnerabilidades | média | 5.3 | cve-2020-xxxxx |

**classificar severidade:**
- **crítica:** permite execução remota de código, acesso total
- **alta:** permite acesso não autorizado, elevação de privilégios
- **média:** divulgação de informações, negação de serviço
- **baixa:** informações limitadas, impacto mínimo

**preencher no relatório:**
- seção **3. etapa 2 - mapeamento da rede e identificação de serviços e vulnerabilidades**
- incluir todas as tabelas criadas
- explicar como cada vulnerabilidade foi detectada

### passo 2.6: identificar superfície de ataque

**superfície de ataque = pontos de entrada potenciais**

liste:
- portas abertas expostas
- serviços com versões vulneráveis
- serviços configurados incorretamente
- informações sensíveis divulgadas (headers, banners, etc.)

---

## etapa 3: documentação, análise de impacto e propostas de correção

**objetivo:** analisar o impacto de cada vulnerabilidade e propor soluções.

### passo 3.1: analisar impacto de cada vulnerabilidade

**para cada vulnerabilidade encontrada, analisar:**

1. **o que um atacante poderia fazer?**
   - ex: "um atacante poderia executar código remotamente e obter acesso total ao sistema"
   - ex: "um atacante poderia obter credenciais e acessar informações sensíveis"
   - ex: "um atacante poderia causar negação de serviço"

2. **cenários de ataque:**
   - descrever passo a passo como a vulnerabilidade poderia ser explorada
   - citar se existem exploits públicos disponíveis
   - mencionar complexidade do ataque (fácil/médio/difícil)

3. **impacto no sistema:**
   - confidencialidade (informações expostas?)
   - integridade (dados podem ser modificados?)
   - disponibilidade (serviço pode ser interrompido?)

### passo 3.2: propor correções e mitigações

**para cada vulnerabilidade, propor:**

1. **correção recomendada:**
   - atualização para versão segura
   - patch específico
   - reconfiguração do serviço

2. **mitigações temporárias:**
   - workarounds até aplicar correção
   - medidas de segurança adicionais
   - controle de acesso

3. **prioridade:**
   - alta: corrigir imediatamente
   - média: corrigir em breve
   - baixa: corrigir quando possível

**exemplo de proposta:**

**vulnerabilidade:** apache 2.4.41 - cve-2021-xxxxx

**análise de impacto:**
um atacante remoto pode executar código arbitrário no servidor web, obtendo acesso total ao sistema e potencialmente comprometendo todos os dados e serviços.

**proposta de correção:**
- atualizar apache para versão 2.4.52 ou superior
- aplicar patch de segurança específico
- reconfigurar módulos desnecessários

**mitigação temporária:**
- limitar acesso ao serviço via firewall
- monitorar logs de acesso
- implementar waf (web application firewall)

**prioridade:** alta

### passo 3.3: documentar no relatório

**preencher seção 4 do relatório:**
- **4. etapa 3 - documentação, análise de impacto e propostas de correção/mitigação**
- criar uma seção para cada vulnerabilidade
- incluir análise de impacto detalhada
- incluir proposta de correção específica

---

## elaboração do relatório

### passo 4.1: preencher todas as seções

**estrutura completa do relatório:**

1. **introdução**
   - informações dos dois alvos escolhidos
   - escopo do teste (o que foi incluído/excluído)
   - justificativa da escolha

2. **etapa 1 - obtenção de informações**
   - ferramentas utilizadas
   - resultados para cada alvo
   - outputs relevantes (não tudo, só o importante)

3. **etapa 2 - mapeamento da rede**
   - tipos de varreduras realizadas
   - ferramentas utilizadas
   - resultados e descobertas:
     - serviços em execução (tabela)
     - sistemas operacionais detectados
     - superfície de ataque
     - vulnerabilidades detectadas (tabela completa)

4. **etapa 3 - análise de impacto**
   - para cada vulnerabilidade:
     - descrição detalhada
     - análise de impacto
     - proposta de correção/mitigação
     - prioridade

5. **conclusão**
   - resumo geral dos achados
   - número de vulnerabilidades encontradas
   - recomendações gerais
   - importância das correções

### passo 4.2: adicionar anexos

**incluir nos anexos:**
- screenshots de ferramentas (nmap, nikto, etc.)
- logs completos das ferramentas (outputs inteiros)
- comandos executados (documentar em `exemplo_comandos.md`)
- evidências relevantes

**organizar anexos:**
- anexo a: evidências e logs
- anexo b: comandos executados

### passo 4.3: revisar relatório

**verificar:**
- ✅ todos os campos preenchidos
- ✅ tabelas completas e formatadas
- ✅ análises detalhadas para cada vulnerabilidade
- ✅ propostas de correção específicas
- ✅ conclusão com resumo claro
- ✅ anexos organizados
- ✅ ortografia e formatação corretas

### passo 4.4: gerar resumo dos resultados

**usar script fornecido (se executou scripts):**
```bash
./scripts/gerar_relatorio_resumo.sh
```

ou criar manualmente um resumo:
- número total de vulnerabilidades encontradas
- vulnerabilidades críticas/altas
- principais descobertas
- recomendações principais

---

## preparação para apresentação

### passo 5.1: preparar slides

**conteúdo sugerido:**

1. **introdução (2-3 slides)**
   - alvos escolhidos
   - escopo do trabalho
   - justificativa

2. **metodologia (2-3 slides)**
   - ferramentas utilizadas
   - abordagem seguida
   - técnicas aplicadas

3. **resultados principais (5-7 slides)**
   - descobertas do alvo 1
   - descobertas do alvo 2
   - vulnerabilidades mais críticas
   - tabelas resumo

4. **análise e recomendações (2-3 slides)**
   - impacto das principais vulnerabilidades
   - propostas de correção
   - recomendações gerais

5. **conclusão (1 slide)**
   - resumo dos achados
   - lições aprendidas

### passo 5.2: preparar demonstração

**se possível e autorizado:**
- demonstrar uma ferramenta (nmap, nikto)
- mostrar exemplo de saída
- explicar como interpretar resultados

**se não for possível demonstrar ao vivo:**
- usar screenshots
- mostrar exemplos de outputs
- explicar o processo

### passo 5.3: distribuir responsabilidades

**todos devem participar:**
- dividir apresentação entre os membros
- cada um apresenta uma parte
- todos devem conhecer o trabalho completo

### passo 5.4: ensaiar apresentação

**praticar:**
- tempo estimado: 15-20 minutos
- mais 10-15 minutos para perguntas
- garantir que todos sabem sua parte

---

## checklist final

### antes de entregar:

- [ ] autorização obtida e documentada
- [ ] dois alvos escolhidos e documentados
- [ ] etapa 1 completa para ambos os alvos
- [ ] etapa 2 completa para ambos os alvos
- [ ] etapa 3 completa para todas as vulnerabilidades
- [ ] relatório completo e revisado
- [ ] anexos organizados
- [ ] slides preparados
- [ ] apresentação ensaiada
- [ ] todos do grupo prontos

### itens do relatório:

- [ ] introdução completa
- [ ] alvos e escopo definidos
- [ ] justificativa da escolha
- [ ] etapa 1 documentada com ferramentas e resultados
- [ ] etapa 2 documentada com:
  - [ ] serviços em execução (tabela)
  - [ ] sistemas operacionais detectados
  - [ ] superfície de ataque
  - [ ] vulnerabilidades detectadas (tabela completa)
- [ ] etapa 3 documentada com:
  - [ ] análise de impacto para cada vulnerabilidade
  - [ ] proposta de correção para cada vulnerabilidade
- [ ] conclusão com resumo e recomendações
- [ ] anexos com evidências

---

## cronograma sugerido

**semana 1:**
- escolher alvos e obter autorização
- preparar ambiente
- executar etapa 1 (ambos os alvos)

**semana 2:**
- executar etapa 2 (ambos os alvos)
- identificar e pesquisar vulnerabilidades

**semana 3:**
- executar etapa 3 (análise de impacto)
- elaborar relatório
- preparar apresentação

**semana 4:**
- revisar relatório
- ensaiar apresentação
- entrega final

---

## dicas importantes

### segurança e ética

1. **nunca teste sem autorização**
2. **não explore vulnerabilidades** (apenas identifique)
3. **use ambientes controlados**
4. **não cause danos** aos sistemas testados
5. **documente tudo** para apresentação

### qualidade do trabalho

1. **seja detalhado** nas análises
2. **cite referências** (cves, bases de dados)
3. **explique o processo** claramente
4. **seja crítico** na análise de impacto
5. **proponha soluções realistas**

### ferramentas

1. **use múltiplas ferramentas** para validar descobertas
2. **entenda o que cada ferramenta faz**
3. **não dependa só de uma ferramenta**
4. **valide resultados manualmente** quando possível

### documentação

1. **documente enquanto trabalha** (não deixe para depois)
2. **salve todos os outputs**
3. **tire screenshots** importantes
4. **anote comandos** executados
5. **explique decisões** tomadas

---

## perguntas frequentes

### preciso usar todos os scripts fornecidos?

não, os scripts são opcionais. você pode executar os comandos manualmente para aprender melhor.

### quantas vulnerabilidades preciso encontrar?

não há mínimo. o importante é fazer uma análise completa e documentar bem o que foi encontrado.

### posso usar apenas um alvo?

não, o enunciado pede explicitamente dois alvos.

### preciso explorar as vulnerabilidades?

não. apenas identifique e documente. não é necessário fazer proof-of-concept ou exploração.

### o que fazer se não encontrar vulnerabilidades?

documente isso. explique que o sistema está bem configurado ou que as versões estão atualizadas. isso também é um resultado válido.

---

## suporte e recursos

- **documentação do nmap:** https://nmap.org/docs.html
- **cve database:** https://cve.mitre.org/
- **nvd:** https://nvd.nist.gov/
- **guia de ferramentas:** consulte `guia_ferramentas.md`
- **scripts auxiliares:** consulte `scripts/README.md`

---

**boa sorte com o trabalho!**

