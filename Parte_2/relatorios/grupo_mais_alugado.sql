-- Ranking dos grupos de veículos mais alugados por cidade
SELECT
    dv.grupo_padronizado AS grupo_veiculo,
    dc.cidade AS cidade_cliente,
    COUNT(*) AS total_locacoes
FROM dw.fato_locacao fl
JOIN dw.dim_veiculo dv ON fl.veiculo_sk = dv.veiculo_sk
JOIN dw.dim_cliente dc ON fl.cliente_sk = dc.cliente_sk
GROUP BY dv.grupo_padronizado, dc.cidade
ORDER BY total_locacoes DESC;
