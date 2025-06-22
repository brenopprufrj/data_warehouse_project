-- SCHEMA: staging

CREATE SCHEMA IF NOT EXISTS staging;
SET search_path TO staging;

-- CLIENTE
CREATE TABLE staging.cliente (
    cliente_id         VARCHAR(50),
    nome               VARCHAR(255),
    tipo_pessoa        CHAR(2),  -- 'F' ou 'J'
    cpf_cnpj           VARCHAR(20),
    email              VARCHAR(100),
    telefone           VARCHAR(20),
    endereco_cidade    VARCHAR(100),
    endereco_estado    VARCHAR(50),
    data_cadastro      TIMESTAMP,
    data_ingestao      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fonte_dados        VARCHAR(100)
);

-- FROTA (inclui veículo e grupo de veículo)
CREATE TABLE staging.frota (
    veiculo_id         VARCHAR(50),
    placa              VARCHAR(10),
    marca              VARCHAR(50),
    modelo             VARCHAR(50),
    chassi             VARCHAR(50),
    cor                VARCHAR(30),
    grupo_nome         VARCHAR(50),
    tarifa_diaria      DECIMAL(10,2),
    cliente_id         VARCHAR(50),  -- opcional, para associação
    data_ingestao      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fonte_dados        VARCHAR(100)
);

-- LOCACAO (relaciona cliente, veículo, período e valor)
CREATE TABLE staging.locacao (
    locacao_id         VARCHAR(50),
    cliente_id         VARCHAR(50),
    veiculo_id         VARCHAR(50),
    data_inicio        DATE,
    data_fim           DATE,
    valor_total        DECIMAL(10,2),
    status             VARCHAR(20),
    patio_origem_id    VARCHAR(50),  -- para retirada
    patio_destino_id   VARCHAR(50),  -- para devolução
    data_ingestao      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fonte_dados        VARCHAR(100)
);

-- RESERVA
CREATE TABLE staging.reserva (
    reserva_id         VARCHAR(50),
    cliente_id         VARCHAR(50),
    veiculo_id         VARCHAR(50),
    patio_retirada_id  VARCHAR(50),
    data_inicio        DATE,
    data_fim           DATE,
    status             VARCHAR(20),
    data_ingestao      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fonte_dados        VARCHAR(100)
);

-- PATIO
CREATE TABLE staging.patio (
    patio_id           VARCHAR(50),
    localizacao        VARCHAR(100),
    veiculo_id         VARCHAR(50),
    data_ingestao      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fonte_dados        VARCHAR(100)
);


