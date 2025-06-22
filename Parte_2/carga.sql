-- Grupo: Breno Valente Manhães - 122038517; João Pedro Moretti Fontes Ferreira - 122081366; Murilo Jorge de Figueiredo - 122079597

-- ============================================
-- DIM_TEMPO (baseado em datas de reserva e locação)
-- ============================================
INSERT INTO dw.dim_tempo (data, ano, mes, dia, dia_semana)
SELECT DISTINCT
    d::DATE AS data,
    EXTRACT(YEAR FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(DAY FROM d)::INT,
    TO_CHAR(d, 'Day')
FROM (
    SELECT data_inicio FROM staging.locacao WHERE data_inicio IS NOT NULL
    UNION
    SELECT data_fim FROM staging.locacao WHERE data_fim IS NOT NULL
    UNION
    SELECT data_inicio FROM staging.reserva WHERE data_inicio IS NOT NULL
    UNION
    SELECT data_fim FROM staging.reserva WHERE data_fim IS NOT NULL
) AS datas(d)
WHERE NOT EXISTS (
    SELECT 1 FROM dw.dim_tempo dt WHERE dt.data = d
);

-- ============================================
-- DIM_CLIENTE
-- ============================================
INSERT INTO dw.dim_cliente (
    cliente_id, nome, tipo_pessoa, cpf_cnpj,
    cidade, estado, data_cadastro, fonte_dados
)
SELECT DISTINCT ON (cliente_id, fonte_dados)
    cliente_id, nome, tipo_pessoa, cpf_cnpj,
    endereco_cidade, endereco_estado, data_cadastro, fonte_dados
FROM staging.cliente;


-- ============================================
-- DIM_VEICULO
-- ============================================
INSERT INTO dw.dim_veiculo (
    veiculo_id, placa, marca, modelo, chassi,
    cor, grupo_padronizado, tarifa_diaria, fonte_dados
)
SELECT DISTINCT ON (veiculo_id, fonte_dados)
    veiculo_id, placa, marca, modelo, chassi,
    cor, grupo_nome, tarifa_diaria, fonte_dados
FROM staging.frota;


-- ============================================
-- DIM_PATIO
-- ============================================
INSERT INTO dw.dim_patio (
    patio_id, localizacao, fonte_dados
)
SELECT DISTINCT ON (patio_id, fonte_dados)
    patio_id, localizacao, fonte_dados
FROM staging.patio;

-- ============================================
-- FATO_LOCACAO
-- ============================================
INSERT INTO dw.fato_locacao (
    cliente_sk, veiculo_sk, data_inicio_sk, data_fim_sk,
    duracao_dias, valor_total, status,
    patio_origem_sk, patio_chegada_sk, fonte_dados
)
SELECT
    dc.cliente_sk,
    dv.veiculo_sk,
    di.data_sk,
    df.data_sk,
    l.duracao_dias,
    l.valor_total,
    l.status,
    po.patio_sk,
    pd.patio_sk,
    l.fonte_dados
FROM staging.locacao l
JOIN dw.dim_cliente dc 
    ON dc.cliente_id = l.cliente_id AND dc.fonte_dados = l.fonte_dados
JOIN dw.dim_veiculo dv 
    ON dv.veiculo_id = l.veiculo_id AND dv.fonte_dados = l.fonte_dados
JOIN dw.dim_tempo di ON di.data = l.data_inicio
LEFT JOIN dw.dim_tempo df ON df.data = l.data_fim
LEFT JOIN dw.dim_patio po 
    ON po.patio_id = l.patio_origem_id AND po.fonte_dados = l.fonte_dados
LEFT JOIN dw.dim_patio pd 
    ON pd.patio_id = l.patio_destino_id AND pd.fonte_dados = l.fonte_dados;


-- ============================================
-- FATO_RESERVA
-- ============================================
INSERT INTO dw.fato_reserva (
    cliente_sk, veiculo_sk, patio_retirada_sk,
    data_inicio_sk, data_fim_sk, duracao_dias,
    status, fonte_dados
)
SELECT
    dc.cliente_sk,
    dv.veiculo_sk,
    dp.patio_sk,
    di.data_sk,
    df.data_sk,
    r.duracao_dias,
    r.status,
    r.fonte_dados
FROM staging.reserva r
JOIN dw.dim_cliente dc 
    ON dc.cliente_id = r.cliente_id AND dc.fonte_dados = r.fonte_dados
LEFT JOIN dw.dim_veiculo dv 
    ON dv.veiculo_id = r.veiculo_id AND dv.fonte_dados = r.fonte_dados
LEFT JOIN dw.dim_patio dp 
    ON dp.patio_id = r.patio_retirada_id AND dp.fonte_dados = r.fonte_dados
JOIN dw.dim_tempo di ON di.data = r.data_inicio
JOIN dw.dim_tempo df ON df.data = r.data_fim;

-- ============================================
-- FATO_PATIO (controle de estoque atual por data e pátio)
-- ============================================
INSERT INTO dw.fato_patio (
    veiculo_sk, patio_sk, data_sk, origem_empresa, fonte_dados
)
SELECT
    dv.veiculo_sk,
    dp.patio_sk,
    dt.data_sk,
    dv.fonte_dados AS origem_empresa,
    p.fonte_dados
FROM staging.patio p
LEFT JOIN dw.dim_veiculo dv 
    ON dv.veiculo_id = p.veiculo_id AND dv.fonte_dados = p.fonte_dados
JOIN dw.dim_patio dp 
    ON dp.patio_id = p.patio_id AND dp.fonte_dados = p.fonte_dados
-- Para a data, usamos a data atual ou uma data padrão de "registro"
JOIN dw.dim_tempo dt ON dt.data = CURRENT_DATE;
