# estrutura do projeto

documento explicando a organização da pasta do trabalho.

## estrutura de diretórios

```
T2_REDES_AVANCADAS/
│
├── README.md                          # visão geral do projeto
├── enunciado.txt                      # enunciado do trabalho
├── relatorio.md                       # template do relatório
│
├── docs/                              # documentação principal
│   ├── TECNOLOGIAS_UTILIZADAS.md      # tecnologias utilizadas
│   ├── EXPLICACAO_DESENVOLVIMENTO.md  # explicação do desenvolvimento
│   └── ESTRUTURA_PROJETO.md           # este arquivo
│
├── guias/                             # guias e tutoriais
│   ├── README.md                      # índice dos guias
│   ├── PASSO_A_PASSO.md               # guia completo passo a passo
│   ├── GUIA_COMPLETO_INDIVIDUAL.md    # guia para trabalho individual
│   ├── GUIA_INTEGRANTE.md             # guia para integrante do grupo
│   ├── GUIA_ALVO_DOMESTICO.md         # guia para alvos domésticos
│   ├── INSTALACAO_RAPIDA.md           # guia de instalação rápida
│   ├── PASSO_A_PASSO_PREENCHER_RELATORIO.md  # guia para preencher relatório
│   ├── SEQUENCIA_COMANDOS_COMPLETA.md # sequência completa de comandos
│   ├── guia_ferramentas.md            # guia de ferramentas
│   └── exemplo_comandos.md             # exemplo de comandos
│
├── scripts/                           # scripts de automação
│   ├── README.md                      # documentação dos scripts
│   │
│   ├── etapa1/                        # scripts da etapa 1
│   │   └── coleta_informacoes.sh
│   │
│   ├── etapa2/                        # scripts da etapa 2
│   │   ├── varredura_nmap.sh
│   │   ├── varredura_web.sh
│   │   ├── minha_parte_trabalho.sh
│   │   └── analise_completa_alvo1.sh
│   │   └── analise_completa_alvo2.sh
│   │
│   ├── etapa3/                        # scripts da etapa 3
│   │   ├── preencher_etapa1.sh
│   │   ├── preencher_etapa2.sh
│   │   ├── preencher_etapa3.sh
│   │   └── gerar_relatorio_resumo.sh
│   │
│   └── completos/                      # scripts completos
│       ├── preencher_relatorio_completo.sh
│       ├── descobrir_dispositivos_rede.sh
│       └── verificar_instalacao.sh
│
├── templates/                         # templates e exemplos
│   └── exemplo_relatorio.md           # exemplo de relatório preenchido
│
├── resultados/                         # resultados das análises
│   ├── alvo1/
│   │   ├── etapa1/                    # resultados da etapa 1
│   │   │   ├── ping_*.txt
│   │   │   ├── dns_reverso_*.txt
│   │   │   └── nslookup_*.txt
│   │   └── etapa2/                     # resultados da etapa 2
│   │       ├── scan_rapido_*.txt
│   │       ├── scan_completo_*.txt
│   │       ├── scan_os_*.txt
│   │       ├── scan_udp_*.txt
│   │       ├── scan_vuln_*.txt
│   │       ├── nikto_*.txt
│   │       └── headers_*.txt
│   └── alvo2/
│       ├── etapa1/                     # resultados da etapa 1
│       └── etapa2/                     # resultados da etapa 2
│
├── temporarios/                       # arquivos temporários
│   ├── scan_dispositivos.txt
│   ├── scan_os.txt
│   └── scan_udp.txt
│
└── .gitignore                          # arquivos ignorados pelo git
```

## descrição dos diretórios

### raiz do projeto

- **README.md:** visão geral do projeto e instruções iniciais
- **enunciado.txt:** enunciado original do trabalho
- **relatorio.md:** template do relatório a ser preenchido

### docs/

documentação técnica e explicações:
- **TECNOLOGIAS_UTILIZADAS.md:** lista completa de tecnologias
- **EXPLICACAO_DESENVOLVIMENTO.md:** como a solução foi desenvolvida
- **ESTRUTURA_PROJETO.md:** este arquivo

### guias/

guias e tutoriais passo a passo:
- **README.md:** índice dos guias
- **PASSO_A_PASSO.md:** guia completo e detalhado
- **GUIA_COMPLETO_INDIVIDUAL.md:** guia para trabalho individual
- **GUIA_INTEGRANTE.md:** guia para integrante do grupo
- **GUIA_ALVO_DOMESTICO.md:** guia para descobrir e analisar alvos domésticos
- **INSTALACAO_RAPIDA.md:** guia rápido de instalação
- **PASSO_A_PASSO_PREENCHER_RELATORIO.md:** guia para preencher relatório
- **SEQUENCIA_COMANDOS_COMPLETA.md:** sequência completa de comandos
- **guia_ferramentas.md:** referência de ferramentas
- **exemplo_comandos.md:** exemplos de comandos

### scripts/

scripts de automação organizados por etapa:

#### scripts/etapa1/
scripts para obtenção de informações:
- **coleta_informacoes.sh:** coleta informações básicas (whois, dns, etc.)

#### scripts/etapa2/
scripts para mapeamento e vulnerabilidades:
- **varredura_nmap.sh:** varreduras nmap
- **varredura_web.sh:** varreduras de vulnerabilidades web
- **minha_parte_trabalho.sh:** script completo para integrante
- **analise_completa_alvo1.sh:** análise completa do alvo 1
- **analise_completa_alvo2.sh:** análise completa do alvo 2

#### scripts/etapa3/
scripts para análise de impacto e preenchimento:
- **preencher_etapa1.sh:** executa etapa 1 e prepara resultados
- **preencher_etapa2.sh:** executa etapa 2 e prepara resultados
- **preencher_etapa3.sh:** gera análise da etapa 3
- **gerar_relatorio_resumo.sh:** gera resumo dos resultados

#### scripts/completos/
scripts que executam tudo:
- **preencher_relatorio_completo.sh:** executa todas as etapas
- **descobrir_dispositivos_rede.sh:** descobre dispositivos na rede
- **verificar_instalacao.sh:** verifica se ferramentas estão instaladas

### templates/

templates e exemplos:
- **exemplo_relatorio.md:** exemplo de relatório preenchido

### resultados/

resultados das análises organizados por alvo e etapa:
- **alvo1/etapa1/:** resultados da etapa 1 do alvo 1
- **alvo1/etapa2/:** resultados da etapa 2 do alvo 1
- **alvo2/etapa1/:** resultados da etapa 1 do alvo 2
- **alvo2/etapa2/:** resultados da etapa 2 do alvo 2

### temporarios/

arquivos temporários que podem ser deletados:
- arquivos de scan soltos
- arquivos de teste

## como usar a estrutura

### para começar o trabalho

1. **ler primeiro:**
   - `README.md` - visão geral
   - `guias/README.md` - índice dos guias
   - `guias/GUIA_COMPLETO_INDIVIDUAL.md` - guia completo

2. **preparar ambiente:**
   - `guias/INSTALACAO_RAPIDA.md` - instalar ferramentas
   - `scripts/completos/verificar_instalacao.sh` - verificar instalação

3. **executar análise:**
   - `scripts/completos/preencher_relatorio_completo.sh` - executar tudo
   - ou usar scripts individuais em `scripts/etapa1/`, `scripts/etapa2/`, etc.

4. **preencher relatório:**
   - `relatorio.md` - template do relatório
   - `guias/PASSO_A_PASSO_PREENCHER_RELATORIO.md` - guia para preencher

### para encontrar algo específico

- **quer aprender sobre ferramentas?** → `guias/guia_ferramentas.md`
- **quer ver comandos?** → `guias/SEQUENCIA_COMANDOS_COMPLETA.md`
- **quer ver tecnologias?** → `docs/TECNOLOGIAS_UTILIZADAS.md`
- **quer ver resultados?** → `resultados/`
- **quer executar scripts?** → `scripts/`

## convenções de nomenclatura

### arquivos de resultados

formato: `[tipo]_[timestamp].txt`
- exemplo: `scan_completo_20251104_105848.txt`
- timestamp: `YYYYMMDD_HHMMSS`

### scripts

formato: `[função]_[etapa].sh`
- exemplo: `preencher_etapa1.sh`
- exemplo: `varredura_nmap.sh`

### documentação

formato: `[NOME]_[DESCRICAO].md`
- exemplo: `GUIA_COMPLETO_INDIVIDUAL.md`
- exemplo: `PASSO_A_PASSO.md`

## manutenção da estrutura

### arquivos temporários

arquivos em `temporarios/` podem ser deletados:
- `scan_dispositivos.txt`
- `scan_os.txt`
- `scan_udp.txt`

### resultados antigos

resultados antigos em `resultados/` podem ser mantidos ou deletados conforme necessário.

### scripts

scripts em `scripts/` não devem ser deletados, mas podem ser modificados conforme necessário.

## dicas de organização

1. **manter resultados organizados:**
   - usar timestamps nos nomes de arquivos
   - manter estrutura por alvo e etapa

2. **documentar mudanças:**
   - atualizar este arquivo se a estrutura mudar
   - comentar scripts quando modificados

3. **limpar arquivos temporários:**
   - deletar arquivos em `temporarios/` periodicamente
   - manter apenas resultados relevantes

4. **fazer backup:**
   - fazer backup de `resultados/` antes de limpar
   - fazer backup de `relatorio.md` quando estiver preenchido

---

**estrutura criada para facilitar o trabalho!**

