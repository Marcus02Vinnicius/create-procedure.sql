CREATE DATABASE TESTE_PROCS
GO
USE TESTE_PROCS
GO

--==============================================
-- Stored Procedure e comandos T-SQL
--==============================================
-- 1. Calcula o quadrado de um n�mero
CREATE PROCEDURE STP_QUADRADO @N INT
AS BEGIN
-- 1. declarar vari�vel para o resultado
DECLARE @Q INT;
-- 2. fazer o c�lculo e colocar o resultado na vari�vel @Q
SET @Q = @N * @N;
-- 3. devolver o resutado para quem executou a procedure
SELECT @Q AS QUADRADO;
END -- fim da procedure
GO
-- testando a procedure
EXEC STP_QUADRADO 8
EXEC STP_QUADRADO 12
GO
--=================================================
-- 2. Criar procedure STP_TROCO que calcule o troco
--    Par�metros de input:
--         @VCOMPRA    NUMERIC(10,2): Valor total a pagar pela compra
--         @VPAGO      NUMERIC(10,2): Valor dado em pagamento
--    Declarar Vari�vel:
--         @TROCO      NUMERIC(10,2): Valor do troco  
--
--    No final deve fazer SELECT @TROCO para mostrar o resultado
--------------------------------------------------- 
CREATE PROCEDURE STP_TROCO 	@VCOMPRA NUMERIC(10,2), @VPAGO NUMERIC(10,2)
AS BEGIN
--1. declarar vari�vel para o resultado
DECLARE @TROCO      NUMERIC(10,2);
--2. fazer o c�lculo e colocar o valor na vari�vel
SET @TROCO = @VPAGO - @VCOMPRA;
--3. retornar com o resultado 
SELECT @TROCO AS TROCO;
END
GO
-- TESTANDO
EXEC STP_TROCO 75, 100
GO
EXEC STP_TROCO @VPAGO = 100, @VCOMPRA = 75
GO
--===================================================
-- 3. Criar procedure STP_MULTA que calcule o valor da 
--    multa e o valor total a pagar
--    Par�metros de input:
--         @VDEVIDO    NUMERIC(10,2): Valor devido
--         @PORC_MULTA NUMERIC(4,2): Porcentagem de multa
--    Declarar vari�veis:
--         @VLR_MULTA  NUMERIC(10,2): Valor da multa  
--         @VLR_PAGAR  NUMERIC(10,2): Valor a pagar
--    C�lculos
--         @VLR_MULTA = @VDEVIDO * @PORC_MULTA / 100
--         @VLR_PAGAR = @VDEVIDO + @VLR_MULTA
--------------------------------------------------- 
CREATE PROCEDURE  STP_MULTA	  @VDEVIDO    NUMERIC(10,2),
							  @PORC_MULTA NUMERIC(4,2)
AS BEGIN
-- 1. declarar vari�veis para os resultados
DECLARE @VLR_MULTA  NUMERIC(10,2);
DECLARE	@VLR_PAGAR  NUMERIC(10,2);
-- 2. fazer os c�lculos
SET @VLR_MULTA = @VDEVIDO * @PORC_MULTA / 100;
SET @VLR_PAGAR = @VDEVIDO + @VLR_MULTA;
-- 3. retornar com os resultados
SELECT @VLR_MULTA AS VLR_MULTA, @VLR_PAGAR AS VLR_PAGAR;
END
GO

-- TESTANDO
EXEC STP_MULTA 1000,15

EXEC STP_MULTA 110.55, 5.5
GO
-- 4. Criar procedure STP_REAJUSTA que receba um valor de SALARIO e
-- uma porcentagem de reajuste. A procedure deve retornar
-- o valor do reajuste e o valor do novo sal�rio
--   Par�metros de Input
--       @SALARIO_ATUAL: NUMERIC(10,2)
--       @PORC_REAJ    : NUMERIC(10,2)
--
--   Vari�veis auxiliares
--       @VLR_REAJUSTE : NUMERIC(10,2)
--       @SALARIO_NOVO : NUMERIC(10,2)
CREATE PROCEDURE STP_REAJUSTA  @SALARIO_ATUAL NUMERIC(10,2),
							   @PORC_REAJ     NUMERIC(10,2)
AS BEGIN
-- declarar vari�veis para os resultados
DECLARE @VLR_REAJUSTE NUMERIC(10,2), @SALARIO_NOVO NUMERIC(10,2);
-- fazer os c�lculos
SET @VLR_REAJUSTE = @SALARIO_ATUAL * @PORC_REAJ / 100;
SET @SALARIO_NOVO = @SALARIO_ATUAL + @VLR_REAJUSTE;
-- retornar com os resultados
SELECT @VLR_REAJUSTE AS VLR_REAJUSTE, @SALARIO_NOVO AS SALARIO_NOVO;
END
GO

--- TESTANDO
EXEC STP_REAJUSTA 5000, 10
GO
-- 5. Altere a procedure STP_QUADRADO colocando um IF de valida��o
--    do dado de entrada que de uma mensagem caso @N (par�metro de input)
--    seja maior que a raiz quadrada de 2 bilh�es.
EXEC STP_QUADRADO 50000
GO
--------------------------------------------
ALTER PROCEDURE STP_QUADRADO @N INT
AS BEGIN
-- 1. declarar vari�vel para o resultado
DECLARE @Q INT;

-- se @N for maior que a raiz quadrada de 2 bilh�es
IF @N > SQRT(2000000000)
   BEGIN
   SELECT -1 AS QUADRADO, 'N�MERO EXCEDE O LIMITE' AS MSG;
   RETURN; -- finaliza a execu��o da procedure
   END -- IF

-- 2. fazer o c�lculo e colocar o resultado na vari�vel @Q
SET @Q = @N * @N;
-- 3. devolver o resutado para quem executou a procedure
SELECT @Q AS QUADRADO, 'SUCESSO' AS MSG;
END -- fim da procedure
GO


-- Testando
EXEC STP_QUADRADO 50000
EXEC STP_QUADRADO 1000
GO
/*
SqlCommand cmd = conn.CreateCommand();
cmd.CommandText = 'EXEC STP_QUADRADO ' + n;
SqlDataReader dr = cmd.ExecuteReader();
dr.Read();
int quadrado = Convert.ToInt32( dr[0] );
string msg = dr[1].ToString();
if (quadrado < 0) ...
*/
-- 6. Alterar a procedure STP_TROCO colocando um IF
--    de valida��o de dado de entrada que impe�a que
--    @VPAGO seja menor que @VCOMPRA
ALTER PROCEDURE STP_TROCO 	@VCOMPRA NUMERIC(10,2), @VPAGO NUMERIC(10,2)
AS BEGIN
--1. declarar vari�vel para o resultado
DECLARE @TROCO      NUMERIC(10,2);

-- se o valor pago for menor que o valor da compra
IF @VPAGO < @VCOMPRA
   BEGIN
   SELECT -1 AS TROCO, 'T� FALTANDO GRANA P�!!!!!' AS MSG;
   RETURN;
   END -- IF @VPAGO < @VCOMPRA

--2. fazer o c�lculo e colocar o valor na vari�vel
SET @TROCO = @VPAGO - @VCOMPRA;
--3. retornar com o resultado 
SELECT @TROCO AS TROCO, 'SUCESSO' AS MSG;
END
GO


-- TESTANDO
EXEC STP_TROCO 75, 100
EXEC STP_TROCO 100, 75
GO

SELECT * FROM SYSOBJECTS WHERE XTYPE = 'P'
GO
-- 7. Alterar a procedure STP_MULTA colocando um IF
--    de valida��o de dado de entrada que garanta que
--    @VDEVIDO e @PORC_MULTA sejam positivos
--    (n�o podem ser menor nem igual a zero)
ALTER PROCEDURE  STP_MULTA	  @VDEVIDO    NUMERIC(10,2),
							  @PORC_MULTA NUMERIC(4,2)
AS BEGIN
-- 1. declarar vari�veis para os resultados
DECLARE @VLR_MULTA  NUMERIC(10,2);
DECLARE	@VLR_PAGAR  NUMERIC(10,2);

-- se o valor devido for menor ou igual a zero OU
-- a porcentagem de multa for menor ou igual a zero...
IF @VDEVIDO <= 0 OR @PORC_MULTA <= 0
   BEGIN
   SELECT -1 AS VLR_MULTA, -1 AS VLR_PAGAR,
                      'VALORES DEVEM SER POSITIVOS!!!' AS MSG;
   RETURN;
   END -- IF

-- 2. fazer os c�lculos
SET @VLR_MULTA = @VDEVIDO * @PORC_MULTA / 100;
SET @VLR_PAGAR = @VDEVIDO + @VLR_MULTA;
-- 3. retornar com os resultados
SELECT @VLR_MULTA AS VLR_MULTA, @VLR_PAGAR AS VLR_PAGAR,
       'SUCESSO' AS MSG;
END
GO


---
EXEC STP_MULTA 1000,10
GO
-- 8. Altere a procedure STP_REAJUSTA da seguinte forma:
--   Par�metros de Input
--       @SALARIO_ATUAL: NUMERIC(10,2)
--
--   Vari�veis auxiliares
--       @VLR_REAJUSTE : NUMERIC(10,2)
--       @SALARIO_NOVO : NUMERIC(10,2)
--       @PORC_REAJ    : NUMERIC(10,2)
-- 
--   A porcentagem de reajuste ser� definida da seguinte forma:
--       @SALARIO_ATUAL				@PORC_REAJ
--       de 0 a 2000                        20%
--       acima de 2000 at� 4000				15%
--       acima de 4000 at� 5000				10%
--       acima de 5000 at� 10000			 5%
--       acima de 10000						sem reajuste
ALTER PROCEDURE STP_REAJUSTA  @SALARIO_ATUAL NUMERIC(10,2)
AS BEGIN
-- declarar vari�veis para os resultados
DECLARE @VLR_REAJUSTE NUMERIC(10,2), @SALARIO_NOVO NUMERIC(10,2),
		@PORC_REAJ     NUMERIC(10,2);

-- se o salario atual for menor que o sal. m�nimo (R$ 1045,00)
-- retornar mensagem e finalizar a procedure
IF @SALARIO_ATUAL < 1045
   BEGIN
   SELECT -1 AS VLR_REAJUSTE, -1 AS SALARIO_NOVO,
       'SAL�RIO ATUAL N�O PODE SER INFERIOR AO SAL. M�NIMO (R$ 1045,00)' AS MSG;
   RETURN; -- finaliza a procedure 
   END -- IF

---- SOLU��O 1
--IF @SALARIO_ATUAL <= 2000 SET @PORC_REAJ = 20
--IF @SALARIO_ATUAL > 2000 AND @SALARIO_ATUAL <= 4000 SET @PORC_REAJ = 15
--IF @SALARIO_ATUAL > 4000 AND @SALARIO_ATUAL <= 5000 SET @PORC_REAJ = 10
--IF @SALARIO_ATUAL > 5000 AND @SALARIO_ATUAL <= 10000 SET @PORC_REAJ = 5
--IF @SALARIO_ATUAL > 10000 SET @PORC_REAJ = 0

---- SOLU��O 2
--IF @SALARIO_ATUAL <= 2000 SET @PORC_REAJ = 20
--ELSE IF @SALARIO_ATUAL <= 4000 SET @PORC_REAJ = 15
--ELSE IF @SALARIO_ATUAL <= 5000 SET @PORC_REAJ = 10
--ELSE IF @SALARIO_ATUAL <= 10000 SET @PORC_REAJ = 5
--ELSE SET @PORC_REAJ = 0

-- SOLU��O 3
SET @PORC_REAJ = CASE
					WHEN @SALARIO_ATUAL <= 2000 THEN 20
					WHEN @SALARIO_ATUAL <= 4000 THEN 15
					WHEN @SALARIO_ATUAL <= 5000 THEN 10
					WHEN @SALARIO_ATUAL <= 10000 THEN 5
					ELSE 0
                 END -- fim do CASE

-- fazer os c�lculos
SET @VLR_REAJUSTE = @SALARIO_ATUAL * @PORC_REAJ / 100;
SET @SALARIO_NOVO = @SALARIO_ATUAL + @VLR_REAJUSTE;
-- retornar com os resultados
SELECT @VLR_REAJUSTE AS VLR_REAJUSTE, @SALARIO_NOVO AS SALARIO_NOVO,
       'SUCESSO' AS MSG;
END
GO

	
-------------------------------------------------------------

-- TESTANDO
EXEC STP_REAJUSTA 2000
EXEC STP_REAJUSTA 3000
EXEC STP_REAJUSTA 5000
EXEC STP_REAJUSTA 8000
EXEC STP_REAJUSTA 11000
GO
--------------------------------------------------
-- 9.Complete a procedure de modo a colocar na vari�vel @MAIOR
--   o maior dos 3 n�meros contidos nas vari�veis @N1, @N2 e @N3
CREATE PROCEDURE STP_MAIOR @N1 NUMERIC(10,2), @N2 NUMERIC(10,2), @N3 NUMERIC(10,2)
AS BEGIN
DECLARE @MAIOR NUMERIC(10,2);
------------------------------ complete
-- SOLU��O 1
IF @N1 > @N2
   IF @N1 > @N3  SET @MAIOR = @N1
   ELSE SET @MAIOR = @N3
ELSE
   IF @N2 > @N3  SET @MAIOR = @N2
   ELSE SET @MAIOR = @N3

-- SOLU��O 2
IF @N1 > @N2 AND @N1 > @N3  SET @MAIOR = @N1
ELSE IF @N2 > @N3  SET @MAIOR = @N2
ELSE SET @MAIOR = @N3

-- SOLU��O 3
SET @MAIOR = @N1
IF @N2 > @MAIOR SET @MAIOR = @N2
IF @N3 > @MAIOR SET @MAIOR = @N3

---------------------------------------
SELECT @MAIOR AS MAIOR;
END
GO
--TESTANDO
EXEC STP_MAIOR 10,2,11
GO

--===================================================
-- 10. Criar procedure STP_MEDIA que calcule a m�dia
--    do aluno 
--    Par�metros de input:
--         @N1    NUMERIC(4,2): Primeira nota
--         @N2    NUMERIC(4,2): Segunda nota
--         @N3    NUMERIC(4,2): Terceira nota
--         @N4    NUMERIC(4,2): Quarta nota
--    Declarar vari�veis:
--         @MEDIA     NUMERIC(4,2)      : Valor da m�dia  
--         @SITUACAO  VARCHAR(10): REPROVADO se m�dia menor que 5
--                                caso contr�rio APROVADO
--         @CLASSIFIC VARCHAR(10): Classifica��o
--             M�dia at� 2..................P�SSIMO
--             Acima de 2 at� 4.............RUIM
--             Acima de 4 at� 6.............REGULAR
--             Acima de 6 at� 8.............BOM
--             Acima de 8...................�TIMO
--
--   Obs.1: A procedure n�o deve aceitar notas fora do 
--          intervalo de 0 at� 10
--   Obs.2: O resultado deve ser retornado com um SELECT
--          de 3 colunas: MEDIA, SITUACAO e CLASSIFICACAO  
--------------------------------------------------- 
CREATE PROCEDURE STP_MEDIA @N1    NUMERIC(4,2), @N2    NUMERIC(4,2),
						   @N3    NUMERIC(4,2), @N4    NUMERIC(4,2)
AS BEGIN
-- 1. declarar vari�veis de resultado
DECLARE @MEDIA NUMERIC(4,2), @SITUACAO VARCHAR(15), @CLASSIFIC VARCHAR(15);
-- 2. testar se tem nota inv�lida
IF @N1 NOT BETWEEN 0 AND 10 OR @N2 NOT BETWEEN 0 AND 10 OR 
   @N3 NOT BETWEEN 0 AND 10 OR @N4 NOT BETWEEN 0 AND 10
   BEGIN
   SELECT -1 AS MEDIA, 'ERRO' AS SITUACAO, 
          'NOTAS FORA DO INTERVALO' AS CLASSIFICACAO;
   RETURN;
   END -- IF
-- 3. calcular a m�dia
SET @MEDIA = (@N1 + @N2 + @N3 + @N4) / 4;
-- 4. definir a situa��o
IF @MEDIA < 5 SET @SITUACAO = 'REPROVADO'
ELSE SET @SITUACAO = 'APROVADO'

-- A partir do SQL-2012
SET @SITUACAO = IIF(@MEDIA < 5, 'REPROVADO', 'APROVADO');

-- 5. definir a classifica��o
SET @CLASSIFIC = CASE
					WHEN @MEDIA <= 2 THEN 'P�SSIMO'
					WHEN @MEDIA <= 4 THEN 'RUIM'
					WHEN @MEDIA <= 6 THEN 'REGULAR'
					WHEN @MEDIA <= 8 THEN 'BOM'
					ELSE '�TIMO'
                 END
-- 6. retornar com os resultados
SELECT @MEDIA AS MEDIA, @SITUACAO AS SITUACAO, @CLASSIFIC AS CLASSIFICACAO;
END
GO

----
EXEC STP_MEDIA 5,5,8,5
