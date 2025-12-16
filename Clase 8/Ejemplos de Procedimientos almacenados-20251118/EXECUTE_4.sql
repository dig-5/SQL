SET DATEFORMAT DMY;

DECLARE @ValorRetorno INT,
		@MontoNetoVenta MONEY,
		@CantidadFacturas INT,
		@CantidadClientes INT,
		@FechaIni DATE = '01/01/2012',
		@FechaFin DATE = '31/12/2012' 

EXECUTE @ValorRetorno = SLCValoresVenta @FechaIni,
									    @FechaFin,
									    @MontoNetoVenta OUTPUT,
									    @CantidadFacturas OUTPUT,
									    @CantidadClientes OUTPUT;

SELECT @ValorRetorno,
	   @MontoNetoVenta,
	   @CantidadFacturas,
       @CantidadClientes;

SET DATEFORMAT DMY;

DECLARE @ValorRetorno INT,
		@MontoNetoVenta MONEY,
		@CantidadFacturas INT,
		@CantidadClientes INT,
		@Fecha1 DATE = '01/01/2012',
		@Fecha2 DATE = '31/12/2012' 

EXECUTE @ValorRetorno = SLCValoresVenta @FechaFin = @Fecha2,
										@FechaInicio = @Fecha1,
									    @MontoNetoVenta = @MontoNetoVenta OUTPUT,
									    @CantidadFacturas = @CantidadFacturas OUTPUT,
									    @CantidadClientes = @CantidadClientes OUTPUT;

SELECT @ValorRetorno,
	   @MontoNetoVenta,
	   @CantidadFacturas,
       @CantidadClientes;
