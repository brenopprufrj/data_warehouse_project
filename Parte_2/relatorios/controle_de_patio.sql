-- Grupo: Breno Valente Manhães - 122038517; João Pedro Moretti Fontes Ferreira - 122081366; Murilo Jorge de Figueiredo - 122079597

SELECT
    dp.localizacao AS patio,
    dv.grupo_padronizado AS grupo_veiculo,
    fp.origem_empresa AS empresa_origem,
    COUNT(*) AS qtd_veiculos
FROM dw.fato_patio fp
JOIN dw.dim_patio dp ON dp.patio_sk = fp.patio_sk
JOIN dw.dim_veiculo dv ON dv.veiculo_sk = fp.veiculo_sk
GROUP BY dp.localizacao, dv.grupo_padronizado, fp.origem_empresa
ORDER BY dp.localizacao, dv.grupo_padronizado;
