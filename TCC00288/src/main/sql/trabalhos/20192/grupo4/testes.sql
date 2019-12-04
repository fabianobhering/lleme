----------------------------------------------------------------------------------------
-- INSERTS -----------------------------------------------------------------------------

--RAISE NOTICE '-------------- TESTES DE ADIÇÃO ----------------';


-- TESTE TRANSFERÊNCIA VÁLIDA
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1110, TRUE, '03:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('00000020995', 'CLIENTE TESTE TRANSFERENCIA VALIDA');
INSERT INTO cliente (cpf, nome)
VALUES('00000030995', 'CLIENTE TESTE TRANSFERENCIA VALIDA');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(2141, 1500, '00000020995', 1110);
INSERT INTO conta (id, limite, dono, agencia)
VALUES(2142, 1500, '00000030995', 1110);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'TRANSFERENCIA', 2141 , 2142);


-- TESTE EMPRÉSTIMO VÁLIDO
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1130, TRUE, '03:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('10000022995', 'CLIENTE TESTE HORARIO AGENCIA');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(7536, 1500, '10000022995', 1130);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'EMPRESTIMO', 0 , 7536);


-- TESTE ADICIONAR CONTA DE CLIENTE COM CPF DE PARIDADE DIFERENTE DO HORARIO DE ABERTURA DA AGENCIA
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1135, TRUE, '06:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('02000000007', 'CLIENTE TESTE PARIDADE');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(186, 1500, '02000000007', 1135);


-- TESTE EMPRÉSTIMO PARA CLIENTE NEGATIVADO
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1330, TRUE, '03:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('12000022995', 'CLIENTE TESTE EMPRESTIMO NEGATIVADO');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(75361, 1500, '12000022995', 1330);
INSERT INTO negativacao (inicio, fim, cliente)
VALUES('12/12/2012 13:00', null, '12000022995');
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'EMPRESTIMO', 0 , 75361);


-- TESTE EMPRÉSTIMO EM AGÊNCIA QUE NÃO PERMITE
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1337, FALSE, '03:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('12100022995', 'CLIENTE TESTE EMPRESTIMO AGENCIA NAO PERMITE');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(85301, 1500, '12100022995', 1337);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'EMPRESTIMO', 0 , 85301);


-- TESTE EMPRÉSTIMO ALÉM DO LIMITE ACUMULADO
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1030, TRUE, '03:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('10000122995', 'CLIENTE TESTE HORARIO AGENCIA');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(75368, 1500, '10000122995', 1030);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'EMPRESTIMO', 0 , 75368);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(500.00, '12/12/2000 10:00'::TIMESTAMP, 'EMPRESTIMO', 0 , 75368);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(500.00, '12/12/2000 10:00'::TIMESTAMP, 'EMPRESTIMO', 0 , 75368);


-- TESTE SACA MAIS QUE O DISPONÍVEL EM CONTA
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(5030, TRUE, '03:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('15000122995', 'CLIENTE TESTE HORARIO AGENCIA');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(755, 1500, '15000122995', 5030);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'DEPOSITO', NULL , 755);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(900.00, '12/12/2000 10:00'::TIMESTAMP, 'SAQUE', 755 , NULL);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(900.00, '12/12/2000 10:00'::TIMESTAMP, 'SAQUE', 755 , NULL);


-- TESTE TRANSAÇÃO FORA DO HORÁRIO DE FUNCIONAMENTO DA AGÊNCIA
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1118, TRUE, '03:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('00000023995', 'CLIENTE TESTE TRANSFERENCIA FORA HORARIO');
INSERT INTO cliente (cpf, nome)
VALUES('00000033995', 'CLIENTE TESTE TRANSFERENCIA FORA HORARIO');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(21416, 1500, '00000023995', 1118);
INSERT INTO conta (id, limite, dono, agencia)
VALUES(21426, 1500, '00000033995', 1118);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 01:00'::TIMESTAMP, 'TRANSFERENCIA', 21416 , 21426);


-- TESTE DEPÓSITO COM ORIGEM NÃO NULA
-- INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
-- VALUES(50371, TRUE, '03:00:00'::time, '12:00:00'::time);
-- INSERT INTO cliente (cpf, nome)
-- VALUES('15011122997', 'CLIENTE TESTE DEPOSITO ORIGEM NAO NULA');
-- INSERT INTO cliente (cpf, nome)
-- VALUES('15011122998', 'CLIENTE TESTE DEPOSITO ORIGEM NAO NULA');
-- INSERT INTO conta (id, limite, dono, agencia)
-- VALUES(75503, 1500, '15011122997', 50371);
-- INSERT INTO conta (id, limite, dono, agencia)
-- VALUES(75513, 1500, '15011122998', 50371);
-- INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
-- VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'DEPOSITO', 75513 , 75503);


-- TESTE SAQUE COM DESTINO NÃO NULO
-- INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
-- VALUES(50321, TRUE, '03:00:00'::time, '12:00:00'::time);
-- INSERT INTO cliente (cpf, nome)
-- VALUES('15111122997', 'CLIENTE TESTE SAQUE DESTINO NAO NULO');
-- INSERT INTO cliente (cpf, nome)
-- VALUES('15111122998', 'CLIENTE TESTE SAQUE DESTINO NAO NULO');
-- INSERT INTO conta (id, limite, dono, agencia)
-- VALUES(755032, 1500, '15111122997', 50321);
-- INSERT INTO conta (id, limite, dono, agencia)
-- VALUES(755132, 1500, '15111122998', 50321);
-- INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
-- VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'DEPOSITO', NULL , 755132);
-- INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
-- VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'SAQUE', 755132 , 755032);


-- TESTE TRANSFERÊNCIA COM ORIGEM OU DESTINO NULOS

-- TESTE EMPRÉSTIMO COM ORIGEM OU DESTINO NULOS


-- FALTOU --

-- TESTE SACA MAIS QUE O DISPONÍVEL E ESTÁ NEGATIVADO NOS ÚLTIMOS TRÊS MESES

-- TESTE INCLUI NEGATIVAÇÃO E TEM SAQUE COM MAIS QUE O LIMITE NOS ÚLTIMOS TRÊS MESES


----------------------------------------------------------------------------------------
-- UPDATES -----------------------------------------------------------------------------

--RAISE NOTICE '-------------- TESTES DE ALTERAÇÃO ----------------';


-- TESTE MUDA HORÁRIO DE FUNCIONAMENTO DA AGÊNCIA QUE JÁ TEM TRANSAÇÕES NESSE HORÁRIO                                              VALIDAR
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(130, TRUE, '04:00:00'::time, '12:00:00'::time);
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(131, TRUE, '04:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('00000000990', 'CLIENTE TESTE HORARIO AGENCIA');
INSERT INTO cliente (cpf, nome)
VALUES('00000000992', 'CLIENTE TESTE HORARIO AGENCIA');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(141, 1500, '00000000098', 130);
INSERT INTO conta (id, limite, dono, agencia)
VALUES(142, 1500, '00000000092', 131);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'TRANSFERENCIA', 141 , 142);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'TRANSFERENCIA', 000 , 142);
UPDATE agencia SET horario_abertura = '01:00:00'::time WHERE id = 130;
UPDATE agencia SET horario_abertura = '01:00:00'::time WHERE id = 131;


-- TESTE TROCAR HORARIO DE AGÊNCIA COM CLIENTES QUE TEM CPF DE PARIDADE DIFERENTE DO NOVO HÓRARIO DE ABERTURA                      VALIDAR
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(129, FALSE, '04:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('00000000098', 'CLIENTE TESTE ALTERA PARIDADE');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(1861, 1500, '00000000098', 129);
UPDATE agencia SET horario_abertura = '01:00:00'::time WHERE id = 129;


-- TESTE MUDA PERMISSÃO DE EMPRÉSTIMO DE AGÊNCIA QUE JÁ CONCEDEU EMPRÉSTIMOS
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1289, TRUE, '04:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('00000040098', 'CLIENTE TESTE MUDA PERMISÃO DE EMPRESTIMO');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(1231, 1500, '00000040098', 1289);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'EMPRESTIMO', 000 , 1231);
UPDATE agencia SET permite_emprestimo = FALSE WHERE id = 1289;


-- TESTE MUDA LIMITE DE CRÉDITO DE PESSOA QUE JÁ TEM EMPRÉSTIMOS PARA MENOS DO ACUMULADO
INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(3333, TRUE, '04:00:00'::time, '12:00:00'::time);
INSERT INTO cliente (cpf, nome)
VALUES('00000140098', 'CLIENTE TESTE MUDA PERMISÃO DE EMPRESTIMO');
INSERT INTO conta (id, limite, dono, agencia)
VALUES(4444, 1500, '00000140098', 3333);
INSERT INTO transacao (valor, _data, tipo, conta_origem, conta_destino)
VALUES(1000.00, '12/12/2000 10:00'::TIMESTAMP, 'EMPRESTIMO', 000 , 4444);
UPDATE CONTA SET limite = 900 WHERE id = 1231
