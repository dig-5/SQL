-- Variables

DECLARE @NroCuenta INT = NULL,
        @NombreCuenta VARCHAR(255) = '',
		@RazonSocial VARCHAR(255),
		@RUC VARCHAR(20) = '',
		@Saldo MONEY = 0,
		@FechaSistema DATE = GETDATE();

SET @NroCuenta = 1513201;
SELECT @Saldo = 0;

SELECT @NroCuenta = NroCuenta,
       @NombreCuenta = RTRIM(ApellidoCuenta) + ', ' + RTRIM(NombreCuenta),
	   @RazonSocial = RazonSocial,
	   @RUC = CodigoRucNuevo,
	   @Saldo = TotalDebitosGS - TotalCreditosGS
FROM Cuenta
--WHERE NroCuenta = @NroCuenta;

SELECT @NroCuenta,
       @NombreCuenta,
	   @RazonSocial,
	   @RUC,
	   @Saldo,
	   @FechaSistema;

SELECT @FechaSistema, *
FROM Cuenta
WHERE NroCuenta = @NroCuenta;

--

DECLARE @MontoTotal MONEY,
        @MontoNetoIVA MONEY,
		@MontoIVA MONEY;

SELECT @MontoTotal = SUM(Factura.MontoTotal),
       @MontoNetoIVA = SUM(Factura.MontoNetoIVA),
	   @MontoIVA = SUM(Factura.MontoIVA)
FROM Factura
WHERE YEAR(Factura.FechaRendicion) = 2013;

SELECT @MontoTotal, @MontoNetoIVA, @MontoIVA;

--

DECLARE @vFactura TABLE (NroFactura BIGINT,
                         NroCuenta INT,
						 FechaRendicion DATETIME,
						 MontoNetoIVA MONEY,
						 CodMoneda SMALLINT,
						 PRIMARY KEY (NroFactura));

INSERT INTO @vFactura
SELECT NroFactura,
       NroCuenta,
	   FechaRendicion,
	   MontoNetoIVA,
	   CodMoneda
FROM Factura -- Recupera las Facturas del año 2013
WHERE YEAR(Factura.FechaRendicion) = 2013;

SELECT *
FROM @vFactura
ORDER BY NroFactura;

DELETE FROM @vFactura 
WHERE /* Siempre que el Monto
         Neto de IVA sea inferior a 10000 */ 
MontoNetoIVA < 10000
AND CodMoneda = 1;

UPDATE @vFactura SET MontoNetoIVA = MontoNetoIVA * 1.20

SELECT *
FROM @vFactura
ORDER BY NroFactura;

--

DECLARE @Contador INT = 1;

SELECT NroCuenta, GETDATE(), @Contador, 1200, NroCuenta + @Contador
FROM Cuenta;

-- Variables

declare @vnrocuenta int = 1234501, @vrazonsocial varchar(255),
        @vsaldo money;

select @vrazonsocial = razonsocial,
       @vsaldo = totaldebitosgs - totalcreditosgs
from cuenta where nrocuenta = @vnrocuenta;

select @vnrocuenta, @vrazonsocial, @vsaldo;

set @vsaldo = (select sum(totaldebitosgs - totalcreditosgs)
               from cuenta);

select 'Total de Saldos de Clientes en Guaraníes: ' + convert(varchar(20), @vSaldo);

--

declare @codcliente int = 1;

while @codcliente < 100
begin
    select * from cuenta where codcliente = @codcliente;
	select @codcliente = @codcliente + 1;
end;
--
declare @codcliente int = 1;

while @codcliente < 100
begin
    select * from cuenta where codcliente = @codcliente;
	set @codcliente = @codcliente + 1;
end;
 