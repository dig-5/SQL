
WITH VentasxMes (Periodo, 
				 CodMoneda,
				 NroCuenta, 
				 RazonSocial, 
				 NroArticulo, 
				 DescripcionArticulo,
				 Cantidad,
				 MontoNetoVenta)

AS

(SELECT YEAR(Factura.FechaEmision) * 100 + MONTH(Factura.FechaEmision),
        Factura.CodMoneda,
        Factura.NroCuenta,
		Cuenta.RazonSocial,
		DetalleFactura.NroArticulo,
		Articulo.DescripcionArticulo,
		SUM(DetalleFactura.Cantidad),
		SUM(DetalleFactura.MontoNetoIva)
 FROM Factura JOIN DetalleFactura ON Factura.NroFactura = DetalleFactura.NroFactura
 JOIN Articulo ON DetalleFactura.NroArticulo = Articulo.NroArticulo
 JOIN Cuenta ON Factura.NroCuenta = Cuenta.NroCuenta
 GROUP BY YEAR(Factura.FechaEmision) * 100 + MONTH(Factura.FechaEmision),
          Factura.CodMoneda,
          Factura.NroCuenta,
		  Cuenta.RazonSocial,
		  DetalleFactura.NroArticulo,
		  Articulo.DescripcionArticulo
)

SELECT * FROM VentasxMes
WHERE Periodo BETWEEN 201201 AND 201212
ORDER BY Cantidad DESC;
