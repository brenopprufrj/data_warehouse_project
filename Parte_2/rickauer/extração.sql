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
    COALESCE(pf.nome_completo, pj.nome_empresa) AS nome,
    CASE
        WHEN pf.id_cliente IS NOT NULL THEN 'F'
        WHEN pj.id_cliente IS NOT NULL THEN 'J'
    END AS tipo_pessoa,
    COALESCE(pf.cpf, pj.cnpj) AS cpf_cnpj,
    c.email,
    c.telefone_principal,
    NULL AS endereco_cidade,      -- não disponível na origem
    NULL AS endereco_estado,      -- não disponível na origem
    c.data_cadastro,
    'rickauer' AS fonte_dados
FROM rickauer.cliente c
LEFT JOIN rickauer.pessoa_fisica pf ON pf.id_cliente = c.id_cliente
LEFT JOIN rickauer.pessoa_juridica pj ON pj.id_cliente = c.id_cliente;

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
    v.id_veiculo::VARCHAR,
    v.placa,
    v.marca,
    NULL AS modelo,  -- não disponível na origem
    v.chassi,
    v.cor,
    g.nome_grupo,
    g.faixa_valor,
    NULL AS cliente_id,  -- proprietário é locadora, não cliente
    'rickauer' AS fonte_dados
FROM rickauer.veiculo v
JOIN rickauer.grupo_veiculo g ON g.id_grupo_veiculo = v.id_grupo_veiculo;

-- ========================
-- LOCACAO (contrato) → staging.locacao
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
    ct.id_contrato::VARCHAR,
    ct.id_cliente::VARCHAR,
    ct.id_veiculo::VARCHAR,
    r.data_hora_retirada_fim::DATE,
    ct.data_hora_contrato::DATE,  -- usaremos data do contrato como data_fim
    cb.valor,
    ct.status_locacao,
    ct.id_patio_retirada::VARCHAR,
    ct.id_patio_devolucao_efetiva::VARCHAR,
    'rickauer' AS fonte_dados
FROM rickauer.reserva r
LEFT JOIN rickauer.contrato ct ON ct.id_reserva = r.id_reserva
LEFT JOIN rickauer.cobranca cb ON cb.id_contrato = ct.id_contrato;

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
    ct.id_cliente::VARCHAR,
    r.id_veiculo::VARCHAR,
    ct.id_patio_retirada::VARCHAR,
    r.data_hora_reserva_inicio::DATE,
    r.data_hora_retirada_fim::DATE,
    ct.status_locacao,
    'rickauer' AS fonte_dados
FROM rickauer.reserva r
JOIN rickauer.contrato ct ON ct.id_reserva = r.id_reserva;

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
    p.endereco_patio,
    v.id_veiculo::VARCHAR,
    'rickauer' AS fonte_dados
FROM rickauer.patio p
LEFT JOIN rickauer.vaga va ON va.id_patio = p.id_patio
LEFT JOIN rickauer.veiculo v ON v.id_vaga_atual = va.id_vaga;
