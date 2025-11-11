# Relatório de análise de vulnerabilidades

**disciplina:** redes de computadores avançadas
**universidade:** pontifícia universidade católica do rio grande do sul
**escola politécnica**
**data:** [preencher]
**grupo:** Bernardo Klein Heitz

    João Pedro Aiolfi

    Lucas Lantmann

## 1. introdução

### 1.1 alvo escolhido e escopo

#### alvo 1

- **nome/identificação:** desktop bengo (windows 11 + wsl2)
- **endereço ip:** 192.168.0.15 (wi-fi) e 172.29.240.1 (interface vethernet do wsl)
- **domínio (se aplicável):** não aplicável
- **escopo do teste:**
  - **dentro do escopo:**
    - inventário de interfaces, serviços em escuta e logs locais do windows
    - conectividade com o roteador doméstico 192.168.0.1 e com os vizinhos identificados em 192.168.0.0/24
  - **fora do escopo:**
    - dispositivos de terceiros conectados à mesma rede sem autorização
    - serviços externos acessados via https durante o uso normal do desktop

#### alvo 2

- **nome/identificação:** resolvedor dns residencial configurado no roteador (serviços 181.213.132.4 e 181.213.132.5)
- **endereço ip:** 181.213.132.4 e 181.213.132.5
- **domínio (se aplicável):** não aplicável
- **escopo do teste:**
  - **dentro do escopo:**
    - consultas whois/dig/nslookup realizadas via wsl
    - medições de latência e rota (ping, tracepath) a partir da rede doméstica
  - **fora do escopo:**
    - alterações de configuração no roteador ou no provedor
    - tráfego malicioso ou de carga contra hops intermediários

### 1.2 justificativa da escolha

os dois alvos pertencem integralmente ao grupo e podem ser avaliados sem risco jurídico. o desktop bengo concentra as ferramentas de desenvolvimento e permanece ligado durante a disciplina, permitindo observar portas em escuta (netstat) e a interação com a wsl. já os resolvedores dns 181.213.132.4/5 são os servidores utilizados por toda a rede net 702 5g; analisá-los ajuda a compreender dependências externas antes de partir para testes mais intrusivos. a combinação entrega contraste entre um host de usuário final e um serviço de infraestrutura crítica da mesma rede doméstica.

## 2. Etapa 1 

## Obtenção de informações

### 2.1 métodos e ferramentas utilizadas

- **ferramentas:**
  - `scripts/etapa1/coleta_informacoes.sh` – automatizou consultas whois/dig/nslookup, ping e tracepath para cada ip-alvo, salvando tudo em `resultados/<timestamp>_<alvo>/`
  - `ipconfig`, `get-netipconfiguration` e `arp -a` (powershell) – inventário de interfaces, dns configurados e vizinhos na sub-rede
  - `netstat -ano` e `Get-NetTCPConnection` – levantamento das portas tcp/udp em escuta e processos associados no desktop
  - `ping`, `tracert` (windows) e `tracepath` (wsl) – medições de latência, perda e hops para hosts internos e externos
  - `dig`, `nslookup` (wsl) – confirmação de respostas dos servidores dns e captura de registros a, ns, mx e txt
- **técnicas:**
  - coleta passiva de configuração local antes de qualquer varredura ativa
  - mapeamento de vizinhança via arp e testes icmp controlados para hosts 192.168.0.54 e 192.168.0.86
  - análise de serviços expostos sem autenticação através de estatísticas de sockets (netstat) e correlação com pids conhecidos
  - correlação dos dados de rota/latência com o cenário visível no tracepath para entender o caminho até os resolvedores dns

### 2.2 resultados

#### alvo 1

- `ipconfig.txt` registrou a interface wi-fi intel ax201 com ipv4 192.168.0.15/24, gateway 192.168.0.1, dns 181.213.132.4/5 e ipv6 globais 2804:14d:4cd6:b384::/64; a interface vethernet do wsl permanece em 172.29.240.1/20.
- nova execução do script (`resultados/20251110_223041_192_168_0_15/`) mostrou `ping -c 6` respondendo com média 1,60 ms (ttl 127) e `traceroute` com dois saltos (172.29.240.1 → 192.168.0.15), confirmando comunicação íntegra entre wsl e windows.
- `netstat_ano.txt` e `net_tcp_connections.txt` continuam evidenciando serviços expostos: tcp 135, 445, 5040, 5800-5900, 808, 3000, 6463, 58185 e udp 53, 123, 500/4500, 5353/5355. estes serão priorizados na etapa 2.
- `arp_hosts.txt` mantém os vizinhos 192.168.0.54 (10-68-38-d1-9a-0b) e 192.168.0.86 (72-89-76-8b-5d-44). o host .54 respondeu ao `ping` com média 16,6 ms (pico inicial 78 ms) e `traceroute` limitado pelo firewall após o primeiro salto; o host .86 continua bloqueando icmp (100 % de perda) e não retorna hops além do gateway do wsl.
- consultas adicionais (`ping`/`traceroute`) confirmaram latência de um dígito até o roteador 192.168.0.1 e caminho consistente antes de sair para a internet.
- os relatórios WHOIS dos ips privados agora foram capturados com sucesso, reforçando que pertencem ao bloco RFC 1918 e exigem análise apenas dentro da rede local.

#### alvo 2

- `resultados/20251110_223856_181_213_132_4/` registrou `ping` estável (média 11,8 ms, 0 % perda) e `traceroute` evidenciando o caminho 172.29.240.1 → 192.168.0.1 → 10.15.0.1 → 201.21.210.117 → 201.21.192.200, seguido de filtros nos roteadores do provedor.
- `resultados/20251110_224140_181_213_132_5/` mostrou comportamento semelhante, porém com maior variação (média 53,7 ms devido a dois picos acima de 120 ms) e traceroute quase idêntico até o backbone da claro.
- `dns_a.txt`, `dns_ns.txt`, `dns_mx.txt` e `dns_txt.txt` retornaram o próprio endereço sem registros auxiliares e sinalizaram “recursion requested but not available”, confirmando operação com recursão desabilitada.
- `nslookup.txt` reforçou a resolução direta e sem aliases; `whois.txt` agora traz os detalhes completos do bloco 181.213.0.0/16 (Claro NXT / AS28573), com contatos de abuso `virtua@virtua.com.br`.
- os testes validam que toda a rede net 702 5g depende exclusivamente desses resolvedores; qualquer indisponibilidade pode introduzir latência (como visto nos picos do ip .5) ou perda de resolução para o desktop alvo.

## 3. Etapa 2

## Mapeamento da rede e identificação de serviços e vulnerabilidades

### 3.1 tipos de varreduras e ferramentas utilizadas

[descrever os tipos de varreduras realizadas e as ferramentas usadas. exemplo:]

- **varredura de portas:**
  - ferramenta: [nome]
  - técnica: [tcp/udp scan, stealth scan, etc.]
- **identificação de serviços:**
  - ferramenta: [nome]
- **detecção de versões:**
  - ferramenta: [nome]
- **varredura de vulnerabilidades:**
  - ferramenta: [nome]

### 3.2 resultados e descobertas

#### alvo 1

**serviços em execução:**

| porta   | protocolo | serviço | versão   | estado           |
| ------- | --------- | -------- | --------- | ---------------- |
| [porta] | [tcp/udp] | [nome]   | [versão] | [aberta/fechada] |
| ...     | ...       | ...      | ...       | ...              |

**sistemas operacionais detectados:**

- sistema: [nome e versão]
- confiança: [nível de confiança da detecção]
- evidências: [explicar como foi detectado]

**superfície de ataque identificada:**

[listar e descrever os pontos de entrada potenciais encontrados]

**vulnerabilidades detectadas:**

| # | serviço/sistema afetado | descrição da falha | severidade                   | cvss          | referência (cve) |
| - | ------------------------ | -------------------- | ---------------------------- | ------------- | ----------------- |
| 1 | [serviço]               | [descrição]        | [crítica/alta/média/baixa] | [pontuação] | [cve-id]          |
| 2 | ...                      | ...                  | ...                          | ...           | ...               |

#### alvo 2

**serviços em execução:**

| porta   | protocolo | serviço | versão   | estado           |
| ------- | --------- | -------- | --------- | ---------------- |
| [porta] | [tcp/udp] | [nome]   | [versão] | [aberta/fechada] |
| ...     | ...       | ...      | ...       | ...              |

**sistemas operacionais detectados:**

- sistema: [nome e versão]
- confiança: [nível de confiança da detecção]
- evidências: [explicar como foi detectado]

**superfície de ataque identificada:**

[listar e descrever os pontos de entrada potenciais encontrados]

**vulnerabilidades detectadas:**

| # | serviço/sistema afetado | descrição da falha | severidade                   | cvss          | referência (cve) |
| - | ------------------------ | -------------------- | ---------------------------- | ------------- | ----------------- |
| 1 | [serviço]               | [descrição]        | [crítica/alta/média/baixa] | [pontuação] | [cve-id]          |
| 2 | ...                      | ...                  | ...                          | ...           | ...               |

---

## 4. etapa 3 - documentação, análise de impacto e propostas de correção/mitigação

### 4.1 vulnerabilidades do alvo 1

#### vulnerabilidade 1: [nome/título]

**descrição:**
[descrição detalhada da vulnerabilidade]

**análise do impacto:**
[explicar o que um atacante poderia fazer se explorasse essa falha. descrever cenários de ataque e possíveis consequências]

**proposta de correção/mitigação:**
[descrever soluções recomendadas para corrigir ou mitigar a vulnerabilidade. incluir passos específicos quando possível]

**prioridade:** [alta/média/baixa]

---

#### vulnerabilidade 2: [nome/título]

**descrição:**
[descrição detalhada da vulnerabilidade]

**análise do impacto:**
[explicar o que um atacante poderia fazer se explorasse essa falha]

**proposta de correção/mitigação:**
[descrever soluções recomendadas]

**prioridade:** [alta/média/baixa]

---

[repetir para cada vulnerabilidade encontrada no alvo 1]

### 4.2 vulnerabilidades do alvo 2

#### vulnerabilidade 1: [nome/título]

**descrição:**
[descrição detalhada da vulnerabilidade]

**análise do impacto:**
[explicar o que um atacante poderia fazer se explorasse essa falha]

**proposta de correção/mitigação:**
[descrever soluções recomendadas]

**prioridade:** [alta/média/baixa]

---

[repetir para cada vulnerabilidade encontrada no alvo 2]

---

## 5. conclusão

[resumo geral dos achados da análise de ambos os alvos]

**principais descobertas:**

- [ponto 1]
- [ponto 2]
- [ponto 3]

**vulnerabilidades críticas encontradas:** [número]

**recomendações gerais:**
[listar recomendações gerais de segurança baseadas nos achados]

**importância das correções propostas:**
[explicar a importância de implementar as correções e mitigações sugeridas]

---

## anexos

### anexo a - evidências e logs

[inserir screenshots, logs completos das ferramentas utilizadas, e outras evidências relevantes]

### anexo b - comandos executados

```
[comandos utilizados durante a análise]
```

---

## referências

[listar referências utilizadas, incluindo:]

- documentação das ferramentas
- cve databases consultadas
- artigos ou materiais de estudo
- outras referências relevantes
