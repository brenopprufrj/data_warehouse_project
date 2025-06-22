-- Preenche dim_tempo com datas de interesse (exemplo usando um intervalo)
INSERT INTO dw.dim_tempo (data, ano, mes, dia, dia_semana)
SELECT d, EXTRACT(YEAR FROM d), EXTRACT(MONTH FROM d), EXTRACT(DAY FROM d),
       TO_CHAR(d, 'Day')
FROM generate_series('2023-01-01'::date, '2025-12-31'::date, interval '1 day') d;

-- dim_cliente
INSERT INTO dw.dim_cliente (cliente_id, nome, tipo_pessoa, cpf_cnpj, cidade, estado, data_cadastro, fonte_dados)
SELECT DISTINCT cliente_id, nome, tipo_pessoa_desc, cpf_cnpj, endereco_cidade, endereco_estado, data_cadastro, fonte_dados
FROM staging.cliente;

-- dim_veiculo
INSERT INTO dw.dim_veiculo (veiculo_id, placa, marca, modelo, chassi, cor, grupo_padronizado, tarifa_diaria, fonte_dados)
SELECT DISTINCT veiculo_id, placa, marca, modelo, chassi, cor, grupo_padronizado, tarifa_diaria, fonte_dados
FROM staging.frota;

-- dim_patio
INSERT INTO dw.dim_patio (patio_id, localizacao, fonte_dados)
SELECT DISTINCT patio_id, localizacao, fonte_dados
FROM staging.patio;

-- fato_locacao
INSERT INTO dw.fato_locacao (
    cliente_sk, veiculo_sk, data_inicio_sk, data_fim_sk, duracao_dias, valor_total, status, fonte_dados
)
SELECT
    dc.cliente_sk,
    dv.veiculo_sk,
    dt_ini.data_sk,
    dt_fim.data_sk,
    l.duracao_dias,
    l.valor_total,
    l.status,
    l.fonte_dados
FROM staging.locacao l
JOIN dw.dim_cliente dc ON dc.cliente_id = l.cliente_id AND dc.fonte_dados = l.fonte_dados
JOIN dw.dim_veiculo dv ON dv.veiculo_id = l.veiculo_id AND dv.fonte_dados = l.fonte_dados
JOIN dw.dim_tempo dt_ini ON dt_ini.data = l.data_inicio
JOIN dw.dim_tempo dt_fim ON dt_fim.data = l.data_fim;

-- fato_reserva
INSERT INTO dw.fato_reserva (
    cliente_sk, veiculo_sk, patio_retirada_sk, data_inicio_sk, data_fim_sk, duracao_dias, status, fonte_dados
)
SELECT
    dc.cliente_sk,
    dv.veiculo_sk,
    dp.patio_sk,
    dt_ini.data_sk,
    dt_fim.data_sk,
    r.duracao_dias,
    r.status,
    r.fonte_dados
FROM staging.reserva r
JOIN dw.dim_cliente dc ON dc.cliente_id = r.cliente_id AND dc.fonte_dados = r.fonte_dados
LEFT JOIN dw.dim_veiculo dv ON dv.veiculo_id = r.veiculo_id AND dv.fonte_dados = r.fonte_dados
JOIN dw.dim_patio dp ON dp.patio_id = r.patio_retirada_id
JOIN dw.dim_tempo dt_ini ON dt_ini.data = r.data_inicio
JOIN dw.dim_tempo dt_fim ON dt_fim.data = r.data_fim;

-- fato_patio
-- Se quiser usar a data atual como proxy para ocupação
INSERT INTO dw.fato_patio (
    veiculo_sk, patio_sk, data_sk, origem_empresa, fonte_dados
)
SELECT
    dv.veiculo_sk,
    dp.patio_sk,
    dt.data_sk,
    f.fonte_dados,
    f.fonte_dados
FROM staging.patio p
JOIN dw.dim_patio dp ON dp.patio_id = p.patio_id AND dp.fonte_dados = p.fonte_dados
JOIN dw.dim_veiculo dv ON dv.veiculo_id = p.veiculo_id AND dv.fonte_dados = p.fonte_dados
JOIN dw.dim_tempo dt ON dt.data = CURRENT_DATE
JOIN staging.frota f ON f.veiculo_id = p.veiculo_id AND f.fonte_dados = p.fonte_dados;
