-- brenopprufrj/script.sql
/*
Grupo: Breno Valente Manhães - 122038517; João Pedro Moretti Fontes Ferreira - 122081366; Murilo Jorge de Figueiredo - 122079597
*/
DROP SCHEMA IF EXISTS breno CASCADE;

CREATE SCHEMA breno;

SET search_path TO breno;

CREATE TABLE CLIENTE (
  cliente_id     SERIAL PRIMARY KEY,
  tipo           CHAR(1)       NOT NULL CHECK (tipo IN ('F','J')),
  nome_razao     VARCHAR(100)  NOT NULL,
  cpf_cnpj       CHAR(14)      NOT NULL UNIQUE,
  telefone       VARCHAR(20),
  email          VARCHAR(100)
);

CREATE TABLE CONDUTOR (
  condutor_id    SERIAL PRIMARY KEY,
  cliente_id     INT           NOT NULL,
  nome           VARCHAR(100)  NOT NULL,
  cnh_numero     VARCHAR(20)   NOT NULL UNIQUE,
  cnh_categoria  VARCHAR(2)    NOT NULL,
  cnh_validade   DATE          NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES CLIENTE(cliente_id)
);

CREATE TABLE GRUPO_VEICULO (
  grupo_id       SERIAL PRIMARY KEY,
  nome           VARCHAR(50)   NOT NULL UNIQUE,
  tarifa_diaria  DECIMAL(10,2) NOT NULL
);

CREATE TABLE VEICULO (
  veiculo_id     SERIAL PRIMARY KEY,
  grupo_id       INT           NOT NULL,
  placa          CHAR(7)       NOT NULL UNIQUE,
  chassis        VARCHAR(17)   NOT NULL UNIQUE,
  marca          VARCHAR(50)   NOT NULL,
  modelo         VARCHAR(50)   NOT NULL,
  cor            VARCHAR(30),
  mecanizacao    VARCHAR(10)   NOT NULL CHECK (mecanizacao IN ('Manual','Auto')),
  ar_condicionado BOOLEAN       NOT NULL,
  cadeirinha     BOOLEAN       NOT NULL,
  FOREIGN KEY (grupo_id) REFERENCES GRUPO_VEICULO(grupo_id)
);

CREATE TABLE PRONTUARIO (
  prontuario_id  SERIAL PRIMARY KEY,
  veiculo_id     INT           NOT NULL,
  data_registro  TIMESTAMP     NOT NULL,
  descricao      TEXT,
  FOREIGN KEY (veiculo_id) REFERENCES VEICULO(veiculo_id)
);

CREATE TABLE FOTO_VEICULO (
  foto_id        SERIAL PRIMARY KEY,
  veiculo_id     INT           NOT NULL,
  url            VARCHAR(255)  NOT NULL,
  tipo           VARCHAR(20)   NOT NULL,
  FOREIGN KEY (veiculo_id) REFERENCES VEICULO(veiculo_id)
);

CREATE TABLE PATIO (
  patio_id       SERIAL PRIMARY KEY,
  nome           VARCHAR(100)  NOT NULL UNIQUE,
  localizacao    VARCHAR(150)
);

CREATE TABLE VAGA (
  vaga_id        SERIAL PRIMARY KEY,
  patio_id       INT           NOT NULL,
  codigo         VARCHAR(10)   NOT NULL,
  FOREIGN KEY (patio_id) REFERENCES PATIO(patio_id)
);

CREATE TABLE RESERVA (
  reserva_id           SERIAL PRIMARY KEY,
  cliente_id           INT           NOT NULL,
  grupo_id             INT           NOT NULL,
  data_inicio          DATE          NOT NULL,
  data_fim_previsto    DATE          NOT NULL,
  patio_retirada_id    INT           NOT NULL,
  status               VARCHAR(20)   NOT NULL CHECK (status IN ('Ativa','Cancelada','Concluída')),
  FOREIGN KEY (cliente_id)        REFERENCES CLIENTE(cliente_id),
  FOREIGN KEY (grupo_id)          REFERENCES GRUPO_VEICULO(grupo_id),
  FOREIGN KEY (patio_retirada_id) REFERENCES PATIO(patio_id)
);

CREATE TABLE LOCACAO (
  locacao_id            SERIAL PRIMARY KEY,
  reserva_id            INT,
  condutor_id           INT           NOT NULL,
  veiculo_id            INT           NOT NULL,
  data_retirada         TIMESTAMP     NOT NULL,
  patio_saida_id        INT           NOT NULL,
  data_devolucao_prevista TIMESTAMP   NOT NULL,
  data_devolucao_real   TIMESTAMP,
  patio_chegada_id      INT,
  estado_entrega        TEXT,
  estado_devolucao      TEXT,
  FOREIGN KEY (reserva_id)       REFERENCES RESERVA(reserva_id),
  FOREIGN KEY (condutor_id)      REFERENCES CONDUTOR(condutor_id),
  FOREIGN KEY (veiculo_id)       REFERENCES VEICULO(veiculo_id),
  FOREIGN KEY (patio_saida_id)   REFERENCES PATIO(patio_id),
  FOREIGN KEY (patio_chegada_id) REFERENCES PATIO(patio_id)
);

CREATE TABLE PROTECAO_ADICIONAL (
  protecao_id    SERIAL PRIMARY KEY,
  descricao      VARCHAR(100)  NOT NULL
);

CREATE TABLE LOCACAO_PROTECAO (
  locacao_id     INT           NOT NULL,
  protecao_id    INT           NOT NULL,
  PRIMARY KEY (locacao_id, protecao_id),
  FOREIGN KEY (locacao_id)  REFERENCES LOCACAO(locacao_id),
  FOREIGN KEY (protecao_id) REFERENCES PROTECAO_ADICIONAL(protecao_id)
);

CREATE TABLE COBRANCA (
  cobranca_id      SERIAL PRIMARY KEY,
  locacao_id       INT           NOT NULL,
  data_cobranca    TIMESTAMP     NOT NULL,
  valor_base       DECIMAL(12,2) NOT NULL,
  valor_final      DECIMAL(12,2),
  status_pagamento VARCHAR(20)   NOT NULL CHECK (status_pagamento IN ('Pendente','Pago','Cancelado')),
  FOREIGN KEY (locacao_id) REFERENCES LOCACAO(locacao_id)
);

-- BRJCM/script.sql

-- Esquema de Banco de Dados: Sistema de Locadora de Veículos
-- Brian José Costa de Medeiro                     DRE:121087678

DROP SCHEMA IF EXISTS BRJCM CASCADE;

CREATE SCHEMA BRJCM;

SET search_path TO BRJCM;


-- 1. Clientes (Pessoa Física ou Jurídica)
CREATE TABLE clientes (
    cliente_id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nome_completo VARCHAR(255) NOT NULL,
    cpf_cnpj     VARCHAR(18)  NOT NULL UNIQUE,
    tipo_pessoa  CHAR(1)      NOT NULL 
                      CHECK (tipo_pessoa IN ('F','J')),
    email        VARCHAR(100) NOT NULL UNIQUE,
    telefone     VARCHAR(20)  NOT NULL,
    endereco_cidade VARCHAR(100),
    endereco_estado VARCHAR(50),
    data_cadastro TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);


-- 2. Motoristas (Condutores habilitados)
CREATE TABLE motoristas (
    motorista_id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    cliente_id     INTEGER     NOT NULL 
                       REFERENCES clientes(cliente_id),
    nome_completo  VARCHAR(255) NOT NULL,
    cnh            VARCHAR(11)  NOT NULL UNIQUE,
    cnh_categoria  VARCHAR(5)   NOT NULL,
    cnh_validade   DATE         NOT NULL
);


-- 3. Pátios de Estacionamento
CREATE TABLE patios (
    patio_id     INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL UNIQUE,
    endereco     VARCHAR(255) NOT NULL,
    criado_em    TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);


-- 4. Vagas em cada Pátio
CREATE TABLE vagas (
    vaga_id     INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    patio_id    INTEGER NOT NULL 
                   REFERENCES patios(patio_id),
    codigo      VARCHAR(20) NOT NULL,
    ocupada     BOOLEAN DEFAULT FALSE,
    CONSTRAINT uq_vaga_por_patio UNIQUE (patio_id, codigo)
);


-- 5. Grupos (Categorias) de Veículos
CREATE TABLE grupos_veiculos (
    grupo_id           INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nome_grupo         VARCHAR(50) NOT NULL UNIQUE,
    descricao_grupo    TEXT,
    tarifa_diaria_base DECIMAL(10,2) NOT NULL 
                        CHECK (tarifa_diaria_base > 0)
);


-- 6. Frota de Veículos
CREATE TABLE veiculos (
    veiculo_id       INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    placa             VARCHAR(10)  NOT NULL UNIQUE,
    chassi            VARCHAR(17)  NOT NULL UNIQUE,
    grupo_id          INTEGER      NOT NULL 
                        REFERENCES grupos_veiculos(grupo_id),
    vaga_atual_id     INTEGER      UNIQUE 
                        REFERENCES vagas(vaga_id),
    marca             VARCHAR(50)  NOT NULL,
    modelo            VARCHAR(50)  NOT NULL,
    cor               VARCHAR(30)  NOT NULL,
    ano_fabricacao    INTEGER      NOT NULL,
    cambio            VARCHAR(20)  NOT NULL 
                        CHECK (cambio IN ('Manual','Automática')),
    possui_ar_cond    BOOLEAN      NOT NULL,
    situacao          VARCHAR(20)  NOT NULL DEFAULT 'Disponível'
                        CHECK (situacao IN ('Disponível','Alugado','Manutenção'))
);


-- 7. Reservas de Veículos
CREATE TABLE reservas (
    reserva_id             INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    cliente_id             INTEGER     NOT NULL 
                             REFERENCES clientes(cliente_id),
    grupo_id               INTEGER     NOT NULL 
                             REFERENCES grupos_veiculos(grupo_id),
    patio_retirada_id      INTEGER     NOT NULL 
                             REFERENCES patios(patio_id),
    criado_em              TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    retirada_prevista      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    devolucao_prevista     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    situacao_reserva       VARCHAR(20) DEFAULT 'Ativa'
                             CHECK (situacao_reserva 
                                    IN ('Ativa','Cancelada','Concluída')),
    CONSTRAINT chk_retorno 
       CHECK (devolucao_prevista > retirada_prevista)
);


-- 8. Locações (Aluguéis) de Veículos
CREATE TABLE locacoes (
    locacao_id           INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    reserva_id           INTEGER UNIQUE 
                             REFERENCES reservas(reserva_id),
    cliente_id           INTEGER     NOT NULL 
                             REFERENCES clientes(cliente_id),
    motorista_id         INTEGER     NOT NULL 
                             REFERENCES motoristas(motorista_id),
    veiculo_id           INTEGER     NOT NULL 
                             REFERENCES veiculos(veiculo_id),
    patio_retirada_id    INTEGER     NOT NULL 
                             REFERENCES patios(patio_id),
    patio_devolucao_id   INTEGER     REFERENCES patios(patio_id),
    retirada_real        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    devolucao_prevista   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    devolucao_real       TIMESTAMP WITHOUT TIME ZONE,
    valor_previsto       DECIMAL(10,2) NOT NULL,
    valor_final          DECIMAL(10,2),
    protecoes_extras     TEXT,
    CONSTRAINT chk_previsto_retirada 
      CHECK (devolucao_prevista > retirada_real),
    CONSTRAINT chk_real_maior 
      CHECK (devolucao_real IS NULL 
             OR devolucao_real > retirada_real)
);


-- 9. Cobranças de Locações
CREATE TABLE cobrancas (
    cobranca_id   INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    locacao_id    INTEGER NOT NULL 
                    REFERENCES locacoes(locacao_id),
    valor         DECIMAL(10,2) NOT NULL,
    emitida_em    TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    vencimento    DATE    NOT NULL,
    pago_em       DATE,
    status_pago   VARCHAR(20) NOT NULL DEFAULT 'Pendente'
                   CHECK (status_pago 
                          IN ('Pendente','Pago','Atrasado'))
);


-- 10. Acessórios Opcionais
CREATE TABLE acessorios (
    acessorio_id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nome_acessorio VARCHAR(100) NOT NULL UNIQUE,
    descricao_acessorio TEXT
);


-- 11. Associação Veículos ↔ Acessórios
CREATE TABLE veiculos_acessorios (
    veiculo_id    INTEGER NOT NULL 
                   REFERENCES veiculos(veiculo_id),
    acessorio_id  INTEGER NOT NULL 
                   REFERENCES acessorios(acessorio_id),
    PRIMARY KEY (veiculo_id, acessorio_id)
);


-- 12. Prontuários de Veículos (Histórico de Manutenção/Avarias)
CREATE TABLE prontuarios_veiculos (
    prontuario_id  INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    veiculo_id     INTEGER NOT NULL 
                   REFERENCES veiculos(veiculo_id),
    data_evento    DATE    NOT NULL,
    tipo_evento    VARCHAR(50) NOT NULL 
                   CHECK (tipo_evento 
                          IN ('Manutenção Preventiva',
                              'Manutenção Corretiva',
                              'Revisão','Avaria')),
    detalhes       TEXT    NOT NULL,
    custo_evento   DECIMAL(10,2)
);


-- 13. Fotos de Veículos
CREATE TABLE fotos_veiculos (
    foto_id       INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    veiculo_id    INTEGER NOT NULL 
                   REFERENCES veiculos(veiculo_id),
    caminho_imagem VARCHAR(255) NOT NULL,
    finalidade     VARCHAR(50) 
                   CHECK (finalidade 
                          IN ('Propaganda','Entrega','Devolução')),
    enviado_em     TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

-- rickauer/script.sql
DROP SCHEMA IF EXISTS rickauer CASCADE;

CREATE SCHEMA rickauer;

SET search_path TO rickauer;


-- Guilherme Oliveira Rolim Silva - DRE: 122076696

-- Ricardo Lorente Kauer - DRE: 122100500

-- Vinícius Alcântara Gomes Reis de Souza - DRE: 122060831
CREATE TABLE locadora (
    id_locadora          SERIAL PRIMARY KEY,
    nome_locadora        VARCHAR(255) NOT NULL UNIQUE,
    cnpj                 VARCHAR(20)  NOT NULL UNIQUE
);

-- Tabela: patio
CREATE TABLE patio (
    id_patio             SERIAL PRIMARY KEY,
    id_locadora          INTEGER     NOT NULL
        REFERENCES locadora(id_locadora)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    nome_patio           VARCHAR(255) NOT NULL,
    endereco_patio       VARCHAR(500) NOT NULL
);

-- Tabela: vaga
CREATE TABLE vaga (
    id_vaga              SERIAL PRIMARY KEY,
    id_patio             INTEGER     NOT NULL
        REFERENCES patio(id_patio)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    status_vaga          VARCHAR(50)  NOT NULL
);

-- Tabela: grupo_veiculo
CREATE TABLE grupo_veiculo (
    id_grupo_veiculo     SERIAL PRIMARY KEY,
    nome_grupo           VARCHAR(100) NOT NULL UNIQUE,
    faixa_valor          NUMERIC(12,2) NOT NULL
);

-- Tabela: veiculo
CREATE TABLE veiculo (
    id_veiculo                   SERIAL PRIMARY KEY,
    id_grupo_veiculo             INTEGER     NOT NULL
        REFERENCES grupo_veiculo(id_grupo_veiculo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    id_locadora_proprietaria     INTEGER     NOT NULL
        REFERENCES locadora(id_locadora)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    id_vaga_atual                INTEGER     NULL
        REFERENCES vaga(id_vaga)
        ON UPDATE CASCADE ON DELETE SET NULL,
    placa                        VARCHAR(12)  NOT NULL UNIQUE,
    chassi                       VARCHAR(50)  NOT NULL UNIQUE,
    cor                          VARCHAR(50)  NOT NULL,
    status_veiculo               VARCHAR(50)  NOT NULL,
    mecanizacao                  BOOLEAN     NOT NULL,
    ar_condicionado              BOOLEAN     NOT NULL,
    marca                        VARCHAR(100) NOT NULL
);

-- Tabela: prontuario (registros de manutenção)
CREATE TABLE prontuario (
    id_registro_manutencao       SERIAL PRIMARY KEY,
    id_veiculo                   INTEGER     NOT NULL
        REFERENCES veiculo(id_veiculo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    data_ultima_manutencao       DATE        NOT NULL,
    estado_conservacao           VARCHAR(100) NOT NULL,
    caracteristica_rodagem       VARCHAR(100) NOT NULL,
    pressao_pneus                NUMERIC(6,2) NOT NULL,
    nivel_oleo                   NUMERIC(6,2) NOT NULL
);

-- Tabela: foto_veiculo
CREATE TABLE foto_veiculo (
    id_foto_veiculo              SERIAL PRIMARY KEY,
    id_veiculo                   INTEGER     NOT NULL
        REFERENCES veiculo(id_veiculo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    tipo_foto                    VARCHAR(50)  NOT NULL,
    data_foto                    TIMESTAMP    NOT NULL
);

-- Tabela: veiculo_acessorio (associativa)
CREATE TABLE veiculo_acessorio (
    id_veiculo_acessorio         SERIAL PRIMARY KEY,
    id_veiculo                   INTEGER     NOT NULL
        REFERENCES veiculo(id_veiculo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    nome                         VARCHAR(100) NOT NULL,
    valor                        NUMERIC(10,2) NOT NULL
);

-- Tabela: cliente (superclasse)
CREATE TABLE cliente (
    id_cliente                   SERIAL PRIMARY KEY,
    tipo_cliente                 VARCHAR(20)   NOT NULL,
    data_cadastro                TIMESTAMP     NOT NULL,
    email                        VARCHAR(255)  NOT NULL UNIQUE,
    telefone_principal           VARCHAR(20)   NOT NULL
);

-- Tabela: pessoa_fisica (subclasse de cliente)
CREATE TABLE pessoa_fisica (
    id_cliente                   INTEGER     PRIMARY KEY
        REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE ON DELETE CASCADE,
    nome_completo                VARCHAR(255) NOT NULL,
    cpf                          VARCHAR(14)  NOT NULL UNIQUE,
    data_nascimento              DATE         NOT NULL
);

-- Tabela: pessoa_juridica (subclasse de cliente)
CREATE TABLE pessoa_juridica (
    id_cliente                   INTEGER     PRIMARY KEY
        REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE ON DELETE CASCADE,
    nome_empresa                 VARCHAR(255) NOT NULL UNIQUE,
    cnpj                         VARCHAR(20)  NOT NULL UNIQUE
);

-- Tabela: motorista
CREATE TABLE motorista (
    id_motorista                 SERIAL PRIMARY KEY,
    id_pessoa_fisica             INTEGER     NOT NULL UNIQUE
        REFERENCES pessoa_fisica(id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Tabela: cnh
CREATE TABLE cnh (
    id_cnh                       SERIAL PRIMARY KEY,
    id_motorista                 INTEGER     NOT NULL UNIQUE
        REFERENCES motorista(id_motorista)
        ON UPDATE CASCADE ON DELETE CASCADE,
    numero_cnh                   VARCHAR(20)  NOT NULL UNIQUE,
    categoria_cnh                VARCHAR(5)   NOT NULL,
    data_validade               DATE         NOT NULL
);

-- Tabela: reserva
CREATE TABLE reserva (
    id_reserva                   SERIAL PRIMARY KEY,
    id_veiculo                   INTEGER     NOT NULL
        REFERENCES veiculo(id_veiculo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    data_hora_reserva_inicio     TIMESTAMP    NOT NULL,
    data_hora_retirada_fim       TIMESTAMP    NOT NULL
);

-- Tabela: contrato (locação)
CREATE TABLE contrato (
    id_contrato                  SERIAL PRIMARY KEY,
    id_reserva                   INTEGER     NULL
        REFERENCES reserva(id_reserva)
        ON UPDATE CASCADE ON DELETE SET NULL,
    id_cliente                   INTEGER     NOT NULL
        REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    id_locadora                  INTEGER     NOT NULL
        REFERENCES locadora(id_locadora)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    id_motorista                 INTEGER     NOT NULL
        REFERENCES motorista(id_motorista)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    id_veiculo                   INTEGER     NOT NULL
        REFERENCES veiculo(id_veiculo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    id_patio_retirada            INTEGER     NOT NULL
        REFERENCES patio(id_patio)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    id_patio_devolucao_efetiva   INTEGER     NULL
        REFERENCES patio(id_patio)
        ON UPDATE CASCADE ON DELETE SET NULL,
    data_hora_contrato           TIMESTAMP    NOT NULL,
    status_locacao               VARCHAR(50)  NOT NULL
);

-- Tabela: protecao_adicional (associativa Contrato ↔ Proteção Adicional)
CREATE TABLE protecao_adicional (
    id_protecao_adicional        SERIAL PRIMARY KEY,
    id_contrato                  INTEGER     NOT NULL
        REFERENCES contrato(id_contrato)
        ON UPDATE CASCADE ON DELETE CASCADE,
    nome_protecao                VARCHAR(100) NOT NULL,
    valor_cobrado                NUMERIC(10,2) NOT NULL
);

-- Tabela: cobranca (fatura)
CREATE TABLE cobranca (
    id_fatura                    SERIAL PRIMARY KEY,
    id_contrato                  INTEGER     NOT NULL
        REFERENCES contrato(id_contrato)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    numero_fatura                VARCHAR(50)  NOT NULL UNIQUE,
    data_emissao                 DATE         NOT NULL,
    valor                        NUMERIC(12,2) NOT NULL,
    status_fatura                VARCHAR(50)  NOT NULL
);

-- wesleyConceicao/script.sql
--- ALUNO: WESLEY CONCEIÇÃO DA SILVA
--- DRE: 118096333

DROP SCHEMA IF EXISTS WesleyConceicao CASCADE;

CREATE SCHEMA WesleyConceicao;

SET search_path TO WesleyConceicao;

CREATE TABLE CLIENTE (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    tipo CHAR(2) CHECK (tipo IN ('PF', 'PJ')) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(15),
    cnh VARCHAR(20) NOT NULL,
    validade_cnh DATE NOT NULL,
    categoria_cnh CHAR(2)
);

CREATE TABLE VEICULO (
    id_veiculo INT PRIMARY KEY,
    placa VARCHAR(7) UNIQUE,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    chassi VARCHAR(20) UNIQUE NOT NULL,
    cor VARCHAR(20),
    cliente_id INT,
    FOREIGN KEY (cliente_id) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE PATIO (
    id_patio INT PRIMARY KEY,
    localizacao VARCHAR(100),
	veiculo_id INT,
	FOREIGN KEY (veiculo_id) REFERENCES VEICULO(id_veiculo)
);

CREATE TABLE RESERVA (
    id_reserva INT PRIMARY KEY,
    cliente_id INT,
    patio_retirada_id INT,
    veiculo_id INT,
	data_inicio DATE,
    data_fim DATE,
    status VARCHAR(20),
	FOREIGN KEY (veiculo_id) REFERENCES VEICULO(id_veiculo),
    FOREIGN KEY (cliente_id) REFERENCES CLIENTE(id_cliente),
    FOREIGN KEY (patio_retirada_id) REFERENCES PATIO(id_patio)
);

CREATE TABLE LOCACAO (
    id_locacao INT PRIMARY KEY,
    reserva_id INT,
    veiculo_id INT,
    cliente_id INT,
    patio_entrega_id INT,
    valor_total DECIMAL(10,2),
    FOREIGN KEY (reserva_id) REFERENCES RESERVA(id_reserva),
    FOREIGN KEY (veiculo_id) REFERENCES VEICULO(id_veiculo),
    FOREIGN KEY (patio_entrega_id) REFERENCES PATIO(id_patio),
	FOREIGN KEY (cliente_id) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE COBRANCA (
    id_cobranca INT PRIMARY KEY,
    locacao_id INT,
    data_pagamento DATE,
    valor_pago DECIMAL(10,2),
    forma_pagamento VARCHAR(20),
    FOREIGN KEY (locacao_id) REFERENCES LOCACAO(id_locacao)
);
