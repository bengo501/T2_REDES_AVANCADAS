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

- **nome/identificação:** [descrever o primeiro alvo]
- **endereço ip:** [ip do primeiro alvo]
- **domínio (se aplicável):** [domínio, se houver]
- **escopo do teste:**
  - **dentro do escopo:**
    - [listar o que foi incluído na análise]
  - **fora do escopo:**
    - [listar o que foi excluído da análise]

#### Alvo 2

- **nome/identificação:** [descrever o segundo alvo]
- **endereço ip:** [ip do segundo alvo]
- **domínio (se aplicável):** [domínio, se houver]
- **escopo do teste:**
  - **dentro do escopo:**
    - [listar o que foi incluído na análise]
  - **fora do escopo:**
    - [listar o que foi excluído da análise]

### 1.2 justificativa da escolha

[explicar por que esses alvos foram escolhidos. exemplo: relevância para aprendizado, ambiente controlado, disponibilidade de acesso, etc.]

## 2. Etapa 1 

## Obtenção de informações

### 2.1 Métodos e ferramentas utilizadas

[descrever as técnicas e ferramentas utilizadas para coletar informações dos alvos. exemplo:]

- **ferramentas:**
  - [nome da ferramenta 1] - [descrição do uso]
  - [nome da ferramenta 2] - [descrição do uso]
- **técnicas:**
  - [técnica 1] - [descrição]
  - [técnica 2] - [descrição]

### 2.2 resultados

#### alvo 1

```
[inserir resultados da coleta de informações para o alvo 1]
[exemplo: informações de whois, dns lookup, etc.]
```

#### alvo 2

```
[inserir resultados da coleta de informações para o alvo 2]
[exemplo: informações de whois, dns lookup, etc.]
```

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
