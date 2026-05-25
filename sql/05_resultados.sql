-- =============================================================
--  ETAPA 5 — RESULTADOS DA CURVA ABC
--  Projeto : Análise Curva ABC | Portfólio de Logística
-- =============================================================
--  O que fazemos aqui:
--  Consultamos a classificação final criada nas views
--  para identificar a distribuição dos produtos entre
--  as classes A, B e C.
-- =============================================================


-- Resumo geral da Curva ABC
SELECT
    classe_abc AS classe,
    
    COUNT(*) AS qtd_produtos,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM vw_classificacao_abc),
    2) AS pct_catalogo,

    ROUND(SUM(faturamento), 2) AS faturamento_total,

    ROUND(SUM(participacao_pct), 2) AS participacao_pct

FROM vw_classificacao_abc
GROUP BY classe_abc
ORDER BY classe_abc;


-- Distribuição por categoria
SELECT
    categoria,
    classe_abc,
    COUNT(*)                   AS qtd_produtos,
    ROUND(SUM(faturamento), 2) AS faturamento_total
FROM vw_classificacao_abc
GROUP BY categoria, classe_abc
ORDER BY categoria, classe_abc;