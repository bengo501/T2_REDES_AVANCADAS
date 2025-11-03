# exemplo de comandos executados

documente aqui todos os comandos executados durante a análise para referência futura e para incluir no anexo do relatório.

## alvo 1: exemplo.com (192.168.1.100)

### etapa 1 - coleta de informações

```bash
# whois
whois exemplo.com

# dns lookup
dig exemplo.com
dig exemplo.com mx
dig exemplo.com ns
dig exemplo.com txt

# nslookup
nslookup exemplo.com
```

### etapa 2 - varredura de rede

```bash
# varredura rápida
nmap -F 192.168.1.100

# varredura completa com versões
nmap -sV -sC 192.168.1.100

# detecção de sistema operacional
nmap -O 192.168.1.100

# varredura de todas as portas
nmap -p- 192.168.1.100

# varredura udp
nmap -sU --top-ports 100 192.168.1.100
```

### etapa 2 - varredura web

```bash
# nikto
nikto -h http://exemplo.com

# whatweb
whatweb http://exemplo.com -v

# headers http
curl -I http://exemplo.com
curl -v http://exemplo.com

# diretórios (se aplicável)
gobuster dir -u http://exemplo.com -w /usr/share/wordlists/dirb/common.txt
```

---

## alvo 2: 192.168.1.200

### etapa 1 - coleta de informações

```bash
# whois
whois 192.168.1.200

# dns reverso
dig -x 192.168.1.200
```

### etapa 2 - varredura de rede

```bash
# varredura completa
nmap -A 192.168.1.200

# varredura específica de serviços
nmap -p 22,80,443,3306 192.168.1.200 -sV
```

---

## anotações importantes

- **data das análises:** [preencher]
- **ambiente:** [kali linux / ubuntu / etc]
- **autorização:** [confirmar que foi obtida]
- **observações:** [notas relevantes sobre a execução]

---

## como usar este arquivo

1. copie os comandos acima como template
2. adicione os comandos que você realmente executou
3. inclua os outputs mais relevantes
4. referencie este arquivo no anexo do relatório
5. mantenha organizado por alvo e etapa

