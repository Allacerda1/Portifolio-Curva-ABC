-- -- =============================================================
--  ETAPA 4 — CLASSIFICAÇÃO CURVA ABC (VERSÃO OTIMIZADA)
--  Projeto : Análise Curva ABC | Portfólio de Logística
--  Autor   : [Adriano Luiz de Lacerda]
-- =============================================================
--  O que fazemos aqui:
--  Criamos três views que juntas entregam a classificação ABC.
--  Cada view representa uma camada da lógica:
--
--    View 1 → faturamento total por produto
--    View 2 → percentual acumulado (do maior para o menor)
--    View 3 → classificação final A, B ou C
-- =============================================================


DROP VIEW IF EXISTS vw_classificacao_abc;
DROP VIEW IF EXISTS vw_abc_acumulado;
DROP VIEW IF EXISTS vw_faturamento_por_produto;

-- ── VIEW 1: Faturamento por produto (Mantida por consistência)
CREATE VIEW vw_faturamento_por_produto AS
SELECT
    p.product_id,
    p.product_name                 AS produto,
    p.category                     AS categoria,
    p.subcategory                  AS subcategoria,
    p.brand                        AS marca,
    ROUND(SUM(s.total_revenue), 2) AS faturamento,
    ROUND(SUM(s.total_cost), 2)    AS custo_total
FROM fact_sales   s
JOIN dim_products p ON s.product_id = p.product_id
GROUP BY p.product_id;


-- ── VIEW 2: Percentual acumulado (OTIMIZADA)
-- Otimização: Calculamos a soma total uma única vez no FROM (Cross Join).
-- O SQLite não precisa mais reprocessar a View 1 a cada linha da tabela.
CREATE VIEW vw_abc_acumulado AS
SELECT
    v.product_id,
    v.produto,
    v.categoria,
    v.subcategoria,
    v.marca,
    v.faturamento,
    v.custo_total,
    ROUND((v.faturamento * 100.0) / t.total_geral, 2) AS participacao_pct,
    ROUND(
        (SUM(v.faturamento) OVER (
            ORDER BY v.faturamento DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0) / t.total_geral, 
    2) AS acumulado_pct
FROM vw_faturamento_por_produto v
CROSS JOIN (
    SELECT SUM(faturamento) AS total_geral FROM vw_faturamento_por_produto
) t;


-- ── VIEW 3: Classificação final A, B ou C (RECONCILIAÇÃO DE BORDA)
-- Negócio: Adicionamos uma pequena margem de tolerância (80.5%) para evitar
-- que o primeiro produto que rompe a barreira dos 80% por centavos caia injustamente na classe B.
CREATE VIEW vw_classificacao_abc AS
SELECT
    product_id,
    produto,
    categoria,
    subcategoria,
    marca,
    faturamento,
    custo_total,
    participacao_pct,
    acumulado_pct,
    CASE
        WHEN acumulado_pct <= 80.5 THEN 'A'
        WHEN acumulado_pct <= 95.5 THEN 'B'
        ELSE                            'C'
    END AS classe_abc
FROM vw_abc_acumulado;

-- Confirma que as views foram criadas
SELECT name AS view_criada FROM sqlite_master WHERE type = 'view';
