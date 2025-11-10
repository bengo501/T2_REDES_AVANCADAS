# instalação rápida - guia passo a passo

este documento fornece um guia rápido e direto de instalação dos softwares necessários.

## opção 1: kali linux (recomendado - mais fácil)

### passo 1: instalar virtualbox

1. baixar virtualbox: https://www.virtualbox.org/wiki/Downloads
2. instalar virtualbox (siga o assistente de instalação)
3. abrir virtualbox

### passo 2: baixar kali linux

1. acessar: https://www.kali.org/get-kali/
2. escolher: **kali linux virtual machines**
3. escolher: **virtualbox 64-bit** (ou vmware se preferir)
4. baixar o arquivo .ova (pode demorar, arquivo grande ~3gb)

### passo 3: importar kali linux no virtualbox

1. abrir virtualbox
2. menu: arquivo > importar aparelho virtual
3. selecionar arquivo .ova baixado
4. clicar em "importar" (pode demorar alguns minutos)
5. aguardar finalizar

### passo 4: configurar e iniciar kali linux

1. selecionar kali linux na lista de máquinas virtuais
2. clicar em "configurações"
3. sistema > memória: configurar para 2048 mb (2gb) ou mais
4. salvar e iniciar kali linux

### passo 5: primeiro acesso

1. quando iniciar, usar credenciais padrão:
   - usuário: `kali`
   - senha: `kali`
2. escolher idioma e layout de teclado
3. aguardar configuração inicial

### passo 6: verificar ferramentas

abrir terminal e verificar:

```bash
nmap --version
nikto --version
whois --version
dig --version
```

**se todos comandos funcionarem, pronto!**

### passo 7: atualizar sistema (opcional)

```bash
sudo apt update
sudo apt upgrade -y
```

---

## opção 2: wsl + ubuntu + ferramentas (windows)

### passo 1: instalar wsl

1. abrir powershell como **administrador**
2. executar comando:

```powershell
wsl --install
```

3. reiniciar o computador quando solicitado

### passo 2: instalar ubuntu

1. após reiniciar, abrir microsoft store
2. procurar "ubuntu"
3. instalar "ubuntu" (versão mais recente)
4. abrir ubuntu (pode demorar na primeira vez)
5. criar usuário e senha quando solicitado

### passo 3: atualizar sistema

abrir ubuntu e executar:

```bash
sudo apt update
sudo apt upgrade -y
```

### passo 4: instalar ferramentas

```bash
sudo apt install nmap nikto whois dnsutils curl -y
```

### passo 5: verificar instalação

```bash
nmap --version
nikto --version
whois --version
dig --version
```

**se todos comandos funcionarem, pronto!**

---

## opção 3: instalar ferramentas individualmente (ubuntu/debian)

se você já tem linux instalado:

### passo 1: atualizar sistema

```bash
sudo apt update
sudo apt upgrade -y
```

### passo 2: instalar ferramentas principais

```bash
sudo apt install nmap nikto whois dnsutils curl -y
```

### passo 3: instalar ferramentas adicionais (opcional)

```bash
sudo apt install wireshark tcpdump metasploit-framework -y
```

### passo 4: verificar instalação

```bash
nmap --version
nikto --version
whois --version
dig --version
```

---

## opção 4: macos

### passo 1: instalar homebrew (se ainda não tiver)

1. abrir o terminal.
2. executar:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. seguir as instruções exibidas (o script pedirá senha do usuário).
4. ao final, adicionar o homebrew ao `PATH` conforme instruções mostradas (por exemplo, rodando `echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile` no mac com chip m1/m2).

### passo 2: atualizar homebrew

```bash
brew update
```

### passo 3: instalar ferramentas necessárias

```bash
brew install nmap nikto whois bind curl
```

> o pacote `bind` fornece os utilitários `dig` e `nslookup`.

### passo 4: verificar instalação

```bash
nmap --version
nikto --version
whois --version
dig --version
```

se todos os comandos retornarem versão, o ambiente está pronto.

### passo 5: ferramentas opcionais

```bash
brew install wireshark tcpdump metasploit
```

wireshark exige permissões adicionais para captura sem sudo; siga as instruções exibidas após a instalação, se necessário.

---

## verificação rápida

### script de verificação

salvar como `verificar_instalacao.sh`:

```bash
#!/bin/bash

echo "=== verificando ferramentas instaladas ==="
echo ""

COMANDOS=("nmap" "nikto" "whois" "dig" "curl")

for cmd in "${COMANDOS[@]}"; do
    if command -v $cmd >/dev/null 2>&1; then
        echo "✅ $cmd: instalado"
        $cmd --version 2>/dev/null | head -1
    else
        echo "❌ $cmd: não encontrado"
    fi
    echo ""
done

echo "=== verificação concluída ==="
```

### executar verificação

```bash
chmod +x verificar_instalacao.sh
./verificar_instalacao.sh
```

---

## resumo rápido

### opção 1: kali linux (recomendado)

1. instalar virtualbox
2. baixar kali linux .ova
3. importar no virtualbox
4. iniciar e usar (usuário: kali, senha: kali)
5. verificar: `nmap --version`

### opção 2: wsl + ubuntu

1. executar: `wsl --install` (powershell como admin)
2. reiniciar
3. instalar ubuntu da microsoft store
4. executar: `sudo apt install nmap nikto whois dnsutils curl -y`
5. verificar: `nmap --version`

---

## problemas comuns

### problema: "comando não encontrado"

**solução:** ferramenta não instalada. instalar com:

```bash
sudo apt install <nome_da_ferramenta>
```

### problema: "permissão negada"

**solução:** precisa usar sudo:

```bash
sudo <comando>
```

### problema: virtualbox não abre

**solução:** verificar se virtualização está habilitada no bios.

### problema: wsl não instala

**solução:** verificar se windows está atualizado. wsl requer windows 10/11 atualizado.

---

## após instalação

depois que tudo estiver instalado:

1. **ler:** `GUIA_INTEGRANTE.md`
2. **escolher:** sua parte do trabalho
3. **executar:** comandos ou scripts fornecidos
4. **documentar:** resultados no relatório

---

**boa instalação!**
