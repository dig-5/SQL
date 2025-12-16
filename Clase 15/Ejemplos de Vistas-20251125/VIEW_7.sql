CREATE VIEW v_Ventas_Historicas (CodAgencia, 
								 CodVendedor, 
								 NroCuenta, 
								 NroArticulo, 
								 Periodo, 
								 Cantidad, 
								 MontoNeto)
AS 
SELECT f.CodAgencia, 
       f.CodVendedor,
	   f.NroCuenta,
	   df.NroArticulo,
	   YEAR(f.FechaRendicion) * 100 + MONTH(f.FechaRendicion),
	   SUM(df.Cantidad),
	   SUM(df.MontoNetoIVA)
FROM Factura F JOIN DetalleFActura df ON f.NroFactura = df.NroFactura
GROUP BY f.CodAgencia, 
         f.CodVendedor,
	     f.NroCuenta,
	     df.NroArticulo,
	     YEAR(f.FechaRendicion) * 100 + MONTH(f.FechaRendicion);
