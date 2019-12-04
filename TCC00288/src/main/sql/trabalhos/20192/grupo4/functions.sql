CREATE OR REPLACE FUNCTION saldo(conta INTEGER) 
RETURNS FLOAT AS $$
	DECLARE
		acumulado FLOAT;
		trans_origem CURSOR(c INTEGER) FOR 
			SELECT * FROM transacao
			WHERE transacao.conta_origem = c;
		trans_destino CURSOR(c INTEGER) FOR 
			SELECT * FROM transacao 
			WHERE transacao.conta_destino = c;
	BEGIN
		acumulado = 0;
		FOR origem IN trans_origem(conta) LOOP
			acumulado = acumulado - origem.valor;
		END LOOP;
		FOR destino IN trans_destino(conta) LOOP
			acumulado = acumulado + destino.valor;
		END LOOP;

		RETURN acumulado;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION EMPRESTADO(conta INTEGER)
RETURNS FLOAT AS $$
	DECLARE
		acumulado FLOAT;
		emprestimos CURSOR(c INTEGER) FOR 
		SELECT * FROM transacao
		WHERE UPPER(tipo) = 'EMPRESTIMO' AND conta_destino = c;
		pagamentos CURSOR(c INTEGER) FOR
		SELECT * FROM transacao
		WHERE UPPER(tipo) = 'TRANSFERENCIA' AND conta_origem = c AND conta_destino = 0;
	BEGIN
		acumulado = 0;
		FOR emprestimo IN emprestimos(conta) LOOP
			acumulado = acumulado + emprestimo.valor;
		END LOOP;
		FOR pagamento IN pagamentos(conta) LOOP
			acumulado = acumulado - pagamento.valor;
		END LOOP;
		RETURN acumulado;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION ESTA_NEGATIVADO(cl CHAR(11), tempo TIMESTAMP)
RETURNS BOOLEAN AS $$
	DECLARE
		negativacoes CURSOR FOR 
			SELECT * FROM negativacao 
			WHERE negativacao.cliente = cl;
	BEGIN
		FOR negativ in negativacoes LOOP
			IF ((negativ.fim IS NULL OR negativ.fim > tempo) AND negativ.inicio <= tempo) THEN
				RETURN TRUE;
			END IF;
		END LOOP;
		RETURN FALSE;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION MESMA_PARIDADE(a INTEGER, b INTEGER) RETURNS BOOLEAN AS $$
	DECLARE
	BEGIN
		RAISE NOTICE 'TESTANDO PARIDADE';
		RETURN ((a % 2) = (b % 2));
	END;
$$ LANGUAGE PLPGSQL;
