-- Reservas por grupo e pátio, com tempo até retirada e duração
SELECT
    dv.grupo_padronizado AS grupo_veiculo,
    dp.localizacao AS patio_retirada,
    dc.cidade AS cidade_cliente,
    COUNT(*) AS total_reservas,
    AVG(fr.duracao_dias) AS duracao_media_dias,
    AVG(DATE_PART('day', dt_ini.data - CURRENT_DATE)) AS dias_ate_retirada
FROM dw.fato_reserva fr
JOIN dw.dim_veiculo dv ON fr.veiculo_sk = dv.veiculo_sk
JOIN dw.dim_cliente dc ON fr.cliente_sk = dc.cliente_sk
JOIN dw.dim_patio dp ON fr.patio_retirada_sk = dp.patio_sk
JOIN dw.dim_tempo dt_ini ON fr.data_inicio_sk = dt_ini.data_sk
WHERE dt_ini.data >= CURRENT_DATE
GROUP BY dv.grupo_padronizado, dp.localizacao, dc.cidade
ORDER BY dias_ate_retirada, total_reservas DESC;
