-- Locações em andamento, com duração e tempo restante
SELECT
    dv.grupo_padronizado AS grupo_veiculo,
    COUNT(*) AS total_alugueis,
    AVG(fl.duracao_dias) AS duracao_media,
    AVG(GREATEST(DATE_PART('day', dt_fim.data - CURRENT_DATE), 0)) AS media_dias_restantes
FROM dw.fato_locacao fl
JOIN dw.dim_veiculo dv ON fl.veiculo_sk = dv.veiculo_sk
JOIN dw.dim_tempo dt_fim ON fl.data_fim_sk = dt_fim.data_sk
WHERE fl.status = 'Em Andamento'
GROUP BY dv.grupo_padronizado
ORDER BY total_alugueis DESC;
