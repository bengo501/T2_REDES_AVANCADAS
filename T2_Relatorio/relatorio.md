# 
    Relatório de Análise de Vulnerabilidades

## 
    Trabalho 2 - Redes de computadores avançadas

**Grupo:**

* Bernardo Heitz
* João Pedro Aiolfi
* Lucas Lantmann
* Lucas Brenner

## 1. Introdução

### 1.1 Alvo escolhido e escopo

#### Alvo 1

**Identificação:** notebook macos presente na rede doméstica

**Endereço ip:** 192.168.0.86

**Domínio:** não aplicável

**Escopo do teste:**

**
    Dentro do escopo:**

    Identificação remota do host via consultas icmp/dns a partir da estação de análise

    Verificação de rota e registros públicos associados ao ip privado

**
    Fora do escopo:**

    Acesso direto ao sistema operacional macos ou coleta local de serviços

    Qualquer tentativa de autenticação ou exploração ativa

#### Alvo 2

**Identificação:** dispositivo residente na rede doméstica (ip 192.168.0.54)

**Endereço ip:** 192.168.0.54

**Domínio:** não aplicável

**Escopo do teste:**

**
    Dentro do escopo:**

    Testes icmp, consultas dns e verificação de disponibilidade realizados via wsl

    Observação da resposta do roteador intermediário e de eventuais filtros locais

**
    Fora do escopo:**

    Alterações no firmware do equipamento ou uso de credenciais do proprietário

    Geração de tráfego excessivo (flood) que possa comprometer a rede doméstica

### 1.2 Justificativa da escolha

    Ambos os alvos estão sob controle do grupo e localizam-se na mesma rede doméstica, o que facilita repetir medições com segurança. o notebook macos (192.168.0.86) apresenta comportamento diferenciado (bloqueio de icmp), fornecendo um caso real de host protegido. o outro dispositivo em 192.168.0.54 permanece ativo e responde a pings, servindo como contraste para avaliar como esses equipamentos lidam com tráfego básico.

## 2. Etapa 1

## Obtenção de informações

### 2.1 Métodos e ferramentas utilizadas

**Ferramentas:** levantamento manual dos parâmetros de rede com `ipconfig`, `get-netipconfiguration` e `arp -a` (powershell) para mapear interfaces e vizinhos; uso de `ping`/`tracert` (powershell) e `traceroute`/`tracepath` (wsl) medindo latências e rotas; consultas `nslookup`, `whois` e `dig` (wsl) para validar registros dns e confirmar o bloco rfc 1918.

**Técnicas:**

Coleta passiva dos dados de configuração local antes de qualquer varredura ativa, assegurando visão inicial sem gerar ruído.

Mapeamento de vizinhança via `arp -a` e testes icmp controlados para os hosts 192.168.0.54 e 192.168.0.86, identificando quem responde dentro da sub-rede.

Análise de serviços expostos sem autenticação através de `netstat` e correlação com processos conhecidos, revelando portas em uso.

Correlação das rotas e latências observadas no tracepath para entender o caminho até os resolvedores dns e eventuais gargalos.

### 2.2 Resultados

#### Alvo 1

As capturas de `ipconfig.txt` e `arp_hosts.txt` que foram geradas identificam o MacBook (`MAC 72-89-76-8B-5D-44`) com IP 192.168.0.86. O `ping` salvou perda de 100% e o `traceroute` registrado mostra apenas o gateway WSL (172.29.240.1), evidenciando o bloqueio de ICMP pelo host.

Os arquivos `dns_a.txt`, `dns_ns.txt`, `dns_mx.txt`, `dns_txt.txt`, `nslookup.txt` e `whois.txt` confirmam que o endereço pertence ao bloco privado RFC 1918, sem registros públicos adicionais.

Esses resultados ressaltam que, na etapa 2, a abordagem deve considerar varreduras passivas ou técnicas que não dependam de respostas ICMP.

#### Alvo 2

Nos resultados encontrados, o `ping -c 6` registrou latência média de 16,6 ms (pico 78 ms) sem perdas. O `traceroute` parou após o salto 172.29.240.1, indicando firewall após o gateway.

Os arquivos DNS (`dns_a/ns/mx/txt`) retornaram o próprio IP, e `nslookup.txt`/`whois.txt` confirmam o uso de bloco privado RFC 1918.

Com o host respondendo a ICMP, fica possível medir disponibilidade contínua e, na etapa 2, observar portas TCP/UDP abertas, comparando o comportamento com o host macOS.

## 3. Etapa 2

## Mapeamento da rede e identificação de serviços e vulnerabilidades

### 3.1 Tipos de varreduras e ferramentas utilizadas

**Host discovery:** Com o comando `sudo nmap -sn -n 192.168.0.54` e `sudo nmap -sn -Pn 192.168.0.86`, gerando `host_discovery.txt` na pasta de resultados. O arquivo de 192.168.0.54 confirmou latência ~18 ms, o de 192.168.0.86 exigiu `-Pn` para sinalizar o host como “up” mesmo sem respostas icmp.

**Varredura tcp completa:** Com o comando `sudo nmap -sS -sV -O -T4 -p- <ip>`, salvando `tcp_full.txt`. Em 192.168.0.54 o log lista portas abertas (5800/5900/7680/8000/9000/24563/32400/49740/57621), em 192.168.0.86 todas as 65 535 portas apareceram como `filtered`.

**Varredura udp prioritária:** Com o comando `sudo nmap -sU --top-ports 20 -sV <ip>` (com `-Pn` no macOS), produzindo `udp_top20.txt`. O arquivo de 192.168.0.54 mostra várias portas `open|filtered` típicas de windows/iot; o de 192.168.0.86 retorna portas `filtered` ou `open|filtered`, indicando bloqueio de firewall.

**Análise de banners:** Após a varredura, foram capturados cabeçalhos http e plex (`curl -i http://192.168.0.54:8000/`, `curl -ks https://192.168.0.54:32400/identity`) e executado `nmap --script vnc-info`, ajudando a identificar TightVNC exposto e versão do Plex (`1.42.1.10060-4e8b05daf`).

### 3.2 Resultados e descobertas

#### Alvo 1 — 192.168.0.86 (macos)

**Detecção:** O comando `nmap -sn -Pn` confirmou host ativo mesmo sem responder icmp tradicional.

**Superfície tcp:** Todas as 65 535 portas apareceram como `filtered`, indicando firewall bloqueando tentativas (provavelmente a proteção padrão do macOS). nenhum banner foi obtido.

**Superfície udp:** A maioria das portas também retornou `filtered` ou `open|filtered`, dando destaques para 53/udp S(resolver local), 137-138/udp (netbios), 1900/udp (upnp) e 500/udp (isakmp) marcadas como `open|filtered`. Não foi possível validar diagnóstico sem acesso adicional.

**Implicações:** O host está fortemente protegido, a etapa 3 deverá avaliar se é necessário manter ou ajustar o firewall e se os serviços udp listados devem ser desabilitados quando não utilizados.

**Vulnerabilidades identificadas:** Nenhuma vulnerabilidade confirmada neste estágio, devemos manter o firewall ativo e monitorar os serviços udp listados.

#### Alvo 2 — 192.168.0.54

**Detecção:** O comando `nmap -sn` retornou latência média 18 ms e confirmou host ativo.

**Superfície tcp (`tcp_full`):** Resultado da varredura `nmap -sS -sV -O -T4 -p-`.  O arquivo do alvo 192.168.0.54 lista portas abertas (5800/5900/7680/8000/9000/24563/32400/49740/57621) com seus banners; o do alvo 192.168.0.86 mostra todas as portas como `filtered`, evidenciando o bloqueio do firewall.

| Porta              | Serviço detectado         | Observações                                                                                 |
| ------------------ | -------------------------- | --------------------------------------------------------------------------------------------- |
| 5800/tcp           | `vnc-http` TightVNC      | banner revela usuário `fsos-7mpi809mcp`; versão específica não divulgada.               |
| 5900/tcp           | `vnc` protocolo 3.8      | acesso remoto direto; versão não informada pelo serviço.                                   |
| 7680/tcp           | `pando-pub?`             | possivelmente serviço de atualização windows (delivery optimization).                      |
| 8000/tcp, 9000/tcp | `Golang net/http server` | aponta para APIs customizadas (talvez serviços do fabricante).                               |
| 24563/tcp          | `tcpwrapped`             | porta aceita conexão mas encerra sem banner.                                                 |
| 32400/tcp          | `ssl/plex?`              | respostas HTTP `401 Unauthorized`; `/identity` expõe versão `1.42.1.10060-4e8b05daf`. |
| 49740/tcp          | serviço JSON customizado  | banner retorna `{"type":"Tier1","version":"1.0"}`.                                          |
| 57621/tcp          | desconhecido               | sem fingerprint, requer análise adicional.                                                   |

**Detecção de sistema operacional:** Nmap sugere windows 10/servidor 2008 com confiança ~90 %, porém os resultados são marcados como "não confiáveis" devido à ausência de portas fechadas para comparação.

**Superfície udp (`udp_top20`):** Saída do comando `nmap -sU --top-ports 20 -sV`.  no alvo 192.168.0.54 foram registradas portas `open|filtered` como 53/udp, 123/udp, 137-138/udp, 1900/udp e 500/udp, indicando serviços possivelmente ativos.  No 192.168.0.86 o arquivo mostra portas `filtered` ou `open|filtered`, coerente com o filtragem do macOS.

**Implicações:** Presença de vnc exposto (5800/5900) e possíveis serviços plex/api elevam a superfície de ataque; recomenda-se na etapa 3 avaliar credenciais, restringir acesso ou desativar serviços desnecessários.

**Vulnerabilidades observadas (alvo 2):**

| # | Serviço/sistema afetado              | Descrição da falha                                                                                                                            | Severidade                                                                                                                     |
| - | ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| 1 | VNC (5800/5900/tcp)                   | Serviço RFB 3.8 exposto sem criptografia; tráfego pode ser interceptado/brute-forced, permitindo controle remoto completo do dispositivo.     | Alta (CVSS estimado 8.8)                                                                                                       |
| 2 | API HTTP desconhecida (8000/9000/tcp) | Servidores Go `net/http` respondendo sem autenticação; endpoints potencialmente não documentados podem aceitar chamadas não autorizadas.  | Média (CVSS estimado 6.5)                                                                                                     |
| 3 | Plex Media Server (32400/tcp)         | Interface TLS self-signed exposta;`/identity` revela versão `1.42.1.10060-4e8b05daf`. Apesar de atual, precisa de monitoramento constante. | Média (CVSS base 5.3 atual; 7.2 se versão vulnerável, ex. CVE-2023-24354)                                                   |
| 4 | Serviços udp (53/123/500/1900 etc.)  | Diversos serviços `open                                                                                                                        | filtered` sem necessidade aparente; mantê-los ativos amplia superfície para amplification ou exploits conhecidos (ex. UPnP). |

---

## 4. Etapa 3 - documentação, análise de impacto e propostas de correção/mitigação

### 4.1 Vulnerabilidades do alvo 1 (192.168.0.86)

Os testes da etapa 2 não confirmaram serviços expostos nem vulnerabilidades exploráveis neste host macOS. o firewall bloqueou todas as portas tcp e udp avaliadas; portanto:

**Status atual:** Nenhuma vulnerabilidade foi confirmada.

**Ações recomendadas:** Manter o firewall habilitado, aplicar atualizações do macos e revisar periodicamente os serviços udp marcados como `open|filtered` (upnp, netbios) para garantir que continuem bloqueados ou desativados.

**Prioridade:** Baixa, apenas manter monitoramento preventivo.

### 4.2 Vulnerabilidades do alvo 2

#### Vulnerabilidade 1: VNC sem criptografia (portas 5800/5900)

**Descrição:** O dispositivo expõe serviço VNC (TightVNC, protocolo RFB 3.8) via http e tcp, sem tunneling seguro. O banner indica usuário configurado, porém a versão específica não é divulgada e não foi possível confirmar se patches recentes foram aplicados.
**Análise do impacto:** Um atacante na mesma rede pode realizar ataques de força bruta até a autenticação, em caso de sucesso, pode assumir controle do equipamento, capturando credenciais e pivotando para outros hosts. Tráfego sem criptografia permite captura em trânsito.
**Proposta de correção/mitigação:** Desabilitar o VNC quando não for indispensável, caso seja necessário, restringir acesso a uma sub-rede de administração, exigir senhas fortes, habilitar túnel seguro (ssh, vpn ou zerotier).
**Prioridade:** Alta (cvss estimado 8,8; referência: cwe-311 e históricos de exploração como cve-2019-15681 em tightvnc desatualizado).

#### Vulnerabilidade 2: APIs http sem autenticação (portas 8000/9000)

**Descrição:** Servidores Golang `net/http` respondem com status 404 sem exigir credenciais. A ausência de autenticação pode indicar endpoints acessíveis quando URLs corretas forem descobertas.
**Análise do impacto:** Um atacante poderia realizar fuzzing/enumeração para encontrar endpoints internos, executar comandos administrativos ou obter dados sensíveis do dispositivo alvo.
**Proposta de correção/mitigação:** Mapear as APIs expostas, habilitar autenticação por token/sessão, limitar acesso apenas ao segmento administrativo e remover endpoints que são desnecessários.
**Prioridade:** Média (cvss estimado 6,5; referência: cwe-306 — missing authentication for critical function).

#### Vulnerabilidade 3: plex media server exposto (porta 32400/tcp)

**Descrição:** Interface plex responde com `401 Unauthorized`, certificado autoassinado e expõe versão `1.42.1.10060-4e8b05daf` no endpoint `/identity`. trata-se da release atual (nov/2025), mas versões anteriores sofreram rce (ex.: cve-2023-24354).
**Análise do impacto:** Se a instância for mantida atualizada, o risco cai para vazamento de metadados, mas caso ela seja desatualizada, um atacante pode explorar falhas conhecidas para executar código remoto e vazar dados.
**Proposta de correção/mitigação:** manter atualização contínua e monitorar avisos de segurança, restringir a porta 32400 a ip autorizados (firewall ou vpn) e exigir autenticação plex com autenticação multifator.
**Prioridade:** Média (cvss base 5,3 na versão atual, porém sobe para 7,2 se a aplicação ficar vulnerável como nas versões afetadas por cve-2023-24354).

#### Vulnerabilidade 4: serviços udp supérfluos

**Descrição:** Portas udp como 53, 123, 137-138, 1900, 500/4500 permanecem `open|filtered`. se efetivamente abertas, oferecem superfície para reconhecimento, amplificação ou exploração (upnp, snmp).
**Análise do impacto:** Atacantes podem abusar de upnp (1900) para reconfigurar roteamentos, usar ntp/dns para amplificação ou explorar vulnerabilidades conhecidas de snmp/netbios.
**Proposta de correção/mitigação:** Executar varredura autenticada para confirmar quais serviços estão ativos, desativar funcionalidades não essenciais (upnp, snmp) e aplicar regras de firewall bloqueando udp onde não for utilizado.
**Prioridade:** Baixa/média

## 5. Conclusão

**Resumo:** Mapear e comparar esses dois alvos (macos protegido e dispositivo com múltiplos serviços) mostrou contrastes na forma de segurança da rede doméstica. A etapa 1 nos mostrou o inventário completo, já a etapa 2 revelou serviços críticos (vnc, plex, apis http) e a etapa 3 consolidou os impactos e mitigações.

**Principais descobertas:**

O ip alvo 1: `192.168.0.86` mantém firewall efetivo, sem portas tcp abertas, apenas monitoração preventiva é necessária.

O ip alvo 2: `192.168.0.54` expõe vnc sem criptografia, apis http internas e plex acessível, ampliando riscos de controle remoto e vazamento.

Serviços udp adicionais (upnp, snmp, isakmp) permanecem ativos/filtrados, aumentando superfície de ataque se habilitados.

**Vulnerabilidades críticas encontradas:** 1 (vnc sem criptografia).

**Recomendações gerais:**

Substituir o acesso remoto por solução com túnel seguro (ssh/zerotier), para que assim remova o vnc aberto.

Aplicar hardening no dispositivo com multiplos serviços rodando, como, autenticação nas apis, limitar plex a vpn/firewall e desativar udp supérfluo.

Manter inventário e realizar varreduras periódicas antes de cada alteração de rede.

### anexo a - evidências e logs

- `resultados/20251110_223052_192_168_0_54/*`
- `resultados/20251110_223542_192_168_0_86/*`
- `resultados/etapa2/192.168.0.54/*`
- `resultados/etapa2/192.168.0.86/*`

### anexo b - comandos executados

```
wsl ./scripts/etapa1/coleta_informacoes.sh 192.168.0.54
wsl ./scripts/etapa1/coleta_informacoes.sh 192.168.0.86
wsl sudo nmap -sn -n 192.168.0.54
wsl sudo nmap -sS -sV -O -T4 -p- 192.168.0.54
wsl sudo nmap -sU --top-ports 20 -sV 192.168.0.54
wsl sudo nmap -sn -Pn 192.168.0.86
wsl sudo nmap -sS -sV -O -Pn -T4 -p- 192.168.0.86
wsl sudo nmap -sU --top-ports 20 -sV -Pn 192.168.0.86
wsl sudo nmap -sV --script vnc-info 192.168.0.54 -p 5900
wsl curl -ki https://192.168.0.54:32400
wsl curl -ks https://192.168.0.54:32400/identity
wsl curl -i http://192.168.0.54:8000/
wsl curl -i http://192.168.0.54:9000/
```
