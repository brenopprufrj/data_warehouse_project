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
