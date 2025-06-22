-- Grupo: Breno Valente Manhães - 122038517; João Pedro Moretti Fontes Ferreira - 122081366; Murilo Jorge de Figueiredo - 122079597

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
