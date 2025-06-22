-- Grupo: Breno Valente Manhães - 122038517; João Pedro Moretti Fontes Ferreira - 122081366; Murilo Jorge de Figueiredo - 122079597

SELECT
    dv.grupo_padronizado AS grupo_veiculo,
    dc.cidade AS cidade_origem_cliente,
    COUNT(*) AS qtd_locacoes
FROM dw.fato_locacao fl
JOIN dw.dim_cliente dc ON dc.cliente_sk = fl.cliente_sk
JOIN dw.dim_veiculo dv ON dv.veiculo_sk = fl.veiculo_sk
GROUP BY dv.grupo_padronizado, dc.cidade
ORDER BY qtd_locacoes DESC;
