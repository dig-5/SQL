CREATE VIEW v_Ventas_Historicas_1
AS 
SELECT f.CodAgencia, 
       f.CodVendedor,
	   f.NroCuenta,
	   df.NroArticulo,
	   YEAR(f.FechaRendicion) * 100 + MONTH(f.FechaRendicion) AS Periodo,
	   SUM(df.Cantidad) AS Cantidad,
	   SUM(df.MontoNetoIVA) AS MontoNeto
FROM Factura F JOIN DetalleFActura df ON f.NroFactura = df.NroFactura
GROUP BY f.CodAgencia, 
         f.CodVendedor,
	     f.NroCuenta,
	     df.NroArticulo,
	     YEAR(f.FechaRendicion) * 100 + MONTH(f.FechaRendicion);
