--Cursores

-- 1) Declare cursor
-- 2) Open cursor
-- 3) Fetch cursor
-- 4) While @@fetch_status = 0
-- 5) Procesar los datos obtenidos por el cursor
-- 6) Fetch cursor
-- 7) Close cursor / Deallocate cursor

set dateformat dmy;
set nocount on;

declare @nrocuenta int, @razonsocial varchar(50);
declare @nrofactura bigint, @fecharendicion datetime, @montoneto money;
declare @cantfacturas int, @montototal money;

declare cursorcuenta cursor for select cuenta.NroCuenta, 
									   cuenta.RazonSocial
								  from cuenta
								 where cuenta.NroCuenta 
								    in (select factura.nrocuenta
										  from Factura
										 where FechaRendicion between '01/01/2012' and '31/01/2012')
								 order by cuenta.NroCuenta;

open cursorcuenta;

fetch next from cursorcuenta into @nrocuenta, @razonsocial;

while @@FETCH_STATUS = 0
begin
	
	select 'Cliente: ', @nrocuenta, @razonsocial;
	select @cantfacturas = 0, @montototal = 0;

	declare cursorfactura cursor for select factura.nrofactura,
											factura.FechaRendicion,
											Factura.MontoNetoIVA
									   from Factura
									  where FechaRendicion between '01/01/2012' and '31/01/2012'
									    and Factura.NroCuenta = @nrocuenta
									  order by Factura.NroFactura;

	open cursorfactura;

	fetch next from cursorfactura into @nrofactura, @fecharendicion, @montoneto;

	while @@FETCH_STATUS = 0
	begin
	
		select 'Nro.Factura: ', @nrofactura, ' Fecha Rendición: ', @fecharendicion, ' Monto Neto: ', @montoneto;
	    select @cantfacturas = @cantfacturas + 1, @montototal = @montototal + @montoneto;

    	fetch next from cursorfactura into @nrofactura, @fecharendicion, @montoneto;

	end;

	deallocate cursorfactura;
	
	select 'Cantidad de Facturas del Cliente: ', @nrocuenta, ' - ', @cantfacturas, ' Importe Total: ', @montototal;

    fetch next from cursorcuenta into @nrocuenta, @razonsocial;

end;

deallocate cursorcuenta;
