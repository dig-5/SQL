SELECT  NroFactura "Número de Factura" , 
       NroCuenta AS NumeroCuenta, 
	    CodVendedor "Código Vendedor" , 
	   FechaEmision FechaDeEmision, 
	   FechaRendicion  Fecha_Rendicion , 
	    CodAgencia "Código de Agencia" , 
	    MontoTotal "Monto Total" , 
	   MontoIVA AS "Monto del IVA",
	   MontoNetoIVA AS "Monto Sin IVA", 
	   (MontoNetoIVA * IndiceComision) / 100 "Comisión" , 
	   GETDATE() "Fecha/Hora Sistema" 
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000
ORDER BY NumeroCuenta ASC, "Monto Sin IVA" DESC;

SELECT NroFactura "Número de Factura" , 
       NroCuenta AS NumeroCuenta, 
	   CodVendedor "Código Vendedor"  , 
	   FechaEmision FechaDeEmision, 
	    FechaRendicion Fecha_Rendicion , 
	    CodAgencia "Código de Agencia" , 
	   MontoTotal "Monto Total"  , 
	   MontoIVA AS "Monto del IVA",
	   MontoNetoIVA AS "Monto Sin IVA", 
	   (MontoNetoIVA * IndiceComision) / 100 "Comisión"  , 
	    GETDATE() "Fecha/Hora Sistema" 
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000
ORDER BY 2 ASC, 9 DESC;

SELECT  NroFactura "Número de Factura" , 
       NroCuenta AS NumeroCuenta, 
	   CodVendedor "Código Vendedor"  , 
	   FechaEmision FechaDeEmision, 
	   FechaRendicion Fecha_Rendicion  , 
	   CodAgencia "Código de Agencia"  , 
	   MontoTotal "Monto Total"  , 
	   MontoIVA  "Monto del IVA" ,
	   MontoNetoIVA AS "Monto Sin IVA", 
	  (MontoNetoIVA * IndiceComision) / 100  "Comisión"  , 
	   GETDATE() "Fecha/Hora Sistema"
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000
ORDER BY "Comisión" DESC;

SELECT "Número de Factura" = NroFactura, 
       NroCuenta AS NumeroCuenta, 
	   "Código Vendedor" = CodVendedor, 
	   FechaEmision FechaDeEmision, 
	   Fecha_Rendicion = FechaRendicion, 
	   "Código de Agencia" = CodAgencia, 
	   "Monto Total" = MontoTotal, 
	   MontoIVA AS "Monto del IVA",
	   MontoNetoIVA AS "Monto Sin IVA", 
	   "Comisión" = (MontoNetoIVA * IndiceComision) / 100, 
	   "Fecha/Hora Sistema" = GETDATE()
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000
ORDER BY (MontoNetoIVA * IndiceComision) / 100 DESC;

SELECT ALL 
       NroFactura "Número de Factura"  , 
       NroCuenta AS NumeroCuenta, 
	    CodVendedor "Código Vendedor" , 
	   FechaEmision FechaDeEmision, 
	   FechaRendicion Fecha_Rendicion  , 
	   CodAgencia "Código de Agencia", 
	   MontoTotal "Monto Total" , 
	   MontoIVA AS "Monto del IVA",
	   MontoNetoIVA AS "Monto Sin IVA", 
	    (MontoNetoIVA * IndiceComision) / 100 "Comisión" , 
	   GETDATE() "Fecha/Hora Sistema" 
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000
ORDER BY 9 DESC;

SELECT DISTINCT
       NroCuenta AS NumeroCuenta, 
	   CodVendedor "Código Vendedor" 
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000
ORDER BY 2, 1;

