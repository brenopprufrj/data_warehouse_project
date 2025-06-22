-- ========================
-- CLIENTE → staging.cliente
-- ========================
INSERT INTO staging.cliente (
    cliente_id,
    nome,
    tipo_pessoa,
    cpf_cnpj,
    email,
    telefone,
    endereco_cidade,
    endereco_estado,
    data_cadastro,
    fonte_dados
)
SELECT
    c.cliente_id::VARCHAR,
    c.nome_razao,
    c.tipo,
    c.cpf_cnpj,
    c.email,
    c.telefone,
    NULL AS endereco_cidade,  -- não disponível
    NULL AS endereco_estado,  -- não disponível
    NULL AS data_cadastro,    -- não disponível
    'breno' AS fonte_dados
FROM breno.cliente c;

-- ========================
-- FROTA (veiculo + grupo) → staging.frota
-- ========================
INSERT INTO staging.frota (
    veiculo_id,
    placa,
    marca,
    modelo,
    chassi,
    cor,
    grupo_nome,
    tarifa_diaria,
    cliente_id,
    fonte_dados
)
SELECT
    v.veiculo_id::VARCHAR,
    v.placa,
    v.marca,
    v.modelo,
    v.chassis,
    v.cor,
    g.nome,
    g.tarifa_diaria,
    NULL AS cliente_id,  -- proprietário não especificado
    'breno' AS fonte_dados
FROM breno.veiculo v
JOIN breno.grupo_veiculo g ON v.grupo_id = g.grupo_id;

-- ========================
-- LOCACAO → staging.locacao
-- ========================
INSERT INTO staging.locacao (
    locacao_id,
    cliente_id,
    veiculo_id,
    data_inicio,
    data_fim,
    valor_total,
    status,
    fonte_dados
)
SELECT
    l.locacao_id::VARCHAR,
    c.cliente_id::VARCHAR,
    l.veiculo_id::VARCHAR,
    l.data_retirada::DATE,
    l.data_devolucao_real::DATE,
    cb.valor_final,
    cb.status_pagamento,
    'breno' AS fonte_dados
FROM breno.locacao l
JOIN breno.condutor cond ON cond.condutor_id = l.condutor_id
JOIN breno.cliente c ON c.cliente_id = cond.cliente_id
LEFT JOIN breno.cobranca cb ON cb.locacao_id = l.locacao_id;

-- ========================
-- RESERVA → staging.reserva
-- ========================
INSERT INTO staging.reserva (
    reserva_id,
    cliente_id,
    veiculo_id,
    patio_retirada_id,
    data_inicio,
    data_fim,
    status,
    fonte_dados
)
SELECT
    r.reserva_id::VARCHAR,
    r.cliente_id::VARCHAR,
    NULL AS veiculo_id,  -- não disponível na reserva
    r.patio_retirada_id::VARCHAR,
    r.data_inicio,
    r.data_fim_previsto,
    r.status,
    'breno' AS fonte_dados
FROM breno.reserva r;

-- ========================
-- PATIO → staging.patio
-- ========================
INSERT INTO staging.patio (
    patio_id,
    localizacao,
    veiculo_id,
    fonte_dados
)
SELECT DISTINCT
    p.patio_id::VARCHAR,
    p.localizacao,
    NULL AS veiculo_id,  -- posição do veículo não registrada diretamente
    'breno' AS fonte_dados
FROM breno.patio p;
