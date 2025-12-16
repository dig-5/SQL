create type IDFactura from bigint not null;

drop type IDFactura;

create table Factura (NroFactura IDFactura,
					  NroCliente int not null,
					  NroVendedor int not null,
					  FechaFactura datetime,
					  MontoTotal money,
					  MontoIVA money,
					  MontoNetoIva money);

drop table Factura
