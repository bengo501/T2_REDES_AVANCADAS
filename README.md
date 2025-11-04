# trabalho de análise de vulnerabilidades

trabalho prático da disciplina de redes de computadores avançadas - pucrs.

## objetivo

realizar e documentar análise de vulnerabilidades em dois alvos reais, identificando falhas de segurança em redes, sistemas ou aplicações.

## estrutura do projeto

```
T2_REDES_AVANCADAS/
├── README.md                    # este arquivo
├── enunciado.txt                # enunciado do trabalho
├── relatorio.md                 # template do relatório
│
├── docs/                        # documentação técnica
├── guias/                       # guias e tutoriais
├── scripts/                     # scripts de automação
├── templates/                   # templates e exemplos
├── resultados/                  # resultados das análises
└── temporarios/                 # arquivos temporários
```

## início rápido

### 1. instalar ferramentas

consulte: **[guias/instalação rápida](guias/INSTALACAO_RAPIDA.md)**

### 2. escolher guia

- **trabalhando sozinho?** → [guias/guia completo individual](guias/GUIA_COMPLETO_INDIVIDUAL.md)
- **trabalhando em grupo?** → [guias/guia para integrante](guias/GUIA_INTEGRANTE.md)

### 3. executar análise

```bash
# tornar scripts executáveis
chmod +x scripts/**/*.sh

# executar análise completa
./scripts/completos/preencher_relatorio_completo.sh [ip_alvo1] [ip_alvo2]
```

### 4. preencher relatório

consulte: **[guias/passo a passo preencher relatório](guias/PASSO_A_PASSO_PREENCHER_RELATORIO.md)**

## documentação

### documentação técnica

- **[tecnologias utilizadas](docs/TECNOLOGIAS_UTILIZADAS.md)** - lista completa de tecnologias
- **[explicação do desenvolvimento](docs/EXPLICACAO_DESENVOLVIMENTO.md)** - como a solução foi desenvolvida
- **[estrutura do projeto](docs/ESTRUTURA_PROJETO.md)** - organização da pasta

### guias e tutoriais

consulte: **[guias/índice de guias](guias/README.md)**

**guias principais:**
- [guia completo individual](guias/GUIA_COMPLETO_INDIVIDUAL.md) - guia completo
- [passo a passo completo](guias/PASSO_A_PASSO.md) - guia detalhado
- [instalação rápida](guias/INSTALACAO_RAPIDA.md) - instalar ferramentas
- [guia para integrante](guias/GUIA_INTEGRANTE.md) - para integrante do grupo
- [guia alvo doméstico](guias/GUIA_ALVO_DOMESTICO.md) - descobrir alvos
- [sequência de comandos completa](guias/SEQUENCIA_COMANDOS_COMPLETA.md) - comandos prontos

### scripts

consulte: **[scripts/documentação](scripts/README.md)**

**scripts principais:**
- `scripts/completos/preencher_relatorio_completo.sh` - executa tudo
- `scripts/completos/verificar_instalacao.sh` - verifica instalação
- `scripts/completos/descobrir_dispositivos_rede.sh` - descobre dispositivos

## etapas do trabalho

### etapa 1: obtenção de informações

- coleta de informações básicas dos alvos
- ferramentas: ping, dig, nslookup, whois
- scripts: `scripts/etapa1/`

### etapa 2: mapeamento e vulnerabilidades

- varredura de portas e serviços
- identificação de vulnerabilidades
- ferramentas: nmap, nikto, curl
- scripts: `scripts/etapa2/`

### etapa 3: análise de impacto

- análise de impacto de vulnerabilidades
- propostas de correção e mitigações
- scripts: `scripts/etapa3/`

## requisitos

### sistema operacional

- **kali linux** (recomendado) - todas as ferramentas já instaladas
- **ubuntu/debian** - instalar ferramentas manualmente
- **windows + wsl** - funcional, mas limitado

### ferramentas obrigatórias

- **nmap** - varredura de rede
- **nikto** - vulnerabilidades web
- **whois** - informações de registro
- **dig/nslookup** - consultas dns
- **curl** - requisições http

consulte: **[tecnologias utilizadas](docs/TECNOLOGIAS_UTILIZADAS.md)**

## estrutura de diretórios

### docs/
documentação técnica e explicações.

### guias/
guias e tutoriais passo a passo.

### scripts/
scripts de automação organizados por etapa:
- `etapa1/` - scripts da etapa 1
- `etapa2/` - scripts da etapa 2
- `etapa3/` - scripts da etapa 3
- `completos/` - scripts que executam tudo

### resultados/
resultados das análises organizados por alvo e etapa:
- `alvo1/etapa1/` - resultados etapa 1 do alvo 1
- `alvo1/etapa2/` - resultados etapa 2 do alvo 1
- `alvo2/etapa1/` - resultados etapa 1 do alvo 2
- `alvo2/etapa2/` - resultados etapa 2 do alvo 2

### templates/
templates e exemplos.

### temporarios/
arquivos temporários que podem ser deletados.

## como usar

### 1. preparar ambiente

1. ler [guias/instalação rápida](guias/INSTALACAO_RAPIDA.md)
2. instalar kali linux ou ferramentas
3. executar `scripts/completos/verificar_instalacao.sh`

### 2. escolher alvos

1. ler [guias/guia alvo doméstico](guias/GUIA_ALVO_DOMESTICO.md)
2. executar `scripts/completos/descobrir_dispositivos_rede.sh`
3. anotar ips dos alvos escolhidos

### 3. executar análise

1. seguir [guias/guia completo individual](guias/GUIA_COMPLETO_INDIVIDUAL.md)
2. ou executar `scripts/completos/preencher_relatorio_completo.sh`

### 4. preencher relatório

1. seguir [guias/passo a passo preencher relatório](guias/PASSO_A_PASSO_PREENCHER_RELATORIO.md)
2. preencher `relatorio.md` com os resultados

## links úteis

### bases de dados de vulnerabilidades

- **cve database:** https://cve.mitre.org/
- **nvd:** https://nvd.nist.gov/
- **exploit-db:** https://www.exploit-db.com/

### documentação de ferramentas

- **nmap:** https://nmap.org/docs.html
- **kali linux:** https://www.kali.org/docs/
- **nikto:** https://cirt.net/nikto2-docs/


**boa sorte com o trabalho!**
