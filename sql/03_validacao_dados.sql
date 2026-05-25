-- =============================================================
--  ETAPA 2 — VALIDAÇÃO DOS DADOS
--  Projeto : Análise Curva ABC | Portfólio de Logística
--  Autor   : [Seu Nome]
-- =============================================================
--  O que fazemos aqui:
--  Após importar os CSVs, verificamos se os dados chegaram
--  corretamente antes de começar qualquer análise.
-- =============================================================

-- Quantidade de linhas em cada tabela
SELECT 'dim_products' AS tabela, COUNT(*) AS total_linhas FROM dim_products
UNION ALL
SELECT 'fact_sales'   AS tabela, COUNT(*) AS total_linhas FROM fact_sales;

-- Primeiras linhas da tabela de produtos
SELECT * FROM dim_products LIMIT 5;

-- Primeiras linhas da tabela de vendas
SELECT * FROM fact_sales LIMIT 5;

-- Período coberto pelos dados
SELECT
    MIN(order_date) AS primeira_venda,
    MAX(order_date) AS ultima_venda
FROM fact_sales;

-- Verifica se há valores nulos nas colunas mais importantes
SELECT
    SUM(CASE WHEN product_id    IS NULL THEN 1 ELSE 0 END) AS nulos_product_id,
    SUM(CASE WHEN total_revenue IS NULL THEN 1 ELSE 0 END) AS nulos_faturamento,
    SUM(CASE WHEN quantity      IS NULL THEN 1 ELSE 0 END) AS nulos_quantidade
FROM fact_sales;
