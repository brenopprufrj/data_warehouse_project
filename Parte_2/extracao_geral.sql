-- brenopprufrj/extracao.sql
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
    patio_origem_id,
    patio_destino_id,
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
    l.patio_saida_id::VARCHAR,
    l.patio_chegada_id::VARCHAR,
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

-- BRJCM/extracao.sql
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
    c.nome_completo,
    c.tipo_pessoa,
    c.cpf_cnpj,
    c.email,
    c.telefone,
    c.endereco_cidade,
    c.endereco_estado,
    c.data_cadastro,
    'BRJCM' AS fonte_dados
FROM BRJCM.clientes c;

-- ========================
-- FROTA (veiculos + grupo) → staging.frota
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
    v.chassi,
    v.cor,
    g.nome_grupo,
    g.tarifa_diaria_base,
    NULL AS cliente_id,  -- proprietário não é um cliente aqui
    'BRJCM' AS fonte_dados
FROM BRJCM.veiculos v
JOIN BRJCM.grupos_veiculos g ON v.grupo_id = g.grupo_id;

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
    l.locacao_id::VARCHAR,
    l.cliente_id::VARCHAR,
    l.veiculo_id::VARCHAR,
    l.retirada_real::DATE,
    COALESCE(l.devolucao_real, l.devolucao_prevista)::DATE,
    COALESCE(l.valor_final, l.valor_previsto),
    CASE 
        WHEN l.devolucao_real IS NOT NULL THEN 'Concluída'
        ELSE 'Em Andamento'
    END,
    l.patio_retirada_id::VARCHAR,
    l.patio_devolucao_id::VARCHAR,
    'BRJCM' AS fonte_dados
FROM BRJCM.locacoes l;

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
    NULL AS veiculo_id,  -- apenas grupo de veículo disponível
    r.patio_retirada_id::VARCHAR,
    r.retirada_prevista::DATE,
    r.devolucao_prevista::DATE,
    r.situacao_reserva,
    'BRJCM' AS fonte_dados
FROM BRJCM.reservas r;

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
    p.endereco,
    v.veiculo_id::VARCHAR,
    'BRJCM' AS fonte_dados
FROM BRJCM.patios p
LEFT JOIN BRJCM.vagas vg ON vg.patio_id = p.patio_id
LEFT JOIN BRJCM.veiculos v ON v.vaga_atual_id = vg.vaga_id;

-- rickauer/extração.sql
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


-- wesleyConceicao/extracao.sql
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
