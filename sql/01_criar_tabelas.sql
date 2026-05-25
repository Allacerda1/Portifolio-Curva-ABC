-- =============================================================
--  ETAPA 1 — CRIAÇÃO DAS TABELAS
--  Projeto : Análise Curva ABC | Portfólio de Logística
--  Autor   : [Adriano Luiz de Lacerda]
-- =============================================================
--  O que fazemos aqui:
--  Criamos as duas tabelas que vão receber os dados importados
--  dos arquivos CSV. Uma tabela de produtos e uma de vendas.
-- =============================================================

-- Remove as tabelas se já existirem
-- (útil caso precise rodar o script novamente do zero)
DROP TABLE IF EXISTS dim_products;
DROP TABLE IF EXISTS fact_sales;

-- Tabela de produtos (dimensão)
-- Cada linha representa um produto único do catálogo
CREATE TABLE dim_products (
    product_id   INTEGER PRIMARY KEY,
    product_name TEXT    NOT NULL,
    category     TEXT    NOT NULL,
    subcategory  TEXT    NOT NULL,
    brand        TEXT    NOT NULL
);

-- Tabela de vendas (fato)
-- Cada linha representa uma transação de venda realizada
CREATE TABLE fact_sales (
    order_date     TEXT,
    sale_number    TEXT,
    product_id     INTEGER,
    seller_id      INTEGER,
    seller_name    TEXT,
    customer_id    INTEGER,
    customer_name  TEXT,
    unit_id        INTEGER,
    unit_name      TEXT,
    quantity       REAL,
    unit_price     REAL,
    unit_cost      REAL,
    total_revenue  REAL,
    total_cost     REAL
);

-- Confirma que as tabelas foram criadas
SELECT name AS tabela_criada FROM sqlite_master WHERE type = 'table';
