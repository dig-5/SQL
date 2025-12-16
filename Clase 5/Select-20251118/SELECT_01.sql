SELECT * FROM dbo.Factura;

SELECT * FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000;

EXECUTE SP_HELP FACTURA;

SELECT NroFactura, NroCuenta, CodVendedor, FechaEmision, 
	   FechaRendicion, CodAgencia, MontoTotal, MontoIVA,
	   MontoNetoIVA
FROM dbo.Factura;

SELECT NroFactura, NroCuenta, CodVendedor, FechaEmision, 
	   FechaRendicion, CodAgencia, MontoTotal, MontoIVA,
	   MontoNetoIVA
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000;

SELECT NroFactura, NroCuenta, CodVendedor, FechaEmision, 
	   FechaRendicion, CodAgencia, MontoTotal, MontoIVA,
	   MontoNetoIVA, (MontoNetoIVA * IndiceComision) / 100, 
	   GETDATE()
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000;

SELECT NroFactura "Número de Factura"  , 
       NroCuenta AS NumeroCuenta, 
	    CodVendedor "Código Vendedor" , 
	   FechaEmision FechaDeEmision, 
	    FechaRendicion Fecha_Rendicion , 
	   CodAgencia "Código de Agencia"  , 
	    MontoTotal "Monto Total" , 
	   MontoIVA AS "Monto del IVA",
	   MontoNetoIVA AS "Monto Sin IVA", 
	   (MontoNetoIVA * IndiceComision) / 100 "Comisión"  ,  
	   GETDATE()  "Fecha/Hora Sistema" 
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000;

