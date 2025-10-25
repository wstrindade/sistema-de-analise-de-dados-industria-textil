# 📊 Sistema de Análise de Dados - Indústria Têxtil

## 🎯 Visão Geral

Sistema automatizado completo que:

1. **Utiliza base de dados pronta** (1 milhão de registros no `textil_dump.sql`)
2. **Importa para MySQL 8.0**
3. **Executa análises complexas** via SQL
4. **Exporta para Excel formatado** com dashboard interativo

### 📊 Dados Disponíveis

O sistema trabalha com **exatamente 1.000.000 de registros** (~100MB) distribuídos em:

| Tabela | Registros | Descrição |
|--------|-----------|-----------|
| 🏢 Fornecedores | 300 | Empresas fornecedoras de matéria-prima |
| 🧵 Rolos de Linha | 30.000 | Estoque (tipo, cor, metragem) |
| 🪡 Agulhas | 15.000 | Estoque (tipo, tamanho) |
| 🧶 Tecidos | 20.000 | Estoque (tipo, cor, metragem) |
| 👕 Produtos | 10.000 | Catálogo (camisetas, calças, vestidos) |
| 🏭 Produção | 150.000 | Registros de produção diária |
| 📦 Consumo de Materiais | 400.000 | Rastreamento de uso de materiais |
| 👤 Clientes | 30.000 | Clientes (PF e PJ) |
| 💰 Vendas | 340.000 | Transações de vendas |
| 👷 Funcionários | 500 | Funcionários cadastrados |
| 🔧 Manutenção de Máquinas | 4.200 | Registros de manutenções |

---

## 🛠️ Tecnologias

### Backend & Banco de Dados
- **Python 3.10+** - Linguagem principal
- **MySQL 8.0** - Banco de dados relacional
- **Docker** - Containerização do MySQL

### Bibliotecas Python

#### Análise de Dados
- **Pandas ≥2.2.0** - Manipulação e análise de dados
- **mysql-connector-python 8.2.0** - Conexão com MySQL

#### Exportação & Visualização
- **openpyxl 3.1.2** - Geração e formatação de arquivos Excel
- **Plotly 5.18.0** - Criação de gráficos interativos

### Ferramentas de Desenvolvimento
- **Just** - Task runner (similar ao Make)
- **Git** - Controle de versão

---

## 🏗️ Arquitetura

### Fluxo de Dados

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE DADOS                           │
└─────────────────────────────────────────────────────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│textil_dump   │────▶│  MySQL 8.0   │────▶│  Pandas      │
│    .sql      │     │  (Docker)    │     │  (Python)    │
│  (~100MB)    │     │              │     │              │
└──────────────┘     └──────────────┘     └──────────────┘
       │                     │                     │
   1M registros        Armazena dados      Analisa dados
   já prontos          em 11 tabelas       + processa SQL
       │                     │                     │
       ▼                     ▼                     ▼
   Importação         textil_industria      DataFrames
   via Docker         (1M registros)          │
                                                ▼
                                       ┌──────────────┐
                                       │   openpyxl   │
                                       │   (Python)   │
                                       └──────────────┘
                                                │
                                         Cria Excel
                                         formatado
                                                │
                                                ▼
                                       relatorio_*.xlsx
                                       📊 11 abas + Dashboard
```

---

## ⚡ Instalação Rápida

### Pré-requisitos

Certifique-se de ter instalado:

- **Python 3.10+**
- **Docker**
- **Git**
- **Just** (task runner)

### Setup Completo em 4 Comandos

```bash
# 1. Configurar ambiente Python
just configurar-pyenv

# 2. Iniciar MySQL no Docker
just iniciar-docker-mysql

# 3. Importar dados do textil_dump.sql (1M registros)
just configurar-mysql

# 4. Executar análise
just iniciar-aplicacao
```

**⏱️ Tempo total:** ~3 minutos

**📦 Pré-requisito:** O arquivo `textil_dump.sql` deve estar presente na raiz do projeto

---

## 🚀 Comandos Just

O projeto usa **Just** como task runner para simplificar operações comuns.

### 📋 Listar Comandos Disponíveis

```bash
just --list
```

ou simplesmente:

```bash
just
```

### Comandos Principais

#### 1️⃣ `just configurar-pyenv`

**O que faz:**
- Cria ambiente virtual Python (`venv/`)
- Instala todas as dependências do `requirements.txt`

**Quando usar:**
- Primeira execução do projeto
- Após clonar o repositório
- Após limpar o ambiente virtual

---

#### 2️⃣ `just iniciar-docker-mysql`

**O que faz:**
- Cria container Docker com MySQL 8.0
- Configura porta `3306`
- Define encoding UTF-8 (utf8mb4)
- Cria database `textil_industria`
- Aguarda 30 segundos para inicialização completa

**Quando usar:**
- Primeira execução do projeto
- Após remover o container MySQL
- Para recriar banco zerado

**Credenciais:**
- **Host:** `localhost`
- **Porta:** `3306`
- **Usuário:** `root`
- **Senha:** `root123`
- **Database:** `textil_industria`

---

#### 3️⃣ `just configurar-mysql`

**O que faz:**
- Importa o arquivo `textil_dump.sql` para o MySQL
- Cria todas as 11 tabelas
- Insere 1 milhão de registros

**Quando usar:**
- Após gerar `textil_dump.sql`
- Para reimportar dados
- Após limpar o banco

```bash
just configurar-mysql
```

**Pré-requisito:**
- MySQL rodando (`just iniciar-docker-mysql`)
- Arquivo `textil_dump.sql` existir

**⏱️ Tempo estimado:** 30-60 segundos para 1M registros

---

#### 4️⃣ `just iniciar-aplicacao`

**O que faz:**
- Ativa o ambiente virtual
- Executa `analise_dados.py`
- Gera relatório Excel com todas as análises

**Quando usar:**
- Após importar dados no MySQL
- Para gerar novo relatório
- Execução diária/periódica

```bash
just iniciar-aplicacao
```

**Saída:**
```
relatorio_textil_20251024_143022.xlsx
```

---

### 🔄 Workflow Completo

```bash
# Setup inicial (apenas uma vez)
just configurar-pyenv
just iniciar-docker-mysql

# Importar dados do textil_dump.sql
just configurar-mysql

# Executar análise (quantas vezes quiser)
just iniciar-aplicacao
```

**📦 Nota:** Certifique-se de ter o arquivo `textil_dump.sql` na raiz do projeto antes de executar `just configurar-mysql`


---

## 📦 Base de Dados

### Arquivo textil_dump.sql

O projeto inclui um arquivo SQL completo com **1 milhão de registros** distribuídos em 11 tabelas.

**Arquivo:** `textil_dump.sql` (~100MB)

**Conteúdo:**
- ✅ Dados sintéticos realistas
- ✅ 1.000.000 de registros
- ✅ 11 tabelas relacionadas
- ✅ Pronto para importação

### Estrutura do Banco

**Database:** `textil_industria`

**Tabelas:**

1. `fornecedores` - Fornecedores de matéria-prima
2. `rolos_linha` - Estoque de linhas
3. `agulhas` - Estoque de agulhas
4. `tecidos` - Estoque de tecidos
5. `produtos` - Catálogo de produtos
6. `producao` - Registros de produção
7. `consumo_materiais` - Rastreamento de materiais
8. `clientes` - Base de clientes
9. `vendas` - Transações de vendas
10. `funcionarios` - Cadastro de funcionários
11. `manutencao_maquinas` - Manutenções realizadas

---

## 📊 Análise de Dados

### Executar Análise

```bash
# Via Just
just iniciar-aplicacao

```

### 🎯 Análises Disponíveis

#### 📈 Vendas
- ✅ Tamanhos mais vendidos por categoria
- ✅ Cores mais vendidas
- ✅ Produtos mais lucrativos
- ✅ Análise por forma de pagamento
- ✅ Top 20 clientes

#### 🏭 Produção
- ✅ Turnos com maior produção (manhã, tarde, noite)
- ✅ Produção por qualidade (A, B, C)
- ✅ Tempo médio de produção por turno
- ✅ Setor mais produtivo

#### 🧵 Materiais
- ✅ Tecidos mais usados (tipo e cor)
- ✅ Agulhas mais utilizadas
- ✅ Linhas mais consumidas
- ✅ Estoque atual consolidado

#### 🔧 Manutenção
- ✅ Manutenções por tipo (preventiva, corretiva, emergencial)
- ✅ Custo total e médio
- ✅ Tempo de parada por tipo
- ✅ **Manutenção mais cara** 

---

## 📊 Dashboard Excel

### Arquivo Gerado

```
relatorio_textil_YYYYMMDD_HHMMSS.xlsx
```

**Exemplo:** `relatorio_textil_20251024_143022.xlsx`

### 📂 Abas do Relatório

1. **📊 Dashboard** ⭐ - Visão executiva completa
2. **Vendas Por Produto** - Detalhamento de vendas
3. **Produção Por Turno** - Análise de turnos
4. **Tecidos Mais Usados** - Consumo de tecidos
5. **Agulhas Mais Usadas** - Consumo de agulhas
6. **Linhas Mais Usadas** - Consumo de linhas
7. **Manutenção Por Tipo** - Análise de manutenções
8. **Produção Por Setor** - Performance por setor
9. **Vendas Por Forma Pagamento** - Análise de pagamentos
10. **Estoque Atual** - Consolidado de estoque
11. **Top Clientes** - Top 20 maiores compradores

### 🎨 Dashboard Principal

O Dashboard contém:

#### 📈 Resumo Geral
```
Total de Vendas:        340.000 vendas
Total de Produções:     150.000 produções
Total de Clientes:      30.000 clientes
Total de Funcionários:  500 funcionários
Total de Fornecedores:  300 fornecedores
```

#### 💰 Financeiro
```
Valor Total Vendas:     R$ 12.345.678,90
Custo Total Manutenção: R$ 610.500,00
```

#### 🔧 Manutenção Mais Cara
```
Tipo:                   Preventiva
Custo Total:            R$ 305.250,00
Tempo de Parada Total:  1.234 horas
```

#### 🏆 Top 3 Clientes
```
1º - Cliente A:         R$ 234.567,89
2º - Cliente B:         R$ 198.765,43
3º - Cliente C:         R$ 176.543,21
```

#### 💳 Top 3 Formas de Pagamento
```
1º - PIX:               145.000 vendas | R$ 5.234.567,89
2º - Cartão de Crédito: 98.000 vendas  | R$ 3.456.789,01
3º - Dinheiro:          67.000 vendas  | R$ 2.345.678,90
```

#### 🕐 Top 3 Turnos de Produção
```
1º - Manhã:             52.500 produções
2º - Tarde:             50.100 produções
3º - Noite:             47.400 produções
```

### 📊 Gráficos de Pizza Interativos

**3 gráficos configuráveis (Top 1 a Top 5):**

1. **🏆 Top 5 Clientes**
   - Mostra os 5 maiores compradores
   - Percentual de participação
   - Valores em R$

2. **💳 Top 5 Formas de Pagamento**
   - 5 formas mais usadas
   - Percentual de uso
   - Quantidade de transações

3. **🕐 Top 3 Turnos de Produção**
   - 3 turnos (manhã, tarde, noite)
   - Percentual de produção
   - Unidades produzidas



## 🎨 Exemplos de Insights

### Vendas

```
📈 Tamanhos Mais Vendidos:
├─ M:  34.2% (116.000 vendas)
├─ G:  28.5% (97.000 vendas)
└─ P:  22.1% (75.000 vendas)

🎨 Cores Mais Vendidas:
├─ Preto:  R$ 2.500.000,00
├─ Branco: R$ 2.100.000,00
└─ Azul:   R$ 1.800.000,00

💳 Formas de Pagamento:
├─ PIX:              42.6% (R$ 5.234.567,89)
├─ Cartão Crédito:   28.8% (R$ 3.456.789,01)
└─ Dinheiro:         19.7% (R$ 2.345.678,90)
```

### Produção

```
🏭 Turnos Mais Produtivos:
├─ Manhã: 35.0% (52.500 unidades)
├─ Tarde: 33.4% (50.100 unidades)
└─ Noite: 31.6% (47.400 unidades)

✅ Qualidade:
├─ A: 60% (90.000 unidades)
├─ B: 30% (45.000 unidades)
└─ C: 10% (15.000 unidades)

⏱️ Tempo Médio de Produção:
├─ Manhã: 2.3 horas
├─ Tarde: 2.5 horas
└─ Noite: 2.8 horas
```

### Manutenção

```
🔧 Tipo de Manutenção:
├─ Preventiva:   45% (1.890 registros) | R$ 150.000,00
├─ Corretiva:    40% (1.680 registros) | R$ 280.000,00
└─ Emergencial:  15% (630 registros)   | R$ 180.000,00

💰 Custo Total: R$ 610.000,00

⏱️ Tempo de Parada:
├─ Média:  4.5 horas por manutenção
└─ Total:  18.500 horas

💸 Manutenção Mais Cara:
└─ Preventiva: R$ 305.250,00 (1.234 horas)
```
