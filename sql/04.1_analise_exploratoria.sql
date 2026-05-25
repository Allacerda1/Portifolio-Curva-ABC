-- =============================================================
-- ETAPA 3 — ANÁLISE EXPLORATÓRIA
-- Projeto : Análise Curva ABC | Portfólio de Logística
-- =============================================================
-- O objetivo desta etapa é compreender:
-- • volume de dados
-- • período analisado
-- • distribuição do faturamento
-- antes da classificação ABC.
-- =============================================================

-- =============================================================
-- 1. Visão geral da operação
-- =============================================================

SELECT
    ROUND(SUM(total_revenue), 2) AS faturamento_total,
    COUNT(DISTINCT sale_number)  AS total_pedidos,
    COUNT(DISTINCT product_id)   AS produtos_vendidos
FROM fact_sales;

-- =============================================================
-- 2. Período disponível na base
-- =============================================================

SELECT
    MIN(order_date) AS primeira_venda,
    MAX(order_date) AS ultima_venda
FROM fact_sales;

-- =============================================================
-- 3. Evolução anual do faturamento
-- =============================================================

SELECT
    SUBSTR(order_date, 1, 4)     AS ano,
    COUNT(DISTINCT sale_number)  AS total_pedidos,
    ROUND(SUM(total_revenue), 2) AS faturamento_total
FROM fact_sales
GROUP BY ano
ORDER BY ano;

-- =============================================================
-- 4. Participação do faturamento por categoria
-- =============================================================

SELECT
    p.category                   AS categoria,
    COUNT(DISTINCT s.product_id) AS qtd_produtos,
    ROUND(SUM(s.total_revenue), 2) AS faturamento_total,
    ROUND(
        SUM(s.total_revenue) * 100.0 /
        (SELECT SUM(total_revenue) FROM fact_sales),
        2
    ) AS participacao_pct
FROM fact_sales s
JOIN dim_products p
    ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY faturamento_total DESC;