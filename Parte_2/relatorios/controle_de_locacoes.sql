-- Grupo: Breno Valente Manhães - 122038517; João Pedro Moretti Fontes Ferreira - 122081366; Murilo Jorge de Figueiredo - 122079597

SELECT
    dv.grupo_padronizado AS grupo_veiculo,
    COUNT(*) AS qtd_locacoes,
    AVG(fl.duracao_dias) AS duracao_media,
    SUM(
        CASE 
            WHEN dtf.data > CURRENT_DATE THEN 1
            ELSE 0
        END
    ) AS locacoes_ativas
FROM dw.fato_locacao fl
JOIN dw.dim_veiculo dv ON dv.veiculo_sk = fl.veiculo_sk
JOIN dw.dim_tempo dti ON dti.data_sk = fl.data_inicio_sk
JOIN dw.dim_tempo dtf ON dtf.data_sk = fl.data_fim_sk
GROUP BY dv.grupo_padronizado
ORDER BY qtd_locacoes DESC;
