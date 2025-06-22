-- =========================
-- DIMENSÕES
-- =========================
CREATE SCHEMA IF NOT EXISTS dw;
SET search_path TO dw;

CREATE TABLE dw.dim_cliente (
    cliente_sk SERIAL PRIMARY KEY,
    cliente_id VARCHAR,
    nome VARCHAR,
    tipo_pessoa VARCHAR,
    cpf_cnpj VARCHAR,
    cidade VARCHAR,
    estado VARCHAR,
    data_cadastro DATE,
    fonte_dados VARCHAR
);

CREATE TABLE dw.dim_veiculo (
    veiculo_sk SERIAL PRIMARY KEY,
    veiculo_id VARCHAR,
    placa VARCHAR,
    marca VARCHAR,
    modelo VARCHAR,
    chassi VARCHAR,
    cor VARCHAR,
    grupo_padronizado VARCHAR,
    tarifa_diaria NUMERIC,
    fonte_dados VARCHAR
);

CREATE TABLE dw.dim_patio (
    patio_sk SERIAL PRIMARY KEY,
    patio_id VARCHAR,
    localizacao VARCHAR,
    fonte_dados VARCHAR
);

CREATE TABLE dw.dim_tempo (
    data_sk SERIAL PRIMARY KEY,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    dia_semana VARCHAR
);

-- =========================
-- TABELAS DE FATO
-- =========================

CREATE TABLE dw.fato_locacao (
    locacao_sk SERIAL PRIMARY KEY,
    cliente_sk INT REFERENCES dw.dim_cliente(cliente_sk),
    veiculo_sk INT REFERENCES dw.dim_veiculo(veiculo_sk),
    data_inicio_sk INT REFERENCES dw.dim_tempo(data_sk),
    data_fim_sk INT REFERENCES dw.dim_tempo(data_sk),
    duracao_dias INT,
    valor_total NUMERIC,
    status VARCHAR,
    fonte_dados VARCHAR
);

CREATE TABLE dw.fato_reserva (
    reserva_sk SERIAL PRIMARY KEY,
    cliente_sk INT REFERENCES dw.dim_cliente(cliente_sk),
    veiculo_sk INT REFERENCES dw.dim_veiculo(veiculo_sk),
    patio_retirada_sk INT REFERENCES dw.dim_patio(patio_sk),
    data_inicio_sk INT REFERENCES dw.dim_tempo(data_sk),
    data_fim_sk INT REFERENCES dw.dim_tempo(data_sk),
    duracao_dias INT,
    status VARCHAR,
    fonte_dados VARCHAR
);

CREATE TABLE dw.fato_patio (
    registro_sk SERIAL PRIMARY KEY,
    veiculo_sk INT REFERENCES dw.dim_veiculo(veiculo_sk),
    patio_sk INT REFERENCES dw.dim_patio(patio_sk),
    data_sk INT REFERENCES dw.dim_tempo(data_sk),
    origem_empresa VARCHAR,
    fonte_dados VARCHAR
);
