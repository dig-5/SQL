-- Control-of-flow-language

BEGIN 
A
B
C
END;

-- IF ... ELSE

IF  A
    B
ELSE
    C;

--

IF  A
BEGIN
    B
	C
	D
	E
END
ELSE
BEGIN
	F
	G
END

H

--

IF  A
    IF  B
	    IF  C
		BEGIN 
			D
			E
			F
		END
		ELSE
			G
	ELSE
	BEGIN 
		H
		I
	END
ELSE
	J

-- While

WHILE A
	  B

WHILE A
BEGIN
	  B
	  C
	  D
END

WHILE A
BEGIN
	  B
	  C
	  IF  X 
	      BREAK
	  D
END

WHILE A
BEGIN
	  B
	  C
	  IF  X
	      CONTINUE
	  D
END

--

BEGIN
	A
	B
	C
	D
	E
	RETURN
END

-- Comentario Línea 1
-- Comentario Línea 2

/* 
Comentario Línea 1
Comentario Línea 2 
*/

-- TRY ... CATCH

BEGIN
	
	BEGIN TRANSACTION
	BEGIN TRY
		A
		B
		C
		IF  X
		    RAISERROR
		D
		E
		F
		COMMIT TRANSACTION
		RETURN
	END TRY

	BEGIN CATCH
		G
		H
		I
		RAISERROR
		ROLLBACK TRANSACTION
	END CATCH
END;

--

DECLARE @Contador INT = 1

WHILE @Contador <= 10
BEGIN
	IF  (@Contador % 2) = 0
	    SELECT @Contador, 'Número Par'
	ELSE
	    SELECT @Contador, 'Número Impar';

	SELECT @Contador += @Contador;
END;
	 
--

IF  (SELECT COUNT(*) FROM Cuenta) > 10000
AND (SELECT COUNT(*) FROM Vendedor) > 20
BEGIN
    SELECT 'La Empresa tiene más de 10.000 Clientes y 20 Vendedores'
END
ELSE
BEGIN
    SELECT 'La Empresa tiene menos de 10.000 Clientes'
END;

--

IF  EXISTS (SELECT * FROM Cuenta WHERE NroCuenta = 1)
    SELECT 'Existe la Cuenta Nro. 1513201'
ELSE
    SELECT 'No existe la Cuenta Nro. 1513201'

IF  EXISTS (SELECT * FROM Cuenta WHERE NroCuenta = 1513201)
    SELECT 'Existe la Cuenta Nro. 1513201', *
	FROM Cuenta WHERE NroCuenta = 1513201
ELSE
    SELECT 'No existe la Cuenta Nro. 1513201'

if  exists (select * from cuenta where nrocuenta = 12301)
    select 'Cuenta Existente...';
else
    select 'Cuenta Inexistente...';

set dateformat dmy;
if  (select count(*) from Factura where fecharendicion between '01/01/2013' and '31/01/2013') > 1000
    select 'Se han facturado más de 1.000 Facturas...';
else
    select 'Se han facturado entre 0 y 1.000 Facturas...';

