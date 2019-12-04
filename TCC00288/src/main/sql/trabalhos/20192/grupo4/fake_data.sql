-- AGENCIAS --

INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(0, TRUE, '00:00:00'::time, '23:59:59'::time);

INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(1, TRUE, '08:00:00'::time, '16:00:00'::time);

INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(2, FALSE, '08:00:00'::time, '10:00:00'::time);

INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(3, TRUE, '09:00:00'::time, '9:01:00'::time);

INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(4, FALSE, '08:00:00'::time, '23:00:00'::time);
 
 INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(5, TRUE, '00:00:00'::time, '23:59:59'::time);

INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(6, FALSE, '08:00:00'::time, '09:00:00'::time);

INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(7, TRUE, '08:00:00'::time, '16:00:00'::time);

INSERT INTO agencia (id, permite_emprestimo, horario_abertura, horario_fechamento)
VALUES(8, FALSE, '04:00:00'::time, '12:00:00'::time);



-- CLIENTES --

INSERT INTO cliente (cpf, nome)
VALUES('00000000000', 'BANCO');

INSERT INTO cliente (cpf, nome)
VALUES('32098976543', 'NULL');

INSERT INTO cliente (cpf, nome)
VALUES('92234565422', 'UNDEFINED');

INSERT INTO cliente (cpf, nome)
VALUES('72546464652', 'GTA 6');

INSERT INTO cliente (cpf, nome)
VALUES('99999999999', 'Marcos Gabriel Pereira Paulo');
 
INSERT INTO cliente (cpf, nome)
VALUES('00000000001', 'Leonardo Gurgel Maciel Ferreira');

INSERT INTO cliente (cpf, nome)
VALUES('12345567822', 'Palestra');

INSERT INTO cliente (cpf, nome)
VALUES('32347453232', 'Wesley');

INSERT INTO cliente (cpf, nome)
VALUES('22365756762', 'Robson');

INSERT INTO cliente (cpf, nome)
VALUES('77777777777', 'INSERT NAME HERE');

INSERT INTO cliente (cpf, nome)
VALUES('45676543222', 'GIT PUSH');

INSERT INTO cliente (cpf, nome)
VALUES('99998888999', 'G2');



-- NEGATIVADO --

INSERT INTO negativacao (inicio, fim, cliente)
VALUES('12/12/2012 12:00', null, '99998888999');

INSERT INTO negativacao (inicio, fim, cliente)
VALUES('12/12/2012 13:00', null, '22365756762');

INSERT INTO negativacao (inicio, fim, cliente)
VALUES('12/11/1024', null, '45676543222');



-- CONTAS --

INSERT INTO conta (id, limite, dono, agencia)
VALUES(0, 999999, '00000000000', 0);

INSERT INTO conta (id, limite, dono, agencia)
VALUES(1, 674546, '99999999999', 5);

INSERT INTO conta (id, limite, dono, agencia)
VALUES(2, 1, '00000000001', 5);

INSERT INTO conta (id, limite, dono, agencia)
VALUES(4, 112, '99998888999', 3);



-- SELECTS --

--SELECT * FROM agencia;
--SELECT * FROM cliente;
--SELECT * FROM conta;
--SELECT * FROM transacao;
--SELECT * FROM negativacao;
