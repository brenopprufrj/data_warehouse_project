-- CLIENTE
INSERT INTO breno.CLIENTE (tipo, nome_razao, cpf_cnpj, telefone, email)
VALUES 
  ('F', 'João da Silva', '12345678901234', '21999999999', 'joao@gmail.com'),
  ('J', 'Empresa X Ltda', '56789012345678', '2133334444', 'contato@empresax.com');

-- CONDUTOR
INSERT INTO breno.CONDUTOR (cliente_id, nome, cnh_numero, cnh_categoria, cnh_validade)
VALUES (1, 'João da Silva', 'CNH123456', 'B', '2026-01-01');

-- GRUPO_VEICULO
INSERT INTO breno.GRUPO_VEICULO (nome, tarifa_diaria)
VALUES ('Econômico', 100.00);

-- VEICULO
INSERT INTO breno.VEICULO (grupo_id, placa, chassis, marca, modelo, cor, mecanizacao, ar_condicionado, cadeirinha)
VALUES (1, 'ABC1234', '9BWZZZ377VT004251', 'Volkswagen', 'Gol', 'Branco', 'Manual', true, false);

-- PRONTUARIO
INSERT INTO breno.PRONTUARIO (veiculo_id, data_registro, descricao)
VALUES (1, NOW(), 'Troca de óleo');

-- FOTO_VEICULO
INSERT INTO breno.FOTO_VEICULO (veiculo_id, url, tipo)
VALUES (1, 'http://img.com/gol.jpg', 'Entrega');

-- PATIO
INSERT INTO breno.PATIO (nome, localizacao)
VALUES ('Pátio Central', 'Av. Brasil, 1000');

-- VAGA
INSERT INTO breno.VAGA (patio_id, codigo)
VALUES (1, 'A01');

-- RESERVA
INSERT INTO breno.RESERVA (cliente_id, grupo_id, data_inicio, data_fim_previsto, patio_retirada_id, status)
VALUES (1, 1, '2025-06-01', '2025-06-05', 1, 'Ativa');

-- LOCACAO
INSERT INTO breno.LOCACAO (reserva_id, condutor_id, veiculo_id, data_retirada, patio_saida_id, data_devolucao_prevista)
VALUES (1, 1, 1, '2025-06-01 10:00', 1, '2025-06-05 10:00');

-- PROTECAO_ADICIONAL
INSERT INTO breno.PROTECAO_ADICIONAL (descricao)
VALUES ('Seguro total');

-- LOCACAO_PROTECAO
INSERT INTO breno.LOCACAO_PROTECAO (locacao_id, protecao_id)
VALUES (1, 1);

-- COBRANCA
INSERT INTO breno.COBRANCA (locacao_id, data_cobranca, valor_base, valor_final, status_pagamento)
VALUES (1, NOW(), 400.00, 450.00, 'Pendente');

-- CLIENTES
INSERT INTO BRJCM.clientes (nome_completo, cpf_cnpj, tipo_pessoa, email, telefone)
VALUES ('Maria Oliveira', '12345678901', 'F', 'maria@exemplo.com', '2199887766');

-- MOTORISTAS
INSERT INTO BRJCM.motoristas (cliente_id, nome_completo, cnh, cnh_categoria, cnh_validade)
VALUES (1, 'Maria Oliveira', '98765432100', 'B', '2026-12-31');

-- PATIOS
INSERT INTO BRJCM.patios (nome, endereco)
VALUES ('Pátio Sul', 'Rua das Flores, 123');

-- VAGAS
INSERT INTO BRJCM.vagas (patio_id, codigo)
VALUES (1, 'B01');

-- GRUPOS_VEICULOS
INSERT INTO BRJCM.grupos_veiculos (nome_grupo, descricao_grupo, tarifa_diaria_base)
VALUES ('SUV', 'Utilitários esportivos', 150.00);

-- VEICULOS
INSERT INTO BRJCM.veiculos (placa, chassi, grupo_id, vaga_atual_id, marca, modelo, cor, ano_fabricacao, cambio, possui_ar_cond)
VALUES ('XYZ1234', '1HGCM82633A123456', 1, 1, 'Honda', 'CR-V', 'Prata', 2022, 'Automática', TRUE);

-- RESERVAS
INSERT INTO BRJCM.reservas (cliente_id, grupo_id, patio_retirada_id, retirada_prevista, devolucao_prevista)
VALUES (1, 1, 1, '2025-06-20 08:00', '2025-06-25 08:00');

-- LOCACOES
INSERT INTO BRJCM.locacoes (reserva_id, cliente_id, motorista_id, veiculo_id, patio_retirada_id, retirada_real, devolucao_prevista, valor_previsto)
VALUES (1, 1, 1, 1, 1, '2025-06-20 08:00', '2025-06-25 08:00', 750.00);

-- COBRANCAS
INSERT INTO BRJCM.cobrancas (locacao_id, valor, vencimento)
VALUES (1, 750.00, '2025-06-30');

-- ACESSORIOS
INSERT INTO BRJCM.acessorios (nome_acessorio, descricao_acessorio)
VALUES ('GPS', 'Navegador por satélite');

-- VEICULOS_ACESSORIOS
INSERT INTO BRJCM.veiculos_acessorios (veiculo_id, acessorio_id)
VALUES (1, 1);

-- PRONTUARIOS_VEICULOS
INSERT INTO BRJCM.prontuarios_veiculos (veiculo_id, data_evento, tipo_evento, detalhes, custo_evento)
VALUES (1, '2025-05-01', 'Revisão', 'Revisão de 10.000km', 300.00);

-- FOTOS_VEICULOS
INSERT INTO BRJCM.fotos_veiculos (veiculo_id, caminho_imagem, finalidade)
VALUES (1, 'http://img.com/honda_crv.jpg', 'Entrega');

-- LOCADORA
INSERT INTO rickauer.locadora (nome_locadora, cnpj)
VALUES ('Locadora X', '12345678000199');

-- PATIO
INSERT INTO rickauer.patio (id_locadora, nome_patio, endereco_patio)
VALUES (1, 'Pátio Norte', 'Av. das Américas, 200');

-- VAGA
INSERT INTO rickauer.vaga (id_patio, status_vaga)
VALUES (1, 'Livre');

-- GRUPO_VEICULO
INSERT INTO rickauer.grupo_veiculo (nome_grupo, faixa_valor)
VALUES ('Compacto', 90.00);

-- VEICULO
INSERT INTO rickauer.veiculo (id_grupo_veiculo, id_locadora_proprietaria, id_vaga_atual, placa, chassi, cor, status_veiculo, mecanizacao, ar_condicionado, marca)
VALUES (1, 1, 1, 'DEF5678', '9Z123456789012345', 'Vermelho', 'Disponível', TRUE, TRUE, 'Fiat');

-- CLIENTE (pessoa física)
INSERT INTO rickauer.cliente (tipo_cliente, data_cadastro, email, telefone_principal)
VALUES ('F', NOW(), 'ana@exemplo.com', '2188887777');

INSERT INTO rickauer.pessoa_fisica (id_cliente, nome_completo, cpf, data_nascimento)
VALUES (1, 'Ana Souza', '23456789012', '1990-07-01');

-- MOTORISTA e CNH
INSERT INTO rickauer.motorista (id_pessoa_fisica)
VALUES (1);

INSERT INTO rickauer.cnh (id_motorista, numero_cnh, categoria_cnh, data_validade)
VALUES (1, 'CNH999999', 'B', '2026-08-01');

-- RESERVA
INSERT INTO rickauer.reserva (id_veiculo, data_hora_reserva_inicio, data_hora_retirada_fim)
VALUES (1, '2025-06-15 09:00', '2025-06-20 09:00');

-- CONTRATO
INSERT INTO rickauer.contrato (id_reserva, id_cliente, id_locadora, id_motorista, id_veiculo, id_patio_retirada, data_hora_contrato, status_locacao)
VALUES (1, 1, 1, 1, 1, 1, NOW(), 'Ativa');

-- PROTECAO_ADICIONAL
INSERT INTO rickauer.protecao_adicional (id_contrato, nome_protecao, valor_cobrado)
VALUES (1, 'Proteção contra terceiros', 50.00);

-- COBRANCA
INSERT INTO rickauer.cobranca (id_contrato, numero_fatura, data_emissao, valor, status_fatura)
VALUES (1, 'FAT001', '2025-06-20', 500.00, 'Pendente');

-- PRONTUARIO
INSERT INTO rickauer.prontuario (id_veiculo, data_ultima_manutencao, estado_conservacao, caracteristica_rodagem, pressao_pneus, nivel_oleo)
VALUES (1, '2025-05-10', 'Bom', 'Nova', 32.0, 4.5);

-- FOTO_VEICULO
INSERT INTO rickauer.foto_veiculo (id_veiculo, tipo_foto, data_foto)
VALUES (1, 'Entrega', NOW());

-- VEICULO_ACESSORIO
INSERT INTO rickauer.veiculo_acessorio (id_veiculo, nome, valor)
VALUES (1, 'Suporte de celular', 10.00);

-- CLIENTE
INSERT INTO WesleyConceicao.CLIENTE (id_cliente, nome, tipo, cpf_cnpj, email, telefone, cnh, validade_cnh, categoria_cnh)
VALUES (1, 'Carlos Henrique', 'PF', '12345678900', 'carlos@gmail.com', '21998765432', 'CNH101010', '2026-12-31', 'B');

-- VEICULO
INSERT INTO WesleyConceicao.VEICULO (id_veiculo, placa, marca, modelo, chassi, cor, cliente_id)
VALUES (1, 'GHI1234', 'Chevrolet', 'Onix', '2FACP73G4NX100000', 'Preto', 1);

-- PATIO
INSERT INTO WesleyConceicao.PATIO (id_patio, localizacao, veiculo_id)
VALUES (1, 'Rua Alfa, 456', 1);

-- RESERVA
INSERT INTO WesleyConceicao.RESERVA (id_reserva, cliente_id, patio_retirada_id, veiculo_id, data_inicio, data_fim, status)
VALUES (1, 1, 1, 1, '2025-06-15', '2025-06-18', 'Ativa');

-- LOCACAO
INSERT INTO WesleyConceicao.LOCACAO (id_locacao, reserva_id, veiculo_id, cliente_id, patio_entrega_id, valor_total)
VALUES (1, 1, 1, 1, 1, 300.00);

-- COBRANCA
INSERT INTO WesleyConceicao.COBRANCA (id_cobranca, locacao_id, data_pagamento, valor_pago, forma_pagamento)
VALUES (1, 1, '2025-06-18', 300.00, 'Cartão');
