-- Subconsulta 1: total de locações por pátio de origem
WITH total_por_origem AS (
    SELECT
        patio_origem_sk,
        COUNT(*) AS total_saida
    FROM dw.fato_locacao
    WHERE patio_origem_sk IS NOT NULL
      AND patio_chegada_sk IS NOT NULL
    GROUP BY patio_origem_sk
),

-- Subconsulta 2: locações por par origem → destino
movimentacoes AS (
    SELECT
        fl.patio_origem_sk,
        fl.patio_chegada_sk,
        COUNT(*) AS qtd_movimentacoes
    FROM dw.fato_locacao fl
    WHERE fl.patio_origem_sk IS NOT NULL
      AND fl.patio_chegada_sk IS NOT NULL
    GROUP BY fl.patio_origem_sk, fl.patio_chegada_sk
)

-- Resultado final: matriz com percentuais
SELECT
    pori.localizacao AS patio_origem,
    pdes.localizacao AS patio_destino,
    m.qtd_movimentacoes,
    t.total_saida,
    ROUND((m.qtd_movimentacoes::DECIMAL / t.total_saida) * 100, 2) AS percentual
FROM movimentacoes m
JOIN total_por_origem t ON t.patio_origem_sk = m.patio_origem_sk
JOIN dw.dim_patio pori ON pori.patio_sk = m.patio_origem_sk
JOIN dw.dim_patio pdes ON pdes.patio_sk = m.patio_chegada_sk
ORDER BY patio_origem, percentual DESC;
