-- Corrigir tipo_pessoa se não for VARCHAR (só execute se necessário)
-- ALTER TABLE staging.cliente ALTER COLUMN tipo_pessoa TYPE VARCHAR;

-- Padronizar tipo de pessoa
UPDATE staging.cliente
SET
    nome = TRIM(nome),
    tipo_pessoa = CASE
        WHEN tipo_pessoa ILIKE 'pf' THEN 'PF'
        WHEN tipo_pessoa ILIKE 'pj' THEN 'PJ'
        WHEN tipo_pessoa ILIKE 'F%' THEN 'PF'
        WHEN tipo_pessoa ILIKE 'J%' THEN 'PJ'
        ELSE 'NA'
    END;

-- Padronizar nome de grupo de veículos
UPDATE staging.frota
SET grupo_nome = COALESCE(INITCAP(TRIM(grupo_nome)), 'Grupo Indefinido');

-- Corrigir duração em locação (sem date_part)
ALTER TABLE staging.locacao ADD COLUMN duracao_dias INT;

UPDATE staging.locacao
SET duracao_dias = CASE
    WHEN data_inicio IS NOT NULL AND data_fim IS NOT NULL THEN
        GREATEST((data_fim - data_inicio), 0)
    ELSE NULL
END;

-- Padronizar status de locação
UPDATE staging.locacao
SET status = CASE
    WHEN status ILIKE '%conclu%' THEN 'Concluída'
    WHEN status ILIKE '%andamento%' THEN 'Em Andamento'
    WHEN status ILIKE '%ativa%' THEN 'Ativa'
    WHEN status ILIKE '%pendente%' THEN 'Pendente'
    WHEN status ILIKE '%cancel%' THEN 'Cancelada'
    ELSE 'Desconhecido'
END;

-- Corrigir duração em reserva
ALTER TABLE staging.reserva ADD COLUMN duracao_dias INT;

UPDATE staging.reserva
SET duracao_dias = CASE
    WHEN data_inicio IS NOT NULL AND data_fim IS NOT NULL THEN
        GREATEST((data_fim - data_inicio), 0)
    ELSE NULL
END;

-- Padronizar status da reserva
UPDATE staging.reserva
SET status = CASE
    WHEN status ILIKE '%confirm%' THEN 'Confirmada'
    WHEN status ILIKE '%ativa%' THEN 'Ativa'
    WHEN status ILIKE '%pendente%' THEN 'Pendente'
    WHEN status ILIKE '%cancel%' THEN 'Cancelada'
    ELSE 'Desconhecido'
END;

-- Padronizar localizacao no pátio (corrigir tabela correta!)
UPDATE staging.patio
SET localizacao = INITCAP(TRIM(localizacao));
