# scripts de automação

documentação dos scripts de automação organizados por etapa.

## estrutura dos scripts

```
scripts/
├── etapa1/          # scripts da etapa 1 (obtenção de informações)
├── etapa2/          # scripts da etapa 2 (mapeamento e vulnerabilidades)
├── etapa3/          # scripts da etapa 3 (análise de impacto)
└── completos/       # scripts que executam tudo
```

## scripts por etapa

### etapa 1: obtenção de informações

**scripts/etapa1/coleta_informacoes.sh**
- coleta informações básicas (whois, dns, nslookup)
- uso: `./scripts/etapa1/coleta_informacoes.sh <alvo>`

---

### etapa 2: mapeamento e vulnerabilidades

**scripts/etapa2/varredura_nmap.sh**
- varreduras nmap completas
- uso: `./scripts/etapa2/varredura_nmap.sh <alvo>`

**scripts/etapa2/varredura_web.sh**
- varreduras de vulnerabilidades web
- uso: `./scripts/etapa2/varredura_web.sh <url>`

**scripts/etapa2/minha_parte_trabalho.sh**
- script completo para integrante do grupo
- uso: `./scripts/etapa2/minha_parte_trabalho.sh <alvo>`

**scripts/etapa2/analise_completa_alvo1.sh**
- análise completa do alvo 1
- uso: `./scripts/etapa2/analise_completa_alvo1.sh <ip>`

**scripts/etapa2/analise_completa_alvo2.sh**
- análise completa do alvo 2
- uso: `./scripts/etapa2/analise_completa_alvo2.sh <ip>`

---

### etapa 3: análise de impacto e preenchimento

**scripts/etapa3/preencher_etapa1.sh**
- executa etapa 1 e prepara resultados
- uso: `./scripts/etapa3/preencher_etapa1.sh <ip1> <ip2>`

**scripts/etapa3/preencher_etapa2.sh**
- executa etapa 2 e prepara resultados
- uso: `./scripts/etapa3/preencher_etapa2.sh <ip1> <ip2>`

**scripts/etapa3/preencher_etapa3.sh**
- gera análise da etapa 3
- uso: `./scripts/etapa3/preencher_etapa3.sh`

**scripts/etapa3/gerar_relatorio_resumo.sh**
- gera resumo dos resultados
- uso: `./scripts/etapa3/gerar_relatorio_resumo.sh`

---

### scripts completos

**scripts/completos/preencher_relatorio_completo.sh**
- executa todas as etapas em sequência
- uso: `./scripts/completos/preencher_relatorio_completo.sh <ip1> <ip2>`

**scripts/completos/descobrir_dispositivos_rede.sh**
- descobre dispositivos na rede
- uso: `./scripts/completos/descobrir_dispositivos_rede.sh`

**scripts/completos/verificar_instalacao.sh**
- verifica se ferramentas estão instaladas
- uso: `./scripts/completos/verificar_instalacao.sh`

---

## como usar

### tornar scripts executáveis

```bash
# todos os scripts
chmod +x scripts/**/*.sh

# ou por diretório
chmod +x scripts/etapa1/*.sh
chmod +x scripts/etapa2/*.sh
chmod +x scripts/etapa3/*.sh
chmod +x scripts/completos/*.sh
```

### executar scripts

```bash
# exemplo: executar script da etapa 1
./scripts/etapa1/coleta_informacoes.sh 192.168.1.1

# exemplo: executar script completo
./scripts/completos/preencher_relatorio_completo.sh 192.168.1.105 192.168.1.1
```

---

## recomendações

### para iniciantes

use scripts completos:
- `scripts/completos/preencher_relatorio_completo.sh` - executa tudo

### para aprendizado

use scripts individuais por etapa:
- `scripts/etapa1/` - etapa 1
- `scripts/etapa2/` - etapa 2
- `scripts/etapa3/` - etapa 3

### para trabalho em grupo

use scripts específicos:
- `scripts/etapa2/minha_parte_trabalho.sh` - para integrante

---

## requisitos

todos os scripts requerem:
- sistema operacional linux (kali linux, ubuntu, debian, ou wsl)
- ferramentas instaladas (nmap, nikto, whois, dig, curl)
- privilégios root para algumas varreduras (sudo)

---

## documentação adicional

- `guias/SEQUENCIA_COMANDOS_COMPLETA.md` - sequência completa de comandos
- `guias/guia_ferramentas.md` - guia de ferramentas
- `docs/TECNOLOGIAS_UTILIZADAS.md` - tecnologias utilizadas

---

**scripts organizados para facilitar o trabalho!**
