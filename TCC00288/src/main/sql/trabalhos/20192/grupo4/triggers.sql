CREATE OR REPLACE FUNCTION VALIDA_AGENCIA(linha ANYELEMENT) RETURNS BOOLEAN AS $$

	DECLARE
		agencia_origem agencia%ROWTYPE;
		conta_origem conta%ROWTYPE;
		conta_destino conta%ROWTYPE;
		agencia_destino agencia%ROWTYPE;

	BEGIN
		RAISE NOTICE 'VALIDANDO AGENCIA';
		SELECT * INTO conta_origem FROM conta WHERE conta.id = linha.conta_origem;
		SELECT * INTO agencia_origem FROM agencia WHERE agencia.id = conta_origem.agencia;

		SELECT * INTO conta_destino FROM conta WHERE conta.id = linha.conta_destino;
		SELECT * INTO agencia_destino FROM agencia WHERE agencia.id = conta_destino.agencia;

		IF UPPER(linha.tipo) = 'EMPRESTIMO' AND agencia_destino.permite_emprestimo IS FALSE THEN
			RAISE NOTICE 'AGENCIA DESTINO NAO PERMITE EMPRESTIMO';
			RETURN FALSE;
		END IF;

		IF UPPER(linha.tipo) = 'DEPOSITO' THEN
			RETURN ((agencia_destino.horario_abertura <= linha._data::timestamp::time)
		AND (linha._data::timestamp::time <= agencia_destino.horario_fechamento));
		END IF;

		RETURN ((agencia_origem.horario_abertura <= linha._data::timestamp::time)
		AND (linha._data::timestamp::time <= agencia_origem.horario_fechamento));
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION VALIDA_CLIENTE(linha ANYELEMENT) RETURNS BOOLEAN AS $$

	DECLARE
		conta_destino conta%ROWTYPE;
		cliente_destino cliente%ROWTYPE;
		valor_emprestado FLOAT;

	BEGIN
		RAISE NOTICE 'VALIDANDO CLIENTE';
		SELECT * INTO conta_destino FROM conta WHERE conta.id = linha.conta_destino;
		SELECT * INTO cliente_destino FROM cliente WHERE cliente.cpf = conta_destino.dono;

		IF linha.tipo = 'EMPRESTIMO' THEN
			valor_emprestado = emprestado(linha.conta_destino);
			IF (valor_emprestado + linha.valor) > conta_destino.limite THEN
				RAISE NOTICE 'LIMITE DE EMPRESTIMO ESTOURADO';
				RETURN FALSE;
			END IF;
			RAISE NOTICE 'LIMITE VALIDO';
		END IF;

		RETURN NOT ESTA_NEGATIVADO(cliente_destino.cpf, linha._data);
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION VALIDA_TRANSACAO() RETURNS TRIGGER AS $$

	DECLARE

	BEGIN
		RAISE NOTICE 'INICIA VALIDACOES';

		IF VALIDA_AGENCIA(NEW) THEN
			RAISE NOTICE 'AGENCIA VALIDA';
			
			IF VALIDA_CLIENTE(NEW) THEN

				IF NEW.tipo = 'SAQUE' THEN
					IF saldo(NEW.conta_origem) < NEW.valor THEN
						RAISE NOTICE 'NAO HA DINHEIRO SUFICIENTE NA CONTA';
						RETURN NULL;
					END IF;
				END IF;

				RAISE NOTICE 'CLIENTE VALIDO';
				RAISE NOTICE 'REALIZANDO TRANSFERENCIA';
				RETURN NEW;
				
			ELSE
				RAISE NOTICE 'CLIENTE INVALIDO';
				
			END IF;

		ELSE
			RAISE NOTICE 'AGENCIA INVALIDA';
			
		END IF;

		RAISE NOTICE 'TRANSACAO CANCELADA';
		RETURN OLD;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION VALIDA_NEGATIVACAO() RETURNS TRIGGER AS $$
	DECLARE
		moves CURSOR(conta INTEGER) FOR SELECT * FROM transacao
		WHERE transacao.conta_destino = conta 
		AND UPPER(transacao.tipo) = 'EMPRESTIMO';

		anteriores CURSOR FOR SELECT * FROM negativacao
		WHERE negativacao.cliente = NEW.cliente;

		conta_cliente INTEGER;

	BEGIN
		RAISE NOTICE 'VALIDANDO NEGATIVACAO';

		SELECT conta.id FROM conta WHERE conta.dono = NEW.cliente INTO conta_cliente;

		FOR ant IN anteriores LOOP
			IF (ant.fim IS NULL) THEN
				IF (ant.inicio > NEW.fim) THEN
					RAISE NOTICE 'REGISTRO DE NEGATIVACAO INSERIDO';
					RETURN NEW;
				END IF;
				RAISE NOTICE 'O REGISTRO DE NEGATIVACAO NAO PODE SER INSERIDO OU ALTERADO';
				RETURN OLD;
			END IF;
		END LOOP;

		FOR mov IN moves(conta_cliente) LOOP
			IF ((mov._data >= NEW.inicio) AND (NEW.fim IS NULL OR mov._data <= NEW.fim) OR ESTA_NEGATIVADO(NEW.cliente, NEW.inicio)) THEN
				RAISE NOTICE 'O REGISTRO DE NEGATIVACAO NÃO PÔDE SER INSERIDO OU ALTERADO';
				RETURN OLD;
			END IF;
		END LOOP;
		RAISE NOTICE 'REGISTRO DE NEGATIVACAO INSERIDO OU ALTERADO COM SUCESSO';
		RETURN NEW;
	END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION VALIDA_ALTERACAO_CONTA() RETURNS TRIGGER AS $$
	DECLARE
		valor_emprestado FLOAT;
		
	BEGIN
		RAISE NOTICE 'VALIDANDO ALTERACAO EM CONTA';
		valor_emprestado = EMPRESTADO(NEW.id);
		if (NEW.limite < valor_emprestado) THEN
			RAISE NOTICE 'O CLIENTE JÁ POSSUI MAIS QUE A ALTERAÇÃO PARA O LIMITE';
			RAISE NOTICE 'LIMITE NÃO ALTERADO';
			RETURN OLD;
		END IF;
		RAISE NOTICE 'CONTA ALTERADA';
		RETURN NEW;
	END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION VALIDA_ALTERACAO_AGENCIA() RETURNS TRIGGER AS $$
	DECLARE
		contas CURSOR FOR 
			SELECT * FROM conta WHERE conta.agencia = NEW.id;

		transacoes CURSOR(c INTEGER) FOR
			SELECT * FROM transacao WHERE transacao.conta_origem = c;

		clientes_agencia CURSOR FOR 
			SELECT cpf FROM cliente INNER JOIN conta
			ON cliente.cpf = conta.dono
			WHERE conta.agencia = NEW.id;

	BEGIN
		RAISE NOTICE 'VALIDANDO ALTERAÇÃO DE AGÊNCIA';

		IF (OLD.permite_emprestimo AND NOT NEW.permite_emprestimo) THEN
			RAISE NOTICE 'AGÊNCIA JÁ POSSUI EMPRÉSTIMOS REALIZADOS';
			RAISE NOTICE 'ALTERAÇÃO DA PERMISSÃO DE EMPRÉSTIMOS NÃO REALIZADA';
			RETURN OLD;
		END IF;

		FOR c IN contas LOOP
			FOR t IN transacoes(c.id) LOOP
				IF (NEW.horario_abertura > t._data::time 
				OR NEW.horario_fechamento < t._data::time) THEN
					RAISE NOTICE 'AGÊNCIA NÃO INSERIDA OU ALTERADA';
					RETURN OLD;
				END IF;
			END LOOP;
		END LOOP;

		FOR c IN clientes_agencia LOOP
			IF (NOT MESMA_PARIDADE(SUBSTRING(c.cpf, 11, 1)::INTEGER, EXTRACT(hour FROM NEW.horario_abertura)::INTEGER)) THEN
				RAISE NOTICE 'EXISTE CPF DE CLIENTE COM PARIDADE DIFERENTE';
				RAISE NOTICE 'AGÊNCIA NÃO INSERIDA OU ALTERADA';
				RETURN OLD;
			END IF;
		END LOOP;

		RAISE NOTICE 'AGÊNCIA INSERIDA OU ALTERADA COM SUCESSO';

		RETURN NEW;
	END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION VALIDA_INSERCAO_CONTA() RETURNS TRIGGER AS $$
	DECLARE
		agencia_conta agencia%ROWTYPE;

	BEGIN
		RAISE NOTICE 'VALIDANDO INSERCAO DE CONTA';

		SELECT * FROM agencia WHERE agencia.id = NEW.agencia
		INTO agencia_conta;

		IF (NOT MESMA_PARIDADE(SUBSTRING(NEW.dono, 11, 1)::INTEGER, EXTRACT(hour FROM agencia_conta.horario_abertura)::INTEGER)) THEN
			RAISE NOTICE 'PARIDADE DIFERENTE';
			RAISE NOTICE 'CONTA NÃO INSERIDA';
			RETURN NULL;
		END IF;

		RAISE NOTICE 'PARIDADE IGUAL';
		RAISE NOTICE 'CONTA INSERIDA COM SUCESSO';
		RETURN NEW;
	END;
$$ LANGUAGE PLPGSQL;



--------------------------------------------------------------------------------------------
-- TRIGGERS --------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


DROP TRIGGER IF EXISTS VALIDA_TRANSACAO ON transacao;
DROP TRIGGER IF EXISTS VALIDA_NEGATIVACAO ON negativacao;
DROP TRIGGER IF EXISTS VALIDA_ALTERACAO_CONTA ON conta;
DROP TRIGGER IF EXISTS VALIDA_INSERCAO_CONTA ON conta;
DROP TRIGGER IF EXISTS VALIDA_ALTERACAO_AGENCIA ON agencia;


-------- TRANSACAO -------------------------------------------------------
-- ALTERACAO || INSERCAO -- 
CREATE TRIGGER VALIDA_TRANSACAO BEFORE INSERT OR UPDATE ON transacao 
	FOR EACH ROW EXECUTE PROCEDURE VALIDA_TRANSACAO();


-------- NEGATIVACAO -----------------------------------------------------

-- ALTERACAO || INSERCAO --
CREATE TRIGGER VALIDA_NEGATIVACAO BEFORE UPDATE OR INSERT ON negativacao 
	FOR EACH ROW EXECUTE PROCEDURE VALIDA_NEGATIVACAO();


-------- CONTA -----------------------------------------------------------

-- ALTERACAO --
CREATE TRIGGER VALIDA_ALTERACAO_CONTA BEFORE UPDATE ON conta
	FOR EACH ROW EXECUTE PROCEDURE VALIDA_ALTERACAO_CONTA();

-- INSERCAO -- 
CREATE TRIGGER VALIDA_INSERCAO_CONTA BEFORE INSERT ON conta
	FOR EACH ROW EXECUTE PROCEDURE VALIDA_INSERCAO_CONTA();


-------- AGENCIA ---------------------------------------------------------

-- ALTERACAO --
CREATE TRIGGER VALIDA_ALTERACAO_AGENCIA BEFORE UPDATE ON agencia 
	FOR EACH ROW EXECUTE PROCEDURE VALIDA_ALTERACAO_AGENCIA();
