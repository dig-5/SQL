create view v_Venta_Historico (Periodo, 
							   NroArticulo,
							   NroCuenta,
							   CodAgencia,
							   CodDeposito,
							   CodProveedor,
							   CodMoneda,
							   Cantidad,
							   MontoNetoTotal)
as
select year(f.fecharendicion) * 100 + MONTH(f.fecharendicion) as Periodo,
       df.NroArticulo,
	   f.NroCuenta,
	   df.CodAgencia,
	   df.CodDeposito,
	   a.CodProveedor,
	   f.CodMoneda,
	   sum(df.cantidad),
	   sum(df.montonetoiva)
from DetalleFactura df join Factura f on df.NroFactura = f.NroFactura
join Articulo a on df.NroArticulo = a.NroArticulo
group by year(f.fecharendicion) * 100 + MONTH(f.fecharendicion),
		 df.NroArticulo,
		 f.NroCuenta,
		 df.CodAgencia,
		 df.CodDeposito,
		 a.CodProveedor,
		 f.CodMoneda;
