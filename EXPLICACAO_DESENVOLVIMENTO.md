# explicação do desenvolvimento da solução

este documento explica como a solução foi desenvolvida, a estrutura criada e informações sobre o uso de programas externos.

## como a solução foi desenvolvida

### análise do enunciado

primeiro, analisei o enunciado do trabalho para entender os requisitos:

1. **objetivo principal:** análise de vulnerabilidades em dois alvos reais
2. **três etapas principais:**
   - etapa 1: obtenção de informações
   - etapa 2: mapeamento da rede e identificação de vulnerabilidades
   - etapa 3: análise de impacto e propostas de correção
3. **entregável:** relatório técnico completo
4. **apresentação:** explicar abordagem e resultados (11/11)

### estrutura da solução

a solução foi desenvolvida para fornecer:

1. **template de relatório completo** (`relatorio.md`)
   - estrutura seguindo exatamente o que foi pedido
   - seções organizadas conforme o enunciado
   - tabelas formatadas para vulnerabilidades
   - espaço para anexos

2. **guia de ferramentas** (`guia_ferramentas.md`)
   - ferramentas recomendadas por etapa
   - comandos básicos de uso
   - explicações sobre cada ferramenta
   - boas práticas

3. **scripts auxiliares** (pasta `scripts/`)
   - scripts bash para automatizar tarefas comuns
   - facilitar a execução das análises
   - padronizar saída de resultados
   - economizar tempo na documentação

4. **passo a passo detalhado** (`PASSO_A_PASSO.md`)
   - guia completo de execução
   - instruções passo a passo
   - exemplos práticos
   - checklist para acompanhamento

5. **documentação de apoio**
   - `README.md`: visão geral do projeto
   - `exemplo_comandos.md`: template para documentar comandos
   - este documento: explicação do desenvolvimento

### design das soluções

#### template do relatório

o relatório foi estruturado para:
- **seguir exatamente** a estrutura do enunciado
- **facilitar preenchimento** com espaços claros
- **organizar informações** em tabelas formatadas
- **permitir anexos** para evidências

**decisões de design:**
- uso de markdown para fácil formatação
- tabelas em formato padrão para vulnerabilidades
- seções separadas para cada alvo
- anexos organizados

#### scripts bash

os scripts foram criados para:
- **automatizar tarefas repetitivas**
- **padronizar formato de saída**
- **salvar resultados organizadamente**
- **facilitar execução** para iniciantes

**decisões de design:**
- scripts modulares (um por função principal)
- salvamento automático com timestamp
- criação automática de diretórios
- mensagens informativas durante execução

**scripts criados:**
1. `coleta_informacoes.sh`: etapa 1 - informações básicas
2. `varredura_nmap.sh`: etapa 2 - varreduras de rede
3. `varredura_web.sh`: etapa 2 - vulnerabilidades web
4. `gerar_relatorio_resumo.sh`: consolidação de resultados

#### guia de ferramentas

o guia foi organizado para:
- **listar ferramentas por etapa**
- **explicar propósito de cada ferramenta**
- **fornecer comandos básicos**
- **mencionar alternativas**

**decisões de design:**
- agrupamento por tipo de análise
- comandos com exemplos práticos
- menção de alternativas disponíveis
- boas práticas incluídas

### metodologia de desenvolvimento

1. **análise dos requisitos**
   - leitura detalhada do enunciado
   - identificação de todos os itens necessários
   - mapeamento das três etapas principais

2. **estruturação do conteúdo**
   - criação da estrutura do relatório
   - definição de templates e guias
   - planejamento dos scripts

3. **desenvolvimento iterativo**
   - criação de cada componente
   - revisão de completude
   - verificação de alinhamento com enunciado

4. **organização e documentação**
   - criação de README e guias
   - documentação de uso
   - explicações detalhadas

---

## programas externos necessários

### sim, você precisará usar programas externos

o trabalho requer o uso de ferramentas especializadas em análise de segurança, que não são programas desenvolvidos por mim, mas ferramentas padrão da indústria.

### ferramentas obrigatórias recomendadas

#### para etapa 1 - obtenção de informações

**whois**
- **o que é:** ferramenta para consultar informações de registro
- **onde obter:** geralmente pré-instalado em linux, disponível via apt/yum
- **instalação:**
  ```bash
  sudo apt install whois  # debian/ubuntu
  ```
- **alternativas:** ferramentas web (whois.net, domaintools.com)

**dig / dnsutils**
- **o que é:** ferramentas para consultas dns
- **onde obter:** geralmente pré-instalado em linux
- **instalação:**
  ```bash
  sudo apt install dnsutils  # debian/ubuntu
  ```
- **alternativas:** nslookup (geralmente incluído)

#### para etapa 2 - mapeamento e vulnerabilidades

**nmap** (obrigatório - mais importante)
- **o que é:** ferramenta de varredura de rede e descoberta de portas
- **onde obter:** https://nmap.org/download.html
- **instalação:**
  ```bash
  sudo apt install nmap  # debian/ubuntu/kali
  ```
- **por que é essencial:** ferramenta padrão da indústria, mais usada para varreduras de rede
- **alternativas:** masscan (mais rápida, menos detalhada)

**nikto** (recomendado para serviços web)
- **o que é:** scanner de vulnerabilidades web
- **onde obter:** geralmente incluído em kali linux
- **instalação:**
  ```bash
  sudo apt install nikto  # debian/ubuntu/kali
  ```
- **alternativas:** zap proxy, burp suite

**curl** (recomendado)
- **o que é:** ferramenta para fazer requisições http
- **onde obter:** geralmente pré-instalado
- **instalação:**
  ```bash
  sudo apt install curl  # se não estiver instalado
  ```

### opções de ambiente completo

#### opção 1: kali linux (recomendado)

**o que é:** distribuição linux especializada em segurança e testes de penetração

**vantagens:**
- todas as ferramentas já instaladas
- ambiente completo e pronto
- amplamente usado na indústria

**onde obter:** https://www.kali.org/get-kali/

**opções de instalação:**
1. máquina virtual (virtualbox/vmware) - recomendado para iniciantes
2. live usb (bootável) - não modifica seu sistema
3. dual boot (instalação real) - cuidado, modifica seu disco

**como usar:**
1. baixar imagem iso do site
2. criar máquina virtual ou live usb
3. iniciar kali linux
4. todas as ferramentas já estarão disponíveis

#### opção 2: ubuntu/debian com ferramentas instaladas

**o que é:** distribuição linux padrão com ferramentas instaladas manualmente

**vantagens:**
- mais controle sobre o ambiente
- instala apenas o necessário
- familiar para quem já usa linux

**instalação das ferramentas:**
```bash
sudo apt update
sudo apt install nmap nikto whois dnsutils curl wireshark
```

**alternativa:** usar via windows subsystem for linux (wsl)

#### opção 3: docker containers

**o que é:** usar ferramentas em containers docker isolados

**vantagens:**
- isolamento do sistema
- fácil de limpar depois
- não modifica sistema principal

**exemplo:**
```bash
docker run -it kalilinux/kali-linux-docker
```

### ferramentas opcionais (mas úteis)

**metasploit framework**
- **o que é:** framework de exploração
- **onde obter:** geralmente incluído em kali
- **uso:** exploração e validação de vulnerabilidades (apenas com autorização)

**wireshark / tshark**
- **o que é:** análise de tráfego de rede
- **onde obter:** https://www.wireshark.org/
- **uso:** análise detalhada de pacotes

**theharvester**
- **o que é:** coleta de informações (emails, subdomínios)
- **onde obter:** geralmente incluído em kali ou via pip
- **uso:** etapa 1 - coleta de informações

**dnsrecon**
- **o que é:** enumeração dns
- **onde obter:** geralmente incluído em kali ou via pip
- **uso:** etapa 1 - enumeração dns

**gobuster / dirb**
- **o que é:** descobrimento de diretórios web
- **onde obter:** geralmente incluído em kali
- **uso:** etapa 2 - se encontrar serviços web

### onde obter as ferramentas

#### distribuições linux com ferramentas pré-instaladas

1. **kali linux** (recomendado)
   - site: https://www.kali.org/
   - todas as ferramentas incluídas
   - download: https://www.kali.org/get-kali/

2. **parrot security os**
   - site: https://parrotsec.org/
   - alternativa ao kali
   - ferramentas similares

3. **blackarch**
   - site: https://blackarch.org/
   - baseado em arch linux
   - muitas ferramentas especializadas

#### instalação individual (ubuntu/debian)

```bash
# atualizar sistema
sudo apt update

# instalar ferramentas principais
sudo apt install nmap nikto whois dnsutils curl

# instalar ferramentas adicionais
sudo apt install wireshark tcpdump metasploit-framework

# instalar via pip (python)
pip install dnsrecon theharvester
```

#### instalação no windows

**opção 1: windows subsystem for linux (wsl)**
1. instalar wsl: https://learn.microsoft.com/pt-br/windows/wsl/install
2. instalar ubuntu via microsoft store
3. dentro do wsl, instalar ferramentas como em ubuntu acima

**opção 2: git bash (limitado)**
- algumas ferramentas podem funcionar
- não recomendado para trabalho completo

**opção 3: máquina virtual linux**
- instalar kali linux ou ubuntu em vm
- usar como ambiente completo

### custos

**todas as ferramentas mencionadas são gratuitas e open source.**

- nmap: gratuito (gpl)
- nikto: gratuito (gpl)
- kali linux: gratuito
- whois, dig: geralmente gratuitos (parte do sistema)

**não é necessário comprar nenhuma ferramenta.**

### quais programas você realmente precisa?

#### mínimo necessário:
1. **nmap** (obrigatório)
2. **whois** (obrigatório)
3. **dig ou nslookup** (obrigatório)

#### recomendado:
4. **nikto** (se encontrar serviços web)
5. **curl** (útil para análise web)

#### ambiente completo:
- **kali linux** (inclui tudo)

### resumo

**sim, você precisa usar programas externos**, mas:
- ✅ todas as ferramentas são **gratuitas**
- ✅ todas são **padrão da indústria**
- ✅ **kali linux** já vem com tudo instalado
- ✅ não é necessário **desenvolver nenhuma ferramenta**
- ✅ scripts fornecidos **facilitam o uso** das ferramentas

**o que os scripts fazem:**
- automatizam comandos das ferramentas
- organizam resultados automaticamente
- economizam tempo na documentação
- **mas ainda precisam das ferramentas instaladas**

**recomendação:**
- instale **kali linux** em máquina virtual
- ou instale ferramentas individuais no seu sistema
- use os scripts fornecidos para facilitar a execução

---

## arquivos da solução e suas funções

### documentos principais

**relatorio.md**
- template completo do relatório
- estrutura conforme enunciado
- tabelas formatadas
- espaço para preenchimento

**guia_ferramentas.md**
- lista de ferramentas por etapa
- comandos básicos
- explicações de uso
- boas práticas

**PASSO_A_PASSO.md**
- guia detalhado de execução
- instruções passo a passo
- exemplos práticos
- checklist completo

**README.md**
- visão geral do projeto
- estrutura do trabalho
- links para outros documentos

**EXPLICACAO_DESENVOLVIMENTO.md** (este arquivo)
- explicação da solução
- informações sobre programas externos
- decisões de design

### scripts auxiliares

**scripts/coleta_informacoes.sh**
- automatiza etapa 1
- executa whois, dig, nslookup
- salva resultados organizados

**scripts/varredura_nmap.sh**
- automatiza varreduras nmap
- múltiplos tipos de varredura
- salva resultados com timestamp

**scripts/varredura_web.sh**
- automatiza varreduras web
- nikto, whatweb, curl
- descobrimento de diretórios

**scripts/gerar_relatorio_resumo.sh**
- consolida resultados
- facilita preenchimento do relatório
- gera resumo das descobertas

**scripts/README.md**
- instruções de uso dos scripts
- exemplos práticos
- notas importantes

### outros arquivos

**exemplo_comandos.md**
- template para documentar comandos
- espaço para anexos do relatório

**.gitignore**
- ignora arquivos de resultados
- mantém repositório limpo

**enunciado.txt**
- documento original do trabalho

---

## como usar esta solução

### passo 1: entender a estrutura
- ler este documento
- ler PASSO_A_PASSO.md
- familiarizar-se com os arquivos

### passo 2: preparar ambiente
- instalar kali linux ou ferramentas individuais
- verificar se ferramentas estão funcionando

### passo 3: executar análise
- seguir PASSO_A_PASPO.md
- usar scripts ou comandos manuais
- documentar resultados

### passo 4: preencher relatório
- usar relatorio.md como base
- preencher com resultados obtidos
- incluir evidências nos anexos

### passo 5: revisar e apresentar
- revisar relatório completo
- preparar apresentação
- ensaiar explicação

---

## diferenças entre usar scripts vs comandos manuais

### usando scripts (mais fácil)

**vantagens:**
- ✅ mais rápido
- ✅ menos erros
- ✅ resultados organizados automaticamente
- ✅ padronização

**desvantagens:**
- ❌ menos aprendizado sobre comandos
- ❌ menos controle fino
- ❌ depende das ferramentas instaladas

**quando usar:**
- quando quiser economizar tempo
- quando já conhecer as ferramentas
- para tarefas repetitivas

### usando comandos manuais (mais aprendizado)

**vantagens:**
- ✅ aprende cada comando individualmente
- ✅ mais controle sobre parâmetros
- ✅ entende melhor o que cada ferramenta faz
- ✅ mais conhecimento prático

**desvantagens:**
- ❌ mais demorado
- ❌ mais propenso a erros
- ❌ precisa organizar resultados manualmente

**quando usar:**
- para aprender melhor as ferramentas
- quando quiser controle total
- para apresentação (mostrar conhecimento)

**recomendação:** usar ambos - comandos manuais para aprender, scripts para acelerar depois.

---

## suporte e recursos

### documentação oficial

- **nmap:** https://nmap.org/docs.html
- **kali linux:** https://www.kali.org/docs/
- **nikto:** https://cirt.net/nikto2-docs/

### bases de dados de vulnerabilidades

- **cve database:** https://cve.mitre.org/
- **nvd:** https://nvd.nist.gov/
- **exploit-db:** https://www.exploit-db.com/

### comunidade

- fóruns de segurança
- documentação online
- tutoriais youtube

---

## conclusão

esta solução fornece:
- ✅ estrutura completa para o trabalho
- ✅ templates prontos para preenchimento
- ✅ scripts para facilitar execução
- ✅ guias detalhados de uso
- ✅ documentação completa

**você ainda precisa:**
- instalar ferramentas externas (nmap, nikto, etc.)
- ou usar kali linux (que já tem tudo)
- executar as análises nos alvos escolhidos
- preencher o relatório com resultados reais

**a solução facilita:**
- estruturação do trabalho
- execução das análises
- documentação dos resultados
- elaboração do relatório

**boa sorte com o trabalho!**

