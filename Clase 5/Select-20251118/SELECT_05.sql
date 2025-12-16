SELECT TOP (10)
       NroFactura  "Número de Factura" , 
       NroCuenta AS NumeroCuenta, 
	   CodVendedor "Código Vendedor"  , 
	   FechaEmision FechaDeEmision, 
	    FechaRendicion Fecha_Rendicion , 
	   CodAgencia "Código de Agencia"  , 
	    MontoTotal "Monto Total", 
	   MontoIVA AS "Monto del IVA",
	   MontoNetoIVA AS "Monto Sin IVA", 
	    (MontoNetoIVA * IndiceComision) / 100 "Comisión" , 
	   GETDATE() "Fecha/Hora Sistema" 
FROM dbo.Factura
WHERE YEAR(FechaRendicion) = 2013
AND CodMoneda = 1
AND MontoTotal > 5000000
ORDER BY "Monto Sin IVA" DESC;
