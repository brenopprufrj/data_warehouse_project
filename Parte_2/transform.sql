-- ========================================
-- CLIENTE
-- ========================================

-- Adiciona campo unificado para tipo de pessoa textual
ALTER TABLE staging.cliente ADD COLUMN tipo_pessoa_desc VARCHAR;

UPDATE staging.cliente
SET tipo_pessoa_desc = CASE
    WHEN tipo_pessoa IN ('F', 'f', 'PF') THEN 'Pessoa Física'
    WHEN tipo_pessoa IN ('J', 'j', 'PJ') THEN 'Pessoa Jurídica'
    ELSE 'Não Informado'
END;

-- Padroniza CPF/CNPJ: remove caracteres especiais
UPDATE staging.cliente
SET cpf_cnpj = REGEXP_REPLACE(cpf_cnpj, '[^0-9]', '', 'g');

-- Padroniza nome (remover espaços desnecessários e normalizar caixa)
UPDATE staging.cliente
SET nome = INITCAP(TRIM(nome));

-- ========================================
-- FROTA
-- ========================================

-- Adiciona campo com grupo padronizado
ALTER TABLE staging.frota ADD COLUMN grupo_padronizado VARCHAR;

UPDATE staging.frota
SET grupo_padronizado = CASE
    WHEN grupo_nome ILIKE '%economico%' OR grupo_nome ILIKE '%econômico%' THEN 'Econômico'
    WHEN grupo_nome ILIKE '%sedan%' THEN 'Sedan'
    WHEN grupo_nome ILIKE '%suv%' THEN 'SUV'
    WHEN grupo_nome ILIKE '%luxo%' THEN 'Luxo'
    WHEN grupo_nome IS NULL THEN 'Desconhecido'
    ELSE INITCAP(grupo_nome)
END;

-- Normaliza modelo
UPDATE staging.frota
SET modelo = INITCAP(TRIM(COALESCE(modelo, 'Não Informado')));

-- ========================================
-- LOCACAO
-- ========================================

-- Adiciona coluna para tempo de locação (em dias)
ALTER TABLE staging.locacao ADD COLUMN duracao_dias INTEGER;

UPDATE staging.locacao
SET duracao_dias = GREATEST(
    DATE_PART('day', data_fim - data_inicio)::INTEGER,
    0
);

-- Padroniza status de locação
UPDATE staging.locacao
SET status = CASE
    WHEN status ILIKE '%conclu%' OR status ILIKE '%finaliz%' THEN 'Concluída'
    WHEN status ILIKE '%andamento%' OR status ILIKE '%ativa%' THEN 'Em Andamento'
    WHEN status ILIKE '%cancel%' THEN 'Cancelada'
    ELSE 'Outro'
END;

-- ========================================
-- RESERVA
-- ========================================

-- Adiciona coluna com duração da reserva
ALTER TABLE staging.reserva ADD COLUMN duracao_dias INTEGER;

UPDATE staging.reserva
SET duracao_dias = GREATEST(
    DATE_PART('day', data_fim - data_inicio)::INTEGER,
    0
);

-- Padroniza status de reserva
UPDATE staging.reserva
SET status = CASE
    WHEN status ILIKE '%ativa%' THEN 'Ativa'
    WHEN status ILIKE '%expirada%' OR status ILIKE '%cancel%' THEN 'Cancelada'
    WHEN status ILIKE '%conclu%' THEN 'Concluída'
    ELSE 'Outro'
END;

-- ========================================
-- PATIO
-- ========================================

-- Padroniza nome da localização
UPDATE staging.patio
SET localizacao = INITCAP(TRIM(localizacao));

-- ========================================
-- GERAL: Preenche valores nulos com padrão
-- ========================================

UPDATE staging.frota
SET tarifa_diaria = COALESCE(tarifa_diaria, 0);

UPDATE staging.locacao
SET valor_total = COALESCE(valor_total, 0);

UPDATE staging.cliente
SET endereco_cidade = COALESCE(endereco_cidade, 'Não Informado'),
    endereco_estado = COALESCE(endereco_estado, 'Não Informado');

