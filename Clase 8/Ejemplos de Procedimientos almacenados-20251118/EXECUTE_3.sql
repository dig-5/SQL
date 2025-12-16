SET DATEFORMAT DMY;

DECLARE @ValorRetorno INT,
		@MontoNetoVenta MONEY,
		@CantidadFacturas INT,
		@CantidadClientes INT;

EXECUTE @ValorRetorno = SLCValoresVenta '01/01/2012',
									    '31/12/2012',
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
		@CantidadClientes INT;

EXECUTE @ValorRetorno = SLCValoresVenta '01/01/2014',
									    '31/12/2014',
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
		@CantidadClientes INT;

EXECUTE @ValorRetorno = SLCValoresVenta @MontoNetoVenta OUTPUT,
									    @CantidadFacturas OUTPUT,
									    @CantidadClientes OUTPUT;

SELECT @ValorRetorno,
	   @MontoNetoVenta,
	   @CantidadFacturas,
       @CantidadClientes;

