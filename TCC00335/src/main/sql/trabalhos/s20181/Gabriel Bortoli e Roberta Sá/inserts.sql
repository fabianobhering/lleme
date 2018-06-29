
	--CLIENTE
	INSERT INTO cliente VALUES
	(default,'rob','rob',2147328474,'Rua Jorge Veiga, 100, Ilha , Rio de Janeiro-RJ BR'),
	(default,'rob2','rob',2147328474,'Rua das Flores, 100, Jacarepagua , Rio de Janeiro-RJ BR'),
	(default,'rob3','rob',2147328474,'Rua Emengarda, 22, Centro , Rio de Janeiro-RJ BR'),
	(default,'rob4','rob',2147328474,'Rua Almirante José, 333, Joatinga , Rio de Janeiro-RJ BR'),
	(default,'rob5','rob',2147328474,'Av das Américas, 4333, Barra da Tijuca , Rio de Janeiro-RJ BR')
	;

	--PRODUTO    
	INSERT INTO produto VALUES
	(default,'Ranitidina'),
	(default,'Cloridrato de Manganês'),
    	(default,'Iboprufeno'),
    	(default,'Flagil'),
   	(default,'Camisinha Jontex');

	--LOJA  
	INSERT INTO loja VALUES
	(default,'Barra','Av das Américas, 4333, Barra da Tijuca , Rio de Janeiro-RJ BR','09:00:00','18:00:00'),
    	(default,'Ilha','Av. Maestro Paulo e Silva, 1321, Portuguesa, Rio de Janeiro-RJ BR','10:00:00','20:00:00'),
	(default,'Freguesia','Av. Marechal Levy cardozo, 1351, Freguesia, Rio de Janeiro-RJ BR','10:00:00','20:00:00'),
    	(default,'Centro','Av. Presidente Vargas, 1234, Centro, Rio de Janeiro-RJ BR','22:00:00','24:00:00')
   	;

	--ESTOQUE
	INSERT INTO estoque VALUES
	(default,1,1,10,5),
	(default,2,2,10,2),
	(default,1,2,10,5),
	(default,2,1,10,2),
	(default,1,3,10,8),
	(default,1,4,10,8);

	--CARRINHO
	INSERT INTO carrinho VALUES
	(default,'1',current_timestamp,NULL,'efetuado'),
	(default,'2',current_timestamp,NULL,'efetuado'),
        (default,'2',current_timestamp,NULL,'efetuado');