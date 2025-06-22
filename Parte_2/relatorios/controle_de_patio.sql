-- Quantidade de veículos por grupo e origem da empresa
SELECT
    dp.localizacao AS patio,
    dv.grupo_padronizado AS grupo_veiculo,
    dv.marca,
    dv.modelo,
    fp.origem_empresa AS empresa_origem,
    COUNT(*) AS total_veiculos
FROM dw.fato_patio fp
JOIN dw.dim_veiculo dv ON fp.veiculo_sk = dv.veiculo_sk
JOIN dw.dim_patio dp ON fp.patio_sk = dp.patio_sk
GROUP BY dp.localizacao, dv.grupo_padronizado, dv.marca, dv.modelo, fp.origem_empresa
ORDER BY dp.localizacao, dv.grupo_padronizado;
