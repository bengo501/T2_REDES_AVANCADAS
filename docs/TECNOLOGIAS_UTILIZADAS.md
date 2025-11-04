# tecnologias utilizadas no trabalho

documento completo listando todas as tecnologias, programas, terminal e sistema operacional necessários para o trabalho.

## índice

1. [sistema operacional](#sistema-operacional)
2. [terminal](#terminal)
3. [ferramentas de análise](#ferramentas-de-análise)
4. [linguagens e scripts](#linguagens-e-scripts)
5. [formatos de arquivo](#formatos-de-arquivo)
6. [bases de dados online](#bases-de-dados-online)

---

## sistema operacional

### opção 1: kali linux (recomendado)

**tipo:** distribuição linux baseada em debian  
**versão:** mais recente (2024.x ou superior)  
**obtenção:** https://www.kali.org/get-kali/  

**características:**
- sistema operacional completo
- todas as ferramentas já instaladas
- otimizado para segurança e testes de penetração
- baseado em debian/ubuntu

**instalação:**
- máquina virtual (virtualbox/vmware) - recomendado
- live usb (bootável) - não modifica sistema
- dual boot (instalação real) - cuidado, modifica disco
- wsl (windows subsystem for linux) - limitado

**vantagens:**
- todas as ferramentas já instaladas
- ambiente completo e pronto
- não precisa instalar nada manualmente
- amplamente usado na indústria

**desvantagens:**
- requer máquina virtual ou instalação
- pode ser pesado para máquinas antigas

---

### opção 2: ubuntu/debian linux

**tipo:** distribuição linux padrão  
**versão:** ubuntu 22.04 lts ou superior / debian 11 ou superior  
**obtenção:** 
- ubuntu: https://ubuntu.com/download
- debian: https://www.debian.org/distrib/

**características:**
- sistema operacional linux padrão
- ferramentas precisam ser instaladas manualmente
- mais controle sobre o ambiente

**instalação:**
- máquina virtual (virtualbox/vmware)
- live usb (bootável)
- dual boot (instalação real)
- wsl (windows subsystem for linux)

**vantagens:**
- mais controle sobre instalações
- ambiente familiar para quem já usa linux
- mais leve que kali (pode ser)

**desvantagens:**
- precisa instalar ferramentas manualmente
- mais trabalho de configuração inicial

---

### opção 3: windows + wsl (windows subsystem for linux)

**tipo:** linux dentro do windows  
**versão:** wsl 2 (recomendado)  
**obtenção:** incluído no windows 10/11  

**características:**
- executa linux dentro do windows
- não precisa de máquina virtual separada
- acesso ao sistema de arquivos do windows

**instalação:**
```powershell
# no powershell como administrador
wsl --install
# reiniciar computador
# instalar ubuntu da microsoft store
```

**vantagens:**
- funciona no windows
- não precisa de máquina virtual
- acesso ao sistema de arquivos do windows

**desvantagens:**
- algumas ferramentas podem ter limitações
- performance pode ser menor que nativo
- requer windows 10/11 atualizado

---

### opção 4: windows nativo (limitado)

**tipo:** windows 10/11  
**características:**
- algumas ferramentas têm versão windows
- muitas ferramentas não têm versão nativa
- funcionalidade limitada

**desvantagens:**
- muitas ferramentas não disponíveis
- funcionalidade muito limitada
- não recomendado para o trabalho

---

## terminal

### bash (bourne again shell)

**tipo:** shell do linux  
**versão:** incluído em todas as distribuições linux  
**uso:** terminal padrão do linux  

**características:**
- interface de linha de comando
- execução de comandos e scripts
- principal terminal usado no trabalho

**comandos básicos:**
```bash
# navegação
cd /caminho/para/diretorio
ls -la
pwd

# execução de scripts
chmod +x script.sh
./script.sh

# redirecionamento
comando > arquivo.txt
comando >> arquivo.txt
```

---

### powershell (windows)

**tipo:** shell do windows  
**versão:** incluído no windows 10/11  
**uso:** terminal do windows (se usar wsl)  

**características:**
- interface de linha de comando do windows
- usado apenas para instalar wsl (se necessário)
- não é usado para análise de segurança

**comando básico:**
```powershell
# instalar wsl
wsl --install
```

---

### git bash (windows - opcional)

**tipo:** emulador de bash para windows  
**versão:** incluído com git  
**uso:** terminal alternativo no windows  

**características:**
- emula bash no windows
- funcionalidade limitada
- não recomendado para o trabalho

---

## ferramentas de análise

### nmap (network mapper)

**tipo:** ferramenta de varredura de rede  
**versão:** 7.80 ou superior  
**obtenção:** 
- kali linux: já instalado
- ubuntu/debian: `sudo apt install nmap`
- site: https://nmap.org/

**uso:**
- varredura de portas
- detecção de serviços
- detecção de versões
- detecção de sistema operacional
- varredura de vulnerabilidades

**comandos principais:**
```bash
nmap -F [ip]                    # varredura rápida
nmap -sV -sC [ip]              # varredura completa
nmap -O [ip]                    # detecção de os (requer root)
nmap -sU [ip]                   # varredura udp (requer root)
nmap --script vuln [ip]        # varredura de vulnerabilidades
```

**tecnologia:** linguagem c/c++

---

### nikto

**tipo:** scanner de vulnerabilidades web  
**versão:** 2.1.5 ou superior  
**obtenção:**
- kali linux: já instalado
- ubuntu/debian: `sudo apt install nikto`
- site: https://cirt.net/nikto2

**uso:**
- varredura de vulnerabilidades web
- análise de servidores http/https
- detecção de problemas de configuração

**comandos principais:**
```bash
nikto -h http://[ip] -output resultado.txt
```

**tecnologia:** linguagem perl

---

### whois

**tipo:** ferramenta de consulta de registro  
**versão:** incluído em linux  
**obtenção:**
- kali linux: já instalado
- ubuntu/debian: `sudo apt install whois`

**uso:**
- consulta de informações de registro de domínios
- consulta de informações de ips
- obtenção de informações básicas

**comandos principais:**
```bash
whois exemplo.com
whois 192.168.1.1
```

**tecnologia:** linguagem c

---

### dig (domain information groper)

**tipo:** ferramenta de consulta dns  
**versão:** incluído em linux  
**obtenção:**
- kali linux: já instalado
- ubuntu/debian: `sudo apt install dnsutils`

**uso:**
- consultas dns
- resolução de nomes
- dns reverso
- consultas de registros mx, ns, txt

**comandos principais:**
```bash
dig exemplo.com
dig exemplo.com mx
dig exemplo.com ns
dig -x 192.168.1.1
```

**tecnologia:** linguagem c

---

### nslookup

**tipo:** ferramenta de consulta dns  
**versão:** incluído em linux  
**obtenção:**
- kali linux: já instalado
- ubuntu/debian: `sudo apt install dnsutils`

**uso:**
- resolução de nomes
- consultas dns básicas
- alternativa ao dig

**comandos principais:**
```bash
nslookup exemplo.com
nslookup 192.168.1.1
```

**tecnologia:** linguagem c

---

### curl

**tipo:** ferramenta de requisições http  
**versão:** incluído em linux  
**obtenção:**
- kali linux: já instalado
- ubuntu/debian: `sudo apt install curl`

**uso:**
- requisições http/https
- análise de headers
- teste de serviços web
- download de arquivos

**comandos principais:**
```bash
curl -I http://[ip]
curl -v http://[ip]
curl http://[ip]
```

**tecnologia:** linguagem c

---

### ping

**tipo:** ferramenta de teste de conectividade  
**versão:** incluído em todos os sistemas  
**obtenção:** já instalado  

**uso:**
- teste de conectividade
- medição de latência
- verificação de disponibilidade

**comandos principais:**
```bash
ping -c 4 [ip]
ping [ip]
```

**tecnologia:** linguagem c

---

## linguagens e scripts

### bash scripting

**tipo:** linguagem de script shell  
**versão:** bash 5.x ou superior  
**uso:** scripts de automação  

**características:**
- scripts .sh
- automação de tarefas
- execução de comandos em sequência
- processamento de resultados

**exemplos:**
```bash
#!/bin/bash
# script bash
ALVO="192.168.1.1"
nmap -sV -sC $ALVO -oN scan.txt
```

**arquivos:** `*.sh`

---

### markdown

**tipo:** linguagem de marcação  
**versão:** markdown padrão  
**uso:** documentação e relatórios  

**características:**
- formatação de texto
- tabelas
- listas
- código

**exemplos:**
```markdown
# título
## subtítulo
**negrito**
- lista
```

**arquivos:** `*.md`

---

## formatos de arquivo

### texto (.txt)

**tipo:** arquivo de texto simples  
**uso:** resultados de ferramentas, logs  

**características:**
- texto simples
- sem formatação
- fácil de ler

**exemplos:**
- `scan_completo.txt`
- `ping.txt`
- `nikto_resultado.txt`

---

### xml (.xml)

**tipo:** extensible markup language  
**uso:** resultados estruturados do nmap  

**características:**
- formato estruturado
- fácil de processar
- usado pelo nmap

**exemplos:**
- `scan_completo.xml`
- `scan_vuln.xml`

---

### markdown (.md)

**tipo:** markdown  
**uso:** documentação e relatórios  

**características:**
- formatação rica
- fácil de ler
- usado para relatórios

**exemplos:**
- `relatorio.md`
- `README.md`
- `PASSO_A_PASSO.md`

---

## bases de dados online

### cve database

**tipo:** base de dados de vulnerabilidades  
**url:** https://cve.mitre.org/  
**uso:** pesquisa de vulnerabilidades conhecidas  

**características:**
- lista de vulnerabilidades conhecidas
- identificadores cve
- descrições detalhadas
- referências

---

### nvd (national vulnerability database)

**tipo:** base de dados nacional de vulnerabilidades  
**url:** https://nvd.nist.gov/  
**uso:** pesquisa de vulnerabilidades com cvss  

**características:**
- pontuação cvss
- severidade classificada
- informações detalhadas
- atualizações regulares

---

### exploit-db

**tipo:** base de dados de exploits  
**url:** https://www.exploit-db.com/  
**uso:** pesquisa de exploits públicos  

**características:**
- exploits públicos
- código de exemplo
- referências a cves
- informações de exploração

---

## resumo das tecnologias

### sistema operacional

| tecnologia | recomendação | uso |
|------------|--------------|-----|
| **kali linux** | ⭐⭐⭐⭐⭐ | recomendado |
| **ubuntu/debian** | ⭐⭐⭐⭐ | alternativa |
| **windows + wsl** | ⭐⭐⭐ | funcional |
| **windows nativo** | ⭐ | não recomendado |

### terminal

| tecnologia | uso |
|------------|-----|
| **bash** | terminal principal |
| **powershell** | apenas para instalar wsl |
| **git bash** | não recomendado |

### ferramentas principais

| ferramenta | uso | obrigatório |
|------------|-----|-------------|
| **nmap** | varredura de rede | ✅ sim |
| **nikto** | vulnerabilidades web | ✅ sim |
| **whois** | informações de registro | ✅ sim |
| **dig** | consultas dns | ✅ sim |
| **nslookup** | consultas dns | ✅ sim |
| **curl** | requisições http | ✅ sim |
| **ping** | teste de conectividade | ✅ sim |

### linguagens e formatos

| tecnologia | uso |
|------------|-----|
| **bash scripting** | scripts de automação |
| **markdown** | documentação |
| **texto (.txt)** | resultados |
| **xml (.xml)** | resultados estruturados |

### bases de dados online

| base de dados | uso |
|---------------|-----|
| **cve database** | pesquisa de vulnerabilidades |
| **nvd** | pesquisa com cvss |
| **exploit-db** | pesquisa de exploits |

---

## instalação completa

### opção 1: kali linux (recomendado)

**passo 1:** baixar kali linux
- site: https://www.kali.org/get-kali/
- escolher: virtualbox 64-bit ou vmware

**passo 2:** instalar virtualbox
- site: https://www.virtualbox.org/
- instalar virtualbox

**passo 3:** importar kali linux
- abrir virtualbox
- arquivo > importar aparelho virtual
- selecionar arquivo .ova baixado
- importar

**passo 4:** iniciar kali linux
- selecionar kali linux na lista
- iniciar
- usuário: `kali`
- senha: `kali`

**passo 5:** verificar ferramentas
```bash
nmap --version
nikto --version
whois --version
dig --version
```

**todas as ferramentas já estarão instaladas!**

---

### opção 2: ubuntu/debian + ferramentas

**passo 1:** instalar ubuntu/debian
- baixar e instalar ubuntu ou debian
- ou usar wsl: `wsl --install`

**passo 2:** instalar ferramentas
```bash
sudo apt update
sudo apt upgrade -y
sudo apt install nmap nikto whois dnsutils curl -y
```

**passo 3:** verificar instalação
```bash
nmap --version
nikto --version
whois --version
dig --version
```

---

## tecnologias não utilizadas

### o que não precisamos

- **programação avançada:** não é necessário programar
- **bancos de dados:** não usamos bancos de dados
- **servidores web:** não precisamos configurar servidores
- **frameworks complexos:** ferramentas simples são suficientes
- **linguagens de programação:** apenas bash para scripts simples

---

## requisitos de sistema

### mínimo recomendado

**hardware:**
- cpu: 2 cores ou mais
- ram: 4gb ou mais (8gb recomendado)
- disco: 20gb livres ou mais
- rede: conexão com internet

**software:**
- sistema operacional: kali linux ou ubuntu/debian
- ferramentas: nmap, nikto, whois, dig, curl
- terminal: bash

---

## resumo rápido

### tecnologias principais

1. **sistema operacional:**
   - kali linux (recomendado) ou ubuntu/debian

2. **terminal:**
   - bash (linux)

3. **ferramentas:**
   - nmap (varredura de rede)
   - nikto (vulnerabilidades web)
   - whois, dig, nslookup (informações dns)
   - curl (requisições http)
   - ping (conectividade)

4. **scripts:**
   - bash (.sh)

5. **documentação:**
   - markdown (.md)
   - texto (.txt)
   - xml (.xml)

6. **bases de dados online:**
   - cve database
   - nvd
   - exploit-db

---

**todas as tecnologias são gratuitas e open source!**

