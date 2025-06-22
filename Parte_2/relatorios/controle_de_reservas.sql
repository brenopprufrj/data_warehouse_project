-- Grupo: Breno Valente Manhães - 122038517; João Pedro Moretti Fontes Ferreira - 122081366; Murilo Jorge de Figueiredo - 122079597

SELECT
    dp.localizacao AS patio_retirada,
    dv.grupo_padronizado AS grupo_veiculo,
    COUNT(*) AS qtd_reservas,
    AVG(fr.duracao_dias) AS duracao_media,
    dti.ano,
    dti.mes
FROM dw.fato_reserva fr
JOIN dw.dim_veiculo dv ON dv.veiculo_sk = fr.veiculo_sk
JOIN dw.dim_patio dp ON dp.patio_sk = fr.patio_retirada_sk
JOIN dw.dim_tempo dti ON dti.data_sk = fr.data_inicio_sk
GROUP BY dp.localizacao, dv.grupo_padronizado, dti.ano, dti.mes
ORDER BY dti.ano DESC, dti.mes DESC, qtd_reservas DESC;
