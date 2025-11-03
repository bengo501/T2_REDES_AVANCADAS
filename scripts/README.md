# scripts de análise

scripts utilitários para auxiliar na execução das análises de vulnerabilidade.

## requisitos

- sistema operacional linux ou wsl (windows subsystem for linux)
- ferramentas instaladas:
  - nmap
  - dig
  - whois
  - curl
  - (opcional) nikto, whatweb, dirb, gobuster

## como usar

### 1. tornar scripts executáveis

```bash
chmod +x scripts/*.sh
```

### 2. executar os scripts

#### coleta de informações (etapa 1)

```bash
./scripts/coleta_informacoes.sh exemplo.com
./scripts/coleta_informacoes.sh 192.168.1.1
```

este script executa:
- whois
- dns lookups (a, mx, ns, txt)
- nslookup

resultados salvos em: `resultados/<alvo>/`

#### varredura nmap (etapa 2)

```bash
./scripts/varredura_nmap.sh 192.168.1.1
```

este script executa:
- varredura rápida de portas comuns
- varredura completa com detecção de versões
- detecção de sistema operacional
- varredura udp
- (opcional) varredura de todas as portas

resultados salvos em: `resultados/<alvo>/`

#### varredura web (etapa 2)

```bash
./scripts/varredura_web.sh http://exemplo.com
```

este script executa:
- nikto (se disponível)
- whatweb (se disponível)
- análise de headers http
- (opcional) dirb ou gobuster

resultados salvos em: `resultados/<url>/`

#### gerar resumo

```bash
./scripts/gerar_relatorio_resumo.sh
```

consolida informações dos resultados para facilitar preenchimento do relatório.

## notas importantes

1. **sempre obtenha autorização** antes de executar varreduras
2. os scripts salvam resultados em `resultados/` (que está no .gitignore)
3. ajuste os scripts conforme necessário para seu ambiente
4. revise os resultados antes de incluir no relatório
5. alguns scripts podem demorar bastante tempo para completar

## uso em windows

se estiver usando windows:

1. **wsl (recomendado):**
   - instale wsl e ubuntu
   - execute os scripts dentro do wsl

2. **git bash:**
   - pode funcionar, mas algumas ferramentas podem não estar disponíveis

3. **máquina virtual linux:**
   - use kali linux ou similar
   - copie os scripts para a vm

## personalização

sinta-se livre para modificar os scripts conforme necessário:
- ajustar parâmetros das ferramentas
- adicionar novas ferramentas
- modificar formato de saída
- adicionar validações

## exemplo de uso completo

```bash
# etapa 1: coleta de informações
./scripts/coleta_informacoes.sh exemplo.com

# etapa 2: varredura de rede
./scripts/varredura_nmap.sh 192.168.1.1

# etapa 2: varredura web (se aplicável)
./scripts/varredura_web.sh http://exemplo.com

# gerar resumo
./scripts/gerar_relatorio_resumo.sh

# depois, preencher relatorio.md com os resultados
```

