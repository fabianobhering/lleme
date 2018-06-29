--TRIGGER 1 - VERIFICAR SE POSSUI O PRODUTO NO ESTOQUE

CREATE OR REPLACE FUNCTION tem_no_estoque() RETURNS trigger AS $$
BEGIN
	IF ((SELECT e.qnt 
		 FROM estoque e 
	     WHERE NEW.produto_estoque = e.id_estoque) - NEW.qnt < 0) 
			THEN 

		RAISE EXCEPTION 'Desculpe! Esta loja nao possui quantidade suficiente deste produto em estoque!' ;

	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER verifica_estoque BEFORE INSERT ON item_carrinho
	FOR EACH ROW EXECUTE PROCEDURE tem_no_estoque();


-----------------------------------------------------------------------
-----------------------------------------------------------------------


--TRIGGER 2 - ATUALIZAR ESTOQUE AO ADICIONAR PRODUTO NO CARRINHO

CREATE OR REPLACE FUNCTION atualiza_estoque() RETURNS trigger AS $$
BEGIN

	UPDATE estoque
	SET qnt = qnt - NEW.qnt
	WHERE NEW.produto_estoque = estoque.id_estoque;
	RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER atualiza_estq AFTER INSERT ON item_carrinho
	FOR EACH ROW EXECUTE PROCEDURE atualiza_estoque();


-----------------------------------------------------------------------
-----------------------------------------------------------------------


--TRIGGER 3 - CRIAR ENTREGA QUANDO PEDIDO FOR PARA STATUS 'em transporte'

CREATE OR REPLACE FUNCTION cria_entrega() RETURNS trigger AS $$
BEGIN

	IF EXISTS ( SELECT * FROM carrinho WHERE carrinho.id_carrinho = NEW.id_carrinho) THEN
      		IF (OLD.status NOT LIKE NEW.status) THEN
        		IF(NEW.status LIKE '%transporte%') THEN

				INSERT INTO entrega (id_entrega, carrinho, stat, momento_saida, momento_chegada)
				VALUES (default, NEW.id_carrinho, default, current_timestamp,NULL);

				NEW.hora_delivery := current_timestamp;
				
				RETURN NEW;

      			END IF;
      		END IF;
    	END IF;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER cria_entrg BEFORE UPDATE ON carrinho
FOR EACH ROW EXECUTE PROCEDURE cria_entrega();


-----------------------------------------------------------------------
-----------------------------------------------------------------------


--TRIGGER 4 - VALIDAR SE LOJA ESTÁ EM HORARIO DE FUNCIONAMENTO

CREATE OR REPLACE FUNCTION loja_funcionando() RETURNS trigger AS $$
BEGIN
	IF ( (SELECT c.hora_pedido 
		  FROM carrinho c
		  WHERE c.id_carrinho = NEW.carrinho) < 
									(SELECT hora_abre 
									 FROM loja 
									 WHERE loja.id_loja = 
									 (SELECT loja 
									  FROM estoque 
									  WHERE NEW.produto_estoque = estoque.id_estoque)))
			 THEN RAISE EXCEPTION 'Pedido feito com a loja ja fechada!';
    	END IF;
	IF ((SELECT c.hora_pedido 
		 FROM carrinho c 
		 WHERE c.id_carrinho = NEW.carrinho) > 
									(SELECT hora_fecha 
									 FROM loja 
									 WHERE loja.id_loja = 
									(SELECT loja 
									 FROM estoque 
									 WHERE NEW.produto_estoque = estoque.id_estoque)))
			THEN RAISE EXCEPTION 'Pedido feito antes da loja abrir!';
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER loja_em_funcionamento BEFORE INSERT ON item_carrinho
FOR EACH ROW EXECUTE PROCEDURE loja_funcionando();


-----------------------------------------------------------------------
-----------------------------------------------------------------------


--TRIGGER 5 - ATUALIZA O STATUS DA ENTREGA AO ENTRAR COM PAGAMENTO 

CREATE OR REPLACE FUNCTION atualiza_pgto() RETURNS trigger AS $$
BEGIN
		UPDATE entrega
		SET stat = 't',
		    momento_chegada = NEW.momento_pag
		WHERE carrinho = NEW.carrinho ;
		RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER atualiza_pg AFTER INSERT ON pagamento
FOR EACH ROW EXECUTE PROCEDURE atualiza_pgto();


-----------------------------------------------------------------------
-----------------------------------------------------------------------


--TRIGGER 6 - CONFERE SE O CARRINHO POSSUI ITENS DE LOJAS DIFERENTES

CREATE OR REPLACE FUNCTION lojas_distintas() RETURNS trigger AS $$
BEGIN
	IF ((SELECT COUNT(DISTINCT loja) 
		 FROM item_carrinho 
		INNER JOIN estoque 
		 			ON estoque.id_estoque = item_carrinho.produto_estoque)>1)  THEN
        
		RAISE EXCEPTION 'Pedido invalido: Produtos em lojas distintas';

	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER lojas_dif AFTER INSERT ON item_carrinho
FOR EACH statement EXECUTE PROCEDURE lojas_distintas();


-----------------------------------------------------------------------
-----------------------------------------------------------------------


--TRIGGER 7 - IMPEDIR MODIFICAÇÃO DE ITENS NO CARRINHO

CREATE OR REPLACE FUNCTION prevent_update()
  RETURNS trigger AS $$
  BEGIN
  	RAISE EXCEPTION 'PROIBIDO ALTERAR ITENS NO CARRINHO';
  END
  $$
  LANGUAGE plpgsql;
  
CREATE TRIGGER prevent_updt
  BEFORE UPDATE OF carrinho, produto_estoque, qnt
  ON item_carrinho
  FOR EACH ROW
  EXECUTE PROCEDURE prevent_update();  


-----------------------------------------------------------------------
-----------------------------------------------------------------------


--TRIGGER 8 - ATUALIZA ESTOQUE SE O PEDIDO FOR CANCELADO

CREATE OR REPLACE FUNCTION cancela_status() RETURNS trigger AS $$
  DECLARE
    curs CURSOR IS SELECT * 
					FROM item_carrinho 
					WHERE carrinho = NEW.id_carrinho;
    i_row item_carrinho%ROWTYPE;
  BEGIN
    IF EXISTS ( SELECT * 
			   FROM carrinho 
			   WHERE carrinho.id_carrinho = NEW.id_carrinho) THEN
      IF (OLD.status NOT LIKE NEW.status) THEN
        IF(NEW.status LIKE '%cancelado%') THEN
        
          FOR i_row IN curs LOOP
              UPDATE estoque
              SET qtd=qtd + i_row.qnt
              WHERE i_row.produto_estoque = estoque.id_estoque ;
	  			RETURN NEW;
          END LOOP;
			RETURN NEW;
        END IF;
		RETURN NEW;
      END IF;
	  RETURN NEW;
    END IF;
    RETURN NEW;
  END;
  $$
  LANGUAGE plpgsql;

CREATE TRIGGER cancel_status  AFTER UPDATE ON carrinho
FOR EACH ROW EXECUTE PROCEDURE cancela_status();


-----------------------------------------------------------------------
-----------------------------------------------------------------------  