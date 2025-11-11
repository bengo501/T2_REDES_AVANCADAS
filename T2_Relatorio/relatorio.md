    Relatório de Análise de Vulnerabilidades

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

- **Endereço ip:** 192.168.0.86
- **Domínio:** não aplicável
- **Escopo do teste:**
  - **Dentro do escopo:**
    - identificação remota do host via consultas icmp/dns a partir da estação de análise
    - verificação de rota e registros públicos associados ao ip privado
  - **Fora do escopo:**
    - acesso direto ao sistema operacional macos ou coleta local de serviços
    - qualquer tentativa de autenticação ou exploração ativa

#### Alvo 2

- **Identificação:** dispositivo residente na rede doméstica (ip 192.168.0.54)
- **Endereço ip:** 192.168.0.54
- **Domínio:** não aplicável
- **Escopo do teste:**
  - **Dentro do escopo:**
    - testes icmp, consultas dns e verificação de disponibilidade realizados via wsl
    - observação da resposta do roteador intermediário e de eventuais filtros locais
  - **Fora do escopo:**
    - alterações no firmware do equipamento ou uso de credenciais do proprietário
    - geração de tráfego excessivo (flood) que possa comprometer a rede doméstica

### 1.2 Justificativa da escolha

    Ambos os alvos estão sob controle do grupo e localizam-se na mesma rede doméstica, o que facilita repetir medições com segurança. o notebook macos (192.168.0.86) apresenta comportamento diferenciado (bloqueio de icmp), fornecendo um caso real de host protegido. o outro dispositivo em 192.168.0.54 permanece ativo e responde a pings, servindo como contraste para avaliar como esses equipamentos lidam com tráfego básico.

## 2. Etapa 1

## Obtenção de informações

### 2.1 Métodos e ferramentas utilizadas

- **Ferramentas:** levantamento manual dos parâmetros de rede com `ipconfig`, `get-netipconfiguration` e `arp -a` (powershell) para mapear interfaces e vizinhos; uso de `ping`/`tracert` (powershell) e `traceroute`/`tracepath` (wsl) medindo latências e rotas; consultas `nslookup`, `whois` e `dig` (wsl) para validar registros dns e confirmar o bloco rfc 1918.
- **Técnicas:**
  - coleta passiva dos dados de configuração local antes de qualquer varredura ativa, assegurando visão inicial sem gerar ruído.
  - mapeamento de vizinhança via `arp -a` e testes icmp controlados para os hosts 192.168.0.54 e 192.168.0.86, identificando quem responde dentro da sub-rede.
  - análise de serviços expostos sem autenticação através de `netstat` e correlação com processos conhecidos, revelando portas em uso.
  - correlação das rotas e latências observadas no tracepath para entender o caminho até os resolvedores dns e eventuais gargalos.

### 2.2 Resultados

#### Alvo 1

- `ipconfig.txt` e `arp_hosts.txt` apontaram o macbook (mac 72-89-76-8b-5d-44) em 192.168.0.86 como alvo remoto. os resultados registram  `ping -c 6` com 100 % de perda e `traceroute` limitado ao gateway wsl (172.29.240.1), indicando que o host bloqueia icmp a partir da rede.
- `dns_a.txt`, `dns_ns.txt`, `dns_mx.txt` e `dns_txt.txt` retornaram apenas o próprio ip e informaram ausência de recursão, comportamento esperado para endereços privados. `nslookup.txt` e `whois.txt` reforçam que o bloco pertence ao rfc 1918 e não possui dados públicos específicos.
- o comportamento de bloqueio será útil na etapa 2 para validar como o host responde (ou não) a varreduras tcp/udp, exigindo abordagens passivas ou portas específicas.

#### alvo 2

- os resultados mostraram `ping -c 6` com média 16,6 ms (pico inicial 78 ms) e 0 % de perda, enquanto o `traceroute` retorna apenas o salto 172.29.240.1 e passa a responder com `*`, sinalizando firewall após o gateway interno.
- `dns_a.txt`, `dns_ns.txt`, `dns_mx.txt` e `dns_txt.txt` repetem o ip como resposta direta e alertam sobre recursão indisponível; `nslookup.txt` e `whois.txt` confirmam que o endereço faz parte do bloco privado rfc 1918, sem dados específicos do fabricante.
- o dispositivo responde a icmp, o que abre caminho para medir disponibilidade ao longo do tempo e, na etapa 2, observar como portas tcp/udp se comportam (se houver). a diferença de comportamento em relação ao macOS (.86) fornece um caso comparativo para a análise de vulnerabilidades.

## 3. Etapa 2

## Mapeamento da rede e identificação de serviços e vulnerabilidades

### 3.1 Tipos de varreduras e ferramentas utilizadas

- **Host discovery:** `sudo nmap -sn -n 192.168.0.54` e `sudo nmap -sn -Pn 192.168.0.86` (registrados em `resultados/etapa2/<ip>/host_discovery.txt`) para confirmar disponibilidade dos alvos mesmo com block de icmp.
- **Varredura tcp completa:** `sudo nmap -sS -sV -O -T4 -p- <ip>`; para o macOS (`192.168.0.86`) usamos `-Pn` a fim de ignorar ausência de ping. saídas em `tcp_full.txt`.
- **Varredura udp prioritária:** `sudo nmap -sU --top-ports 20 -sV <ip>` (com `-Pn` no macOS), salvando em `udp_top20.txt` para identificar serviços em udp comuns.
- **Análise de banners:** inspeção manual dos retornos http/vnc capturados pelo nmap (por exemplo, respostas plex em 32400/tcp) para inferir aplicações específicas.

### 3.2 Resultados e descobertas

#### Alvo 1 — 192.168.0.86 (macos)

- **Detecção:** `nmap -sn -Pn` confirmou host ativo mesmo sem responder icmp tradicional.
- **Superfície tcp:** todas as 65 535 portas apareceram como `filtered`, indicando firewall bloqueando tentativas (provavelmente a proteção padrão do macOS). nenhum banner foi obtido.
- **Superfície udp:** a maioria das portas também retornou `filtered` ou `open|filtered`; destaques para 53/udp S(resolver local), 137-138/udp (netbios), 1900/udp (upnp) e 500/udp (isakmp) marcadas como `open|filtered`. não foi possível validar diagnóstico sem acesso adicional.
- **Implicações:** o host está fortemente protegido; a etapa 3 deverá avaliar se é necessário manter ou ajustar o firewall e se os serviços udp listados devem ser desabilitados quando não utilizados.
- **Vulnerabilidades identificadas:** nenhuma vulnerabilidade confirmada neste estágio; manter o firewall ativo e monitorar os serviços udp listados.

#### Alvo 2 — 192.168.0.54

- **Detecção:** `nmap -sn` retornou latência média 18 ms e confirmou host ativo.
- **Superfície tcp (arquivo `tcp_full.txt`):**

| porta              | serviço detectado         | observações                                                                                 |
| ------------------ | -------------------------- | --------------------------------------------------------------------------------------------- |
| 5800/tcp           | `vnc-http` TightVNC      | banner revela usuário `fsos-7mpi809mcp`; versão específica não divulgada.               |
| 5900/tcp           | `vnc` protocolo 3.8      | acesso remoto direto; versão não informada pelo serviço.                                   |
| 7680/tcp           | `pando-pub?`             | possivelmente serviço de atualização windows (delivery optimization).                      |
| 8000/tcp, 9000/tcp | `Golang net/http server` | aponta para APIs customizadas (talvez serviços do fabricante).                               |
| 24563/tcp          | `tcpwrapped`             | porta aceita conexão mas encerra sem banner.                                                 |
| 32400/tcp          | `ssl/plex?`              | respostas HTTP `401 Unauthorized`; `/identity` expõe versão `1.42.1.10060-4e8b05daf`. |
| 49740/tcp          | serviço JSON customizado  | banner retorna `{"type":"Tier1","version":"1.0"}`.                                          |
| 57621/tcp          | desconhecido               | sem fingerprint, requer análise adicional.                                                   |

- **Detecção de sistema operacional:** nmap sugere windows 10/servidor 2008 com confiança ~90 %, porém os resultados são marcados como "não confiáveis" devido à ausência de portas fechadas para comparação.
- **Superfície udp (`udp_top20.txt`):** diversas portas `open|filtered` típicas de windows/iot (53, 123, 135-139, 161/162, 1900, 500/4500). requer validação manual para confirmar se estão realmente abertas.
- **Implicações:** presença de vnc exposto (5800/5900) e possíveis serviços plex/api elevam a superfície de ataque; recomenda-se na etapa 3 avaliar credenciais, restringir acesso ou desativar serviços desnecessários.

**Vulnerabilidades observadas (alvo 2):**

| # | serviço/sistema afetado              | descrição da falha                                                                                                                            | severidade                                                                                                                     | referência                                                                                |
| - | ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ |
| 1 | VNC (5800/5900/tcp)                   | Serviço RFB 3.8 exposto sem criptografia; tráfego pode ser interceptado/brute-forced, permitindo controle remoto completo do dispositivo.     | Alta (CVSS estimado 8.8)                                                                                                       | CWE-311 / RFC 6143 (ausência de proteção nativa); ver também CVE-2019-15681 (TightVNC) |
| 2 | API HTTP desconhecida (8000/9000/tcp) | Servidores Go `net/http` respondendo sem autenticação; endpoints potencialmente não documentados podem aceitar chamadas não autorizadas.  | Média (CVSS estimado 6.5)                                                                                                     | CWE-306 (Missing Authentication for Critical Function)                                     |
| 3 | Plex Media Server (32400/tcp)         | Interface TLS self-signed exposta;`/identity` revela versão `1.42.1.10060-4e8b05daf`. Apesar de atual, precisa de monitoramento constante. | Média (CVSS base 5.3 atual; 7.2 se versão vulnerável, ex. CVE-2023-24354)                                                   | CVE-2023-24354                                                                             |
| 4 | Serviços udp (53/123/500/1900 etc.)  | Diversos serviços `open                                                                                                                        | filtered` sem necessidade aparente; mantê-los ativos amplia superfície para amplification ou exploits conhecidos (ex. UPnP). | Baixa                                                                                      |

---

## 4. Etapa 3 - documentação, análise de impacto e propostas de correção/mitigação

### 4.1 Vulnerabilidades do alvo 1 (192.168.0.86)

os testes da etapa 2 não confirmaram serviços expostos nem vulnerabilidades exploráveis neste host macOS. o firewall bloqueou todas as portas tcp e udp avaliadas; portanto:

- **Status atual:** nenhuma vulnerabilidade confirmada.
- **Ações recomendadas:** manter o firewall habilitado, aplicar atualizações do macos e revisar periodicamente os serviços udp marcados como `open|filtered` (upnp, netbios) para garantir que continuem bloqueados ou desativados.
- **Prioridade:** baixa (monitoramento preventivo).

### 4.2 Vulnerabilidades do alvo 2

#### Vulnerabilidade 1: VNC sem criptografia (portas 5800/5900)

**Descrição:** o dispositivo expõe serviço VNC (TightVNC, protocolo RFB 3.8) via http e tcp, sem tunneling seguro. o banner indica usuário configurado, porém a versão específica não é divulgada e não foi possível confirmar se patches recentes foram aplicados.
**Análise do impacto:** um atacante na mesma rede pode realizar ataques de brute force à autenticação e, em caso de sucesso, assumir controle total do equipamento, capturando credenciais e pivotando para outros hosts. tráfego sem criptografia permite captura em trânsito.
**Proposta de correção/mitigação:** desabilitar o VNC quando não for indispensável; caso necessário, restringir acesso a uma sub-rede de administração, exigir senhas fortes, habilitar túnel seguro (ssh, vpn ou zerotier), considerar migração para rdp com tls nativo e registrar tentativas de login.
**Prioridade:** alta (cvss estimado 8,8; referência: cwe-311 e históricos de exploração como cve-2019-15681 em tightvnc desatualizado).

#### Vulnerabilidade 2: APIs http sem autenticação (portas 8000/9000)

**Descrição:** servidores Golang `net/http` respondem com status 404 sem exigir credenciais. a ausência de autenticação pode indicar endpoints acessíveis quando URLs corretas forem descobertas.
**Análise do impacto:** um atacante poderia realizar fuzzing/enumeração para encontrar endpoints internos, executar comandos administrativos ou obter dados sensíveis do dispositivo iot.
**Proposta de correção/mitigação:** mapear as APIs expostas, habilitar autenticação por token/sessão, limitar acesso ao segmento administrativo e remover endpoints desnecessários.
**Prioridade:** média (cvss estimado 6,5; referência: cwe-306 — missing authentication for critical function).

#### Vulnerabilidade 3: plex media server exposto (porta 32400/tcp)

**Descrição:** interface plex responde com `401 Unauthorized`, certificado autoassinado e expõe versão `1.42.1.10060-4e8b05daf` no endpoint `/identity`. trata-se da release atual (nov/2025), mas versões anteriores sofreram rce (ex.: cve-2023-24354).
**Análise do impacto:** se a instância for mantida atualizada, o risco cai para vazamento de metadados; caso desatualizada, um atacante pode explorar falhas conhecidas para executar código remoto, vazar mídia ou pivotar para o sistema operacional.
**Proposta de correção/mitigação:** manter atualização contínua e monitorar avisos de segurança, restringir a porta 32400 a ip autorizados (firewall ou vpn) e exigir autenticação plex com mfa.
**Prioridade:** média (cvss base 5,3 na versão atual; sobe para 7,2 se a aplicação ficar vulnerável como nas versões afetadas por cve-2023-24354).

#### Vulnerabilidade 4: serviços udp supérfluos

**Descrição:** portas udp como 53, 123, 137-138, 1900, 500/4500 permanecem `open|filtered`. se efetivamente abertas, oferecem superfície para reconhecimento, amplificação ou exploração (upnp, snmp).
**Análise do impacto:** atacantes podem abusar de upnp (1900) para reconfigurar roteamentos, usar ntp/dns para amplificação ou explorar vulnerabilidades conhecidas de snmp/netbios.
**Proposta de correção/mitigação:** executar varredura autenticada para confirmar quais serviços estão ativos, desativar funcionalidades não essenciais (upnp, snmp) e aplicar regras de firewall bloqueando udp onde não for utilizado.
**Prioridade:** baixa/média (risco moderado dependendo do serviço realmente ativo).

## 5. Conclusão

**Resumo:** mapear e comparar dois alvos internos (macos protegido e dispositivo iot com múltiplos serviços) mostrou contrastes na postura de segurança da rede doméstica. a etapa 1 garantiu inventário completo; a etapa 2 revelou serviços críticos (vnc, plex, apis http) e a etapa 3 consolidou impacto/mitigações.

**Principais descobertas:**

- `192.168.0.86` mantém firewall efetivo, sem portas tcp abertas; apenas monitoração preventiva é necessária.
- `192.168.0.54` expõe vnc sem criptografia, apis http internas e plex acessível, ampliando riscos de controle remoto e vazamento.
- serviços udp adicionais (upnp, snmp, isakmp) permanecem ativos/filtrados, aumentando superfície de ataque se habilitados.

**Vulnerabilidades críticas encontradas:** 1 (vnc sem criptografia).

**Recomendações gerais:**

- substituir o acesso remoto por solução com túnel seguro (ssh/zerotier) ou rdp com tls, removendo o vnc aberto.
- aplicar hardening no dispositivo iot: autenticação nas apis, limitar plex a vpn/firewall e desativar udp supérfluo.
- manter inventário e realizar varreduras periódicas antes de cada alteração de rede.

---

## anexos

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
