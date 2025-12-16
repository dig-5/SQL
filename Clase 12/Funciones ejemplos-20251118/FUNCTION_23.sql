CREATE FUNCTION dbo.FNCGeneraExtractoArticulo  (@NroArticulo INT,
					        @CodAgencia SMALLINT,
						@CodDeposito SMALLINT,
						@FechaDesde DATETIME,
						@FechaHasta DATETIME)

RETURNS @ExtractoArticulo TABLE (ID BIGINT IDENTITY(1, 1),
				 NroComprobante VARCHAR(20),
				 NroArticulo INT,
				 CodAgencia SMALLINT,
				 CodDeposito SMALLINT,
				 FechaOperacion DATETIME,
				 TipoOperacion VARCHAR(20),
				 Costo FLOAT,
				 Entrada FLOAT,
				 Salida FLOAT,
				 Saldo FLOAT)

AS

BEGIN

	DECLARE @EntradaInicial FLOAT, @SalidaInicial FLOAT,
	        @ID BIGINT, @Entrada FLOAT, @Salida FLOAT,
			@Saldo FLOAT;

-- Obtiene las cantidades de Entrada y Salida para generar el Saldo Inicial

-- Obtiene las cantidades compradas

	SELECT @EntradaInicial = ISNULL(SUM(DC.Cantidad), 0)
	FROM DetalleCompra DC JOIN Compra C ON DC.NroCompra = C.NroCompra
	WHERE DC.CodAgencia = @CodAgencia
	AND DC.CodDeposito = @CodDeposito
	AND DC.NroArticulo = @NroArticulo
	AND C.Estado = 'C'
	AND C.FechaCambio < @FechaDesde;

-- Obtiene las cantidades devueltas

	SELECT @EntradaInicial = @EntradaInicial + ISNULL(SUM(DD.Cantidad), 0)
	FROM DetalleDevolucion DD JOIN Devolucion D ON DD.NroDevolucion = D.NroDevolucion
	WHERE DD.CodAgencia = @CodAgencia
	AND DD.CodDeposito = @CodDeposito
	AND DD.NroArticulo = @NroArticulo
	AND D.FechaCambio < @FechaDesde;

-- Obtiene las cantidades de ajustes positivos

	SELECT @EntradaInicial = @EntradaInicial + ISNULL(SUM(DA.Cantidad), 0)
	FROM DetalleAjuste DA JOIN Ajuste A ON DA.NroAjuste = A.NroAjuste 
	JOIN TipoAjuste TA ON A.CodTipoAjuste = TA.CodTipoAjuste
	WHERE DA.CodAgencia = @CodAgencia
	AND DA.CodDeposito = @CodDeposito
	AND DA.NroArticulo = @NroArticulo
	AND A.FechaAjuste < @FechaDesde
	AND A.Estado = 'C'
	AND TA.PositivooNegativo = 1;

-- Obtiene las cantidades vendidas

	SELECT @SalidaInicial = ISNULL(SUM(DF.Cantidad), 0)
	FROM DetalleFactura DF JOIN Factura F ON DF.NroFactura = F.NroFactura
	WHERE DF.CodAgencia = @CodAgencia
	AND DF.CodDeposito = @CodDeposito
	AND DF.NroArticulo = @NroArticulo
	AND F.FechaEmision < @FechaDesde;

-- Obtiene las cantidades de ajustes negativos

	SELECT @SalidaInicial = @SalidaInicial + ISNULL(SUM(DA.Cantidad), 0)
	FROM DetalleAjuste DA JOIN Ajuste A ON DA.NroAjuste = A.NroAjuste 
	JOIN TipoAjuste TA ON A.CodTipoAjuste = TA.CodTipoAjuste
	WHERE DA.CodAgencia = @CodAgencia
	AND DA.CodDeposito = @CodDeposito
	AND DA.NroArticulo = @NroArticulo
	AND A.FechaAjuste < @FechaDesde
	AND A.Estado = 'C'
	AND TA.PositivooNegativo = -1;

	SELECT @ID = @@IDENTITY;

-- Inserta la Fila con el saldo Inicial

	INSERT INTO @ExtractoArticulo 
	SELECT '1',
		   @NroArticulo,
		   @CodAgencia,
		   @CodDeposito,
		   DATEADD (DAY, -1, @FechaDesde),
		   'SALDO INICIAL',
		   0,
		   @EntradaInicial,
		   @SalidaInicial,
		   @EntradaInicial - @SalidaInicial;

-- Calcula el saldo inicial
	   
	SELECT @Saldo = @EntradaInicial - @SalidaInicial;

-- Inserta los Movimientos del Artículo en la variable de tipo tabla @ExtractoArticulo

	INSERT INTO @ExtractoArticulo 
	SELECT C.NroCompra,
		   @NroArticulo,
		   @CodAgencia,
		   @CodDeposito,
		   C.FechaCambio,
		   'COMPRA',
		   DC.CostoOficial,
		   DC.Cantidad,
		   0,
		   NULL
	FROM DetalleCompra DC JOIN Compra C ON DC.NroCompra = C.NroCompra
	WHERE DC.CodAgencia = @CodAgencia
	AND DC.CodDeposito = @CodDeposito
	AND DC.NroArticulo = @NroArticulo
	AND C.Estado = 'C'
	AND C.FechaCambio BETWEEN @FechaDesde AND @FechaHasta

	UNION ALL

	SELECT D.NroDevolucion,
		   @NroArticulo,
		   @CodAgencia,
		   @CodDeposito,
		   D.FechaCambio,
		   'DEVOLUCIÓN',
		   DD.CostoOficial,
		   DD.Cantidad,
		   0,
		   NULL
	FROM DetalleDevolucion DD JOIN Devolucion D ON DD.NroDevolucion = D.NroDevolucion
	WHERE DD.CodAgencia = @CodAgencia
	AND DD.CodDeposito = @CodDeposito
	AND DD.NroArticulo = @NroArticulo
	AND D.FechaCambio BETWEEN @FechaDesde AND @FechaHasta

	UNION ALL

	SELECT A.NroAjuste,
		   @NroArticulo,
		   @CodAgencia,
		   @CodDeposito,
		   A.FechaAjuste,
		   'AJUSTE POSITIVO',
		   DA.CostoOficial,
		   DA.Cantidad,
		   0,
		   NULL
	FROM DetalleAjuste DA JOIN Ajuste A ON DA.NroAjuste = A.NroAjuste 
	JOIN TipoAjuste TA ON A.CodTipoAjuste = TA.CodTipoAjuste
	WHERE DA.CodAgencia = @CodAgencia
	AND DA.CodDeposito = @CodDeposito
	AND DA.NroArticulo = @NroArticulo
	AND A.FechaAjuste BETWEEN @FechaDesde AND @FechaHasta
	AND A.Estado = 'C'
	AND TA.PositivooNegativo = 1

	UNION ALL

	SELECT F.NroFactura,
		   @NroArticulo,
		   @CodAgencia,
		   @CodDeposito,
		   F.FechaEmision,
		   'FACTURA',
		   DF.CostoOficial,
		   0,
		   DF.Cantidad,
		   NULL
	FROM DetalleFactura DF JOIN Factura F ON DF.NroFactura = F.NroFactura
	WHERE DF.CodAgencia = @CodAgencia
	AND DF.CodDeposito = @CodDeposito
	AND DF.NroArticulo = @NroArticulo
	AND F.FechaEmision BETWEEN @FechaDesde AND @FechaHasta

	UNION ALL

	SELECT A.NroAjuste,
		   @NroArticulo,
		   @CodAgencia,
		   @CodDeposito,
		   A.FechaAjuste,
		   'AJUSTE NEGATIVO',
		   DA.CostoOficial,
		   0,
		   DA.Cantidad,
		   NULL
	FROM DetalleAjuste DA JOIN Ajuste A ON DA.NroAjuste = A.NroAjuste 
	JOIN TipoAjuste TA ON A.CodTipoAjuste = TA.CodTipoAjuste
	WHERE DA.CodAgencia = @CodAgencia
	AND DA.CodDeposito = @CodDeposito
	AND DA.NroArticulo = @NroArticulo
	AND A.FechaAjuste BETWEEN @FechaDesde AND @FechaHasta
	AND A.Estado = 'C'
	AND TA.PositivooNegativo = -1

	ORDER BY C.FechaCambio, C.NroCompra;

-- Recorre las filas de la variable de tipo tabla para actualizar el saldo

	SELECT @ID = MIN(ID) FROM @ExtractoArticulo
	WHERE ID > @ID;

	WHILE @ID <= (SELECT MAX(ID) FROM @ExtractoArticulo)
	BEGIN
		SELECT @Entrada = Entrada, 
		       @Salida = Salida
		FROM @ExtractoArticulo
		WHERE ID = @ID;

		SELECT @Saldo = @Saldo + @Entrada - @Salida;
--
		UPDATE @ExtractoArticulo SET Saldo = @Saldo
		WHERE ID = @ID;
--
		SELECT @ID = MIN(ID) FROM @ExtractoArticulo
		WHERE ID > @ID;
	END;

	RETURN;

END;
