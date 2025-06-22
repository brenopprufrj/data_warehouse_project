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
    c.id_cliente::VARCHAR,
    c.nome,
    c.tipo,
    c.cpf_cnpj,
    c.email,
    c.telefone,
    NULL AS endereco_cidade,  -- não disponível
    NULL AS endereco_estado,  -- não disponível
    NULL AS data_cadastro,    -- não disponível
    'WesleyConceicao' AS fonte_dados
FROM WesleyConceicao.cliente c;

-- ========================
-- FROTA (veiculo) → staging.frota
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
    v.id_veiculo::VARCHAR,
    v.placa,
    v.marca,
    v.modelo,
    v.chassi,
    v.cor,
    NULL AS grupo_nome,       -- não disponível
    NULL AS tarifa_diaria,    -- não disponível
    v.cliente_id::VARCHAR,
    'WesleyConceicao' AS fonte_dados
FROM WesleyConceicao.veiculo v;

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
    patio_origem_id,
    patio_destino_id,
    fonte_dados
)
SELECT
    l.id_locacao::VARCHAR,
    l.cliente_id::VARCHAR,
    l.veiculo_id::VARCHAR,
    r.data_inicio,
    r.data_fim,
    l.valor_total,
    r.status,
    r.patio_retirada_id::VARCHAR,
    l.patio_entrega_id::VARCHAR,
    'WesleyConceicao' AS fonte_dados
FROM WesleyConceicao.locacao l
LEFT JOIN WesleyConceicao.reserva r ON r.id_reserva = l.reserva_id;

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
    r.id_reserva::VARCHAR,
    r.cliente_id::VARCHAR,
    r.veiculo_id::VARCHAR,
    r.patio_retirada_id::VARCHAR,
    r.data_inicio,
    r.data_fim,
    r.status,
    'WesleyConceicao' AS fonte_dados
FROM WesleyConceicao.reserva r;

-- ========================
-- PATIO → staging.patio
-- ========================
INSERT INTO staging.patio (
    patio_id,
    localizacao,
    veiculo_id,
    fonte_dados
)
SELECT
    p.id_patio::VARCHAR,
    p.localizacao,
    p.veiculo_id::VARCHAR,
    'WesleyConceicao' AS fonte_dados
FROM WesleyConceicao.patio p;
