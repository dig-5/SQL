insert into moneda (NroMoneda,
					DesMoneda)
values (0, 'Dólares Americanos'), (1, 'Guaraníes'), (2, 'Pesos Argentinos');

select * from moneda;

insert into MonedaCotizacion
default values;

select * from MonedaCotizacion;

set dateformat dmy;
insert into MonedaCotizacion (NroMoneda, FechaCotizacion, MontoCambioComprador, MontoCambioVendedor)
values (0, '31/01/2013', 4010, 4050), 
       (1, default, default, default),
	   (default, default, 4100, 4150);

insert into contabilidad.dbo.MonedaCotizacion
default values;
