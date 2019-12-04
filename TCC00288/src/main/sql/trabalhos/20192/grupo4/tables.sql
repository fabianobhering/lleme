-- deletar tabelas antigas
DROP TABLE IF EXISTS transacao;
DROP TABLE IF EXISTS conta;
DROP TABLE IF EXISTS negativacao;
DROP TABLE IF EXISTS agencia;
DROP TABLE IF EXISTS cliente;

-- criar novas tabelas
CREATE TABLE IF NOT EXISTS cliente (
	cpf CHAR(11) PRIMARY KEY,
	nome VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS agencia (
	id INTEGER PRIMARY KEY,
	permite_emprestimo BOOLEAN NOT NULL,
	horario_abertura TIME NOT NULL,
	horario_fechamento TIME NOT NULL,

	CONSTRAINT valid_interval CHECK (horario_fechamento > horario_abertura)
);

CREATE TABLE IF NOT EXISTS conta (
	id INTEGER PRIMARY KEY,
	limite INTEGER NOT NULL,
	dono CHAR(11) UNIQUE REFERENCES cliente(cpf) ON DELETE RESTRICT,
	agencia INTEGER REFERENCES agencia(id) ON DELETE RESTRICT,

	CONSTRAINT positive_limit CHECK (limite >= 0)
);

CREATE TABLE IF NOT EXISTS negativacao (
	inicio TIMESTAMP NOT NULL,
	fim TIMESTAMP,
	cliente CHAR(11) NOT NULL REFERENCES cliente(cpf) ON DELETE CASCADE,
	
	PRIMARY KEY (inicio, cliente),
	CONSTRAINT valid_interval CHECK (fim IS NULL OR fim > inicio)
);

CREATE TABLE IF NOT EXISTS transacao (
	id SERIAL PRIMARY KEY,
	valor FLOAT NOT NULL,
	_data TIMESTAMP NOT NULL,
	tipo VARCHAR(255) NOT NULL,

	conta_origem INTEGER REFERENCES conta(id) ON DELETE RESTRICT,
	conta_destino INTEGER REFERENCES conta(id) ON DELETE RESTRICT,

	CONSTRAINT positive_value CHECK (valor > 0),
	CONSTRAINT valid_type CHECK (UPPER(tipo) IN ('DEPOSITO', 'TRANSFERENCIA', 'EMPRESTIMO', 'SAQUE')),
	CONSTRAINT transacao_valida CHECK (conta_origem IS NOT NULL OR conta_destino IS NOT NULL),
	CONSTRAINT saque_valido CHECK (UPPER(tipo) <> 'SAQUE' OR conta_destino IS NULL),
	CONSTRAINT deposito_valido CHECK (UPPER(tipo) <> 'DEPOSITO' OR conta_origem IS NULL),
	CONSTRAINT tranferencia_ou_emprestimo_valido CHECK ((UPPER(tipo) <> 'TRANSFERENCIA' AND UPPER(tipo) <> 'EMPRESTIMO') OR
			   conta_origem IS NOT NULL AND conta_destino IS NOT NULL)
);
