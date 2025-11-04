# guia de ferramentas para análise de vulnerabilidades

este documento lista ferramentas comuns e técnicas utilizadas em análises de vulnerabilidades de rede.

## etapa 1 - obtenção de informações

### ferramentas de coleta de informações

#### whois
- **descrição:** consulta informações de registro de domínios e ips
- **uso:**
  ```bash
  whois exemplo.com
  whois 192.168.1.1
  ```
- **alternativas:** ferramentas web como whois.net, domaintools.com

#### dig / nslookup
- **descrição:** consultas dns para descobrir informações sobre domínios
- **uso:**
  ```bash
  dig exemplo.com
  dig exemplo.com mx
  dig exemplo.com ns
  nslookup exemplo.com
  ```

#### dnsrecon
- **descrição:** ferramenta de enumeração dns
- **instalação:** geralmente incluído em kali linux ou pode ser instalado via pip
- **uso:**
  ```bash
  dnsrecon -d exemplo.com
  dnsrecon -d exemplo.com -t std
  ```

#### theharvester
- **descrição:** coleta de informações de emails, subdomínios, hosts, etc.
- **uso:**
  ```bash
  theharvester -d exemplo.com -b google
  theharvester -d exemplo.com -l 100 -b all
  ```

## etapa 2 - mapeamento da rede e identificação de serviços

### varredura de portas

#### nmap
- **descrição:** ferramenta de varredura de rede e descoberta de portas mais popular
- **comandos úteis:**
  ```bash
  # varredura básica
  nmap -sS 192.168.1.1
  
  # varredura completa com detecção de versões
  nmap -sV -sC 192.168.1.1
  
  # varredura de todas as portas
  nmap -p- 192.168.1.1
  
  # detecção de sistema operacional
  nmap -O 192.168.1.1
  
  # varredura agressiva
  nmap -A 192.168.1.1
  
  # varredura udp
  nmap -sU 192.168.1.1
  
  # salvar resultados
  nmap -oN resultado.txt -oX resultado.xml 192.168.1.1
  ```

#### masscan
- **descrição:** varredura de portas extremamente rápida
- **uso:**
  ```bash
  masscan -p1-65535 192.168.1.1 --rate=1000
  ```

### identificação de serviços

#### nmap service detection
- já incluído no nmap com opção -sV

#### banner grabbing
- **netcat:**
  ```bash
  nc -v 192.168.1.1 80
  ```
- **telnet:**
  ```bash
  telnet 192.168.1.1 80
  ```

### varredura de vulnerabilidades

#### openvas / greenbone
- **descrição:** scanner de vulnerabilidades completo
- **uso:** interface web após instalação

#### nessus
- **descrição:** scanner comercial (versão community disponível)
- **uso:** interface web após instalação

#### nikto
- **descrição:** scanner de vulnerabilidades web
- **uso:**
  ```bash
  nikto -h http://192.168.1.1
  ```

#### sqlmap
- **descrição:** ferramenta de teste de injeção sql
- **uso:**
  ```bash
  sqlmap -u "http://alvo.com/page?id=1"
  ```

#### metasploit framework
- **descrição:** framework de exploração e teste de penetração
- **uso:** 
  ```bash
  msfconsole
  use auxiliary/scanner/portscan/tcp
  ```

## ferramentas adicionais úteis

### análise de tráfego

#### wireshark / tshark
- **descrição:** análise de pacotes de rede
- **uso:** interface gráfica (wireshark) ou linha de comando (tshark)

#### tcpdump
- **descrição:** captura de pacotes via linha de comando
- **uso:**
  ```bash
  tcpdump -i eth0 host 192.168.1.1
  ```

### enumeração de serviços específicos

#### smbclient / enum4linux
- **descrição:** enumeração de compartilhamentos smb/samba
- **uso:**
  ```bash
  smbclient -L //192.168.1.1
  enum4linux -a 192.168.1.1
  ```

#### snmpwalk
- **descrição:** enumeração snmp
- **uso:**
  ```bash
  snmpwalk -v2c -c public 192.168.1.1
  ```

## ambiente recomendado

### distribuições linux especializadas
- **kali linux:** distribuição mais popular para segurança e teste de penetração
- **parrot security os:** alternativa ao kali
- **blackarch:** baseado em arch linux, com muitas ferramentas

### instalação em outros sistemas
muitas ferramentas podem ser instaladas via:
- **python pip:** `pip install nome_ferramenta`
- **apt/yum/pacman:** dependendo da distribuição
- **docker:** muitas ferramentas têm imagens docker disponíveis

## boas práticas

1. **sempre obter autorização** antes de realizar varreduras
2. **documentar todos os comandos** executados
3. **salvar todos os resultados** (logs, screenshots, arquivos de saída)
4. **ser ético** e não explorar vulnerabilidades sem autorização
5. **usar ambientes controlados** para testes práticos
6. **documentar metodologia** para reprodutibilidade

## recursos de consulta

### bases de dados de vulnerabilidades
- **cve (common vulnerabilities and exposures):** https://cve.mitre.org/
- **nvd (national vulnerability database):** https://nvd.nist.gov/
- **exploit-db:** https://www.exploit-db.com/

### documentação
- **nmap documentation:** https://nmap.org/docs.html
- **metasploit unleashed:** guia completo do metasploit

## exemplo de workflow básico

1. **coleta de informações básicas:**
   ```bash
   whois alvo.com
   dig alvo.com
   ```

2. **varredura de portas:**
   ```bash
   nmap -sS -p- alvo.com
   ```

3. **identificação de serviços:**
   ```bash
   nmap -sV -sC alvo.com
   ```

4. **varredura de vulnerabilidades:**
   ```bash
   nikto -h http://alvo.com
   ```

5. **documentação:**
   - salvar todos os outputs
   - documentar descobertas
   - analisar resultados

