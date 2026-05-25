# 📦 Análise Curva ABC — Portfólio de Logística

Primeiro projeto de portfólio em análise de dados utilizando SQL e SQLite para classificação ABC de produtos com base em faturamento real exportado de um ERP (Microsiga Protheus).

A análise cobre ~20.000 transações de vendas, 498 produtos e o período de janeiro de 2018 a abril de 2021 — com faturamento total de R$ 2,71 bilhões.

> ⚠️ **Nota sobre privacidade:** Os nomes reais dos clientes foram substituídos pelo formato `Cliente_ID` antes da publicação. Todas as demais informações refletem a estrutura original dos dados.

---

## 📋 Índice

1. [Contexto do Negócio](#-contexto-do-negócio)
2. [Objetivo](#-objetivo)
3. [Dataset](#-dataset)
4. [Estrutura do Projeto](#-estrutura-do-projeto)
5. [Execução do Projeto](#-execução-do-projeto)
6. [Metodologia da Curva ABC](#-metodologia-da-curva-abc)
7. [Principais Resultados](#-principais-resultados)
8. [Insights de Negócio](#-insights-de-negócio)
9. [Técnicas SQL Aplicadas](#-técnicas-sql-aplicadas)
10. [Tecnologias Utilizadas](#-tecnologias-utilizadas)
11. [Principais Aprendizados](#-principais-aprendizados)
12. [Autor](#-autor)

---

## 📌 Contexto do Negócio

Na gestão de estoques e cadeia de suprimentos, nem todos os produtos merecem o mesmo nível de atenção. Gerenciar 498 SKUs com o mesmo esforço desperdiça tempo, dinheiro e espaço no armazém — e é exatamente aí que a análise de dados entra como aliada da operação.

A **Curva ABC** responde a uma pergunta direta:

> _Quais produtos realmente movem o negócio e quais estão apenas ocupando prateleira?_

Este projeto aplica esse método a dados reais de vendas, cobrindo o período de janeiro de 2018 a abril de 2021. Os números são reais. As conclusões, também.

---

## 🎯 Objetivo

- Construir uma classificação ABC baseada no faturamento dos produtos
- Identificar categorias mais relevantes financeiramente
- Analisar concentração de receita e comportamento de margem por classe
- Explorar a evolução da classificação ao longo dos anos (2018 → 2021)
- Praticar modelagem e análise de dados utilizando SQL puro

---

## 🗂 Dataset

| Arquivo                       | Descrição                                                 | Linhas |
| ----------------------------- | --------------------------------------------------------- | ------ |
| `data/fact_sales.csv`         | Transações de vendas — uma linha por item vendido         | 19.999 |
| `data/dim_products.csv`       | Cadastro de produtos — um produto por linha               | 498    |
| `data/dataset_logistica.xlsx` | As duas tabelas acima em um único arquivo Excel formatado | —      |

**Fonte:** ERP Microsiga Protheus · **Período:** 01/01/2018 a 30/04/2021

### Dicionário de Dados — `fact_sales`

| Coluna          | Tipo    | Descrição                                       |
| --------------- | ------- | ----------------------------------------------- |
| `order_date`    | TEXT    | Data em que o pedido foi realizado (AAAA-MM-DD) |
| `sale_number`   | TEXT    | Número único que identifica a venda no ERP      |
| `product_id`    | INTEGER | Chave estrangeira → dim_products.product_id     |
| `seller_id`     | INTEGER | Código do vendedor                              |
| `seller_name`   | TEXT    | Nome do vendedor                                |
| `customer_id`   | INTEGER | Código do cliente (anonimizado)                 |
| `customer_name` | TEXT    | Nome do cliente no formato `Cliente_ID`         |
| `unit_id`       | INTEGER | Código da filial                                |
| `unit_name`     | TEXT    | Nome da filial (ex: Filial 1, Matriz)           |
| `quantity`      | REAL    | Quantidade de itens vendidos                    |
| `unit_price`    | REAL    | Preço de venda por unidade (R$)                 |
| `unit_cost`     | REAL    | Custo unitário do produto (R$)                  |
| `total_revenue` | REAL    | Faturamento total = quantity × unit_price       |
| `total_cost`    | REAL    | Custo total = quantity × unit_cost              |

### Dicionário de Dados — `dim_products`

| Coluna         | Tipo    | Descrição                                                    |
| -------------- | ------- | ------------------------------------------------------------ |
| `product_id`   | INTEGER | Código único do produto (Chave Primária)                     |
| `product_name` | TEXT    | Nome completo do produto                                     |
| `category`     | TEXT    | Categoria principal (Computadores, Audios, Videos, Smart TV) |
| `subcategory`  | TEXT    | Subcategoria (ex: Notebook, Projetor)                        |
| `brand`        | TEXT    | Marca do produto                                             |

---

## 🏗 Estrutura do Projeto

```text
curva-abc-logistica/
│
├── data/
│   ├── dataset_logistica.xlsx
│   ├── dim_products.csv
│   └── fact_sales.csv
│
├── database/
│   └── curva_abc.db
│
├── docs/
│   └── imagem/
│       ├── 01_Confirmar a criação das tabelas.png
│       ├── 01.1_Resultado da query_tabelas.png
│       ├── 02_importação dos dados brutos das tabelas.png
│       ├── 03_Contar todas as linhas das tabelas.png
│       ├── 03_Resultado da contagem.png
│       ├── 04_Curva ABC por participação.png
│       ├── 05_Comparativo por margem.png
│       └── 06_Comparação por Ano.png
│
├── sql/
│   ├── 01_criar_tabelas.sql
│   ├── 02_validacao_dados.sql
│   ├── 03_analise_exploratoria.sql
│   ├── 04_Viewsclassificacao_abc.sql
│   └── 05_resultados.sql
│
└── README.md
```

---

## ⚙ Execução do Projeto

### 1. Criação das tabelas no SQLite

A primeira etapa consiste na criação das duas tabelas que vão estruturar o banco de dados: `dim_products` e `fact_sales`.

![Criação das tabelas](docs/imagem/01_Confirmar%20a%20criação%20das%20tabelas.png)

![Resultado da criação](docs/imagem/01.1_Resultado%20da%20query_tabelas.png)

---

### 2. Importação dos arquivos CSV

Com as tabelas criadas, os arquivos CSV foram importados para o banco SQLite usando o parâmetro `--skip 1` para ignorar o cabeçalho.

![Importação dos dados](docs/imagem/02_importação%20dos%20dados%20brutos%20das%20tabelas.png)

---

### 3. Validação da importação

Após a carga, foram realizadas validações para confirmar a quantidade de registros e a integridade dos dados importados.

![Validação de linhas](docs/imagem/03_Contar%20todas%20as%20linhas%20das%20tabelas.png)

![Resultado da contagem](docs/imagem/03_Resultado%20da%20contagem.png)

---

## 📊 Metodologia da Curva ABC

A Curva ABC aplica o **Princípio de Pareto** para classificar produtos conforme sua relevância financeira. Na prática de estoque, isso responde a uma pergunta direta: onde concentrar energia e recursos?

```text
1. Somar o faturamento total por produto (período completo)
2. Ordenar os produtos do maior para o menor faturamento
3. Calcular a participação individual de cada produto no total (%)
4. Calcular o percentual acumulado crescente (função de janela)
5. Atribuir a classe com base no limite acumulado
```

### Critérios de Classificação

| Classe | Critério                         | Prioridade          |
| ------ | -------------------------------- | ------------------- |
| **A**  | Até 80% do faturamento acumulado | 🔴 Crítica          |
| **B**  | De 80% até 95%                   | 🟡 Importante       |
| **C**  | Acima de 95%                     | 🟢 Baixa prioridade |

---

## 📈 Principais Resultados

### Classificação ABC — Visão Geral

| Classe | Produtos | Faturamento Total (R$) | Participação |
| ------ | -------- | ---------------------- | ------------ |
| A      | 34       | R$ 2.180.528.935,11    | 80,38%       |
| B      | 109      | R$ 407.362.823,60      | 15,08%       |
| C      | 355      | R$ 122.521.882,87      | 4,54%        |

![Curva ABC por participação](docs/imagem/04_Curva%20ABC%20por%20participação.png)

---

### Resultado Financeiro Consolidado

| Indicador         | Valor             |
| ----------------- | ----------------- |
| Faturamento Total | R$ 2,71 bilhões   |
| Custo Total       | R$ 708,95 milhões |
| Lucro Bruto       | R$ 2,00 bilhões   |
| Margem Bruta      | 73,84%            |

---

### Participação por Categoria

| Categoria    | Participação | Classe Predominante |
| ------------ | ------------ | ------------------- |
| Computadores | 60,71%       | Classe A            |
| Videos       | 23,42%       | Classes A e B       |
| Audios       | 10,14%       | Classe C            |
| Smart TV     | 5,74%        | Classes B e C       |

---

### Margem Bruta por Classe

| Classe | Margem |
| ------ | ------ |
| A      | 74,67% |
| B      | 70,85% |
| C      | 69,04% |

![Comparativo por margem](docs/imagem/05_Comparativo%20por%20margem.png)

---

### Evolução Anual da Classificação ABC

| Ano  | Pedidos | Faturamento      |
| ---- | ------- | ---------------- |
| 2018 | 3.195   | R$ 608,4 milhões |
| 2019 | 7.272   | R$ 1,30 bilhão   |
| 2020 | 3.098   | R$ 623,2 milhões |
| 2021 | 987     | R$ 176,7 milhões |

![Comparação por Ano](docs/imagem/06_Comparação%20por%20Ano.png)

---

## 🔍 Insights de Negócio

**1. A Classe A é pequena demais para ser ignorada**
Apenas 34 SKUs — menos de 7% do catálogo — sustentam 80,38% da receita da empresa. Uma ruptura de estoque nesses itens não seria um inconveniente: seria um problema financeiro imediato e de grande magnitude. Essa constatação, por si só, já justifica toda a análise.

**2. Computadores carregam o portfólio**
Com 60,71% do faturamento total, a categoria de Computadores é o coração financeiro da operação. Qualquer decisão de compra ou reposição precisa passar por aqui primeiro.

**3. A Classe C está inchando o armazém**
355 produtos ocupam 71,3% da variedade do catálogo, mas geram juntos apenas 4,54% do faturamento. Cada um desses itens ocupa espaço físico, capital de giro e atenção operacional — uma revisão de mix tem potencial real de ganho.

**4. Maior faturamento, maior margem — o padrão se confirmou**
A Classe A não só fatura mais: é também a mais rentável percentualmente (74,67%), contra 70,85% da Classe B e 69,04% da Classe C. Isso reforça ainda mais a importância de proteger esses itens.

**5. A classificação muda — e isso é informação**
A análise ano a ano mostrou que o portfólio não é estático. Em 2020, a cauda da Classe C encolheu drasticamente (de 45 itens ativos em 2019 para 87), sinalizando uma resposta rápida do supply chain às condições de mercado daquele período. Monitorar essa dinâmica é tão importante quanto a classificação em si.

---

## 🧠 Técnicas SQL Aplicadas

- `Window Functions` — `SUM() OVER`, `PARTITION BY` para cálculo do percentual acumulado
- `WITH` (CTEs) — organização da lógica em etapas legíveis
- `UNION ALL` — consolidação de validações entre tabelas
- `GROUP BY` com múltiplas agregações — faturamento, custo e margem por classe e categoria
- `CASE WHEN` — atribuição das classes A, B e C com base no acumulado
- `ROUND`, `CAST` — formatação e tipagem dos valores financeiros

---

## 🛠 Tecnologias Utilizadas

| Ferramenta  | Finalidade                                                              |
| ----------- | ----------------------------------------------------------------------- |
| **SQLite**  | Banco de dados — leve, baseado em arquivo, sem necessidade de servidor  |
| **SQL**     | Linguagem utilizada para modelagem, consultas e classificação dos dados |
| **VS Code** | Ambiente de desenvolvimento — todo o trabalho realizado aqui            |
| **Git**     | Controle de versão — cada etapa registrada desde o início               |
| **GitHub**  | Repositório remoto e publicação do portfólio                            |

---

## 📌 Principais Aprendizados

- Aplicação prática de Window Functions para cálculo de percentual acumulado
- Estruturação de um projeto de análise em etapas sequenciais e reproduzíveis
- Como transformar dados transacionais brutos em um insight de negócio concreto
- A importância da validação dos dados antes de qualquer análise
- Que um bom README é parte do projeto — não um detalhe final

---

## 👨‍💻 Autor

**Adriano Luiz de Lacerda**

Profissional da área de logística em transição para análise de dados, com foco em SQL e análise aplicada à cadeia de suprimentos.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-blue)](https://linkedin.com/in/seu-perfil)
[![GitHub](https://img.shields.io/badge/GitHub-Seguir-black)](https://github.com/seu-usuario)

---

⭐ _Projeto desenvolvido para fins de estudo, prática e construção de portfólio em análise de dados._
