CREATE FUNCTION dbo.FNCObtieneCantidadVendida (@CodAgencia SMALLINT = -1,
											   @CodDeposito SMALLINT = -1,
											   @NroArticulo INT,
											   @FechaInicio DATETIME,
											   @FechaFin DATETIME)

RETURNS FLOAT

AS

BEGIN

	DECLARE @CantidadVendida FLOAT;

-- Obtiene la Cantidad Vendida de un Artículo en un período de tiempo dado

	SELECT @CantidadVendida = SUM(DF.Cantidad)
	FROM DetalleFactura DF JOIN Factura F ON DF.NroFactura = F.NroFactura
	WHERE F.CodAgencia = CASE WHEN @CodAgencia = -1 THEN F.CodAgencia ELSE @CodAgencia END
	AND F.CodDeposito = CASE WHEN @CodDeposito = -1 THEN F.CodDeposito ELSE @CodDeposito END
	AND DF.NroArticulo = @NroArticulo
	AND F.FechaRendicion BETWEEN @FechaInicio AND @FechaFin;

-- Retorna la cantidad calculada

	RETURN @CantidadVendida;

END;

