select * from agenciadeposito
order by codagencia, coddeposito;

select * from agencia
order by codagencia

alter table agenciadeposito disable trigger all
alter table agencia disable trigger all

create view Agencia_AgenciaDeposito
(CodAgencia, 
 DescripcionAgencia, 
 Direccion, 
 Telefono,
 CodAgenciaDeposito, 
 CodDeposito, 
 DescripcionDeposito, 
 PorcDescuentooIncremento, 
 EstadoArticulo)
as
select Agencia.CodAgencia, 
	   Agencia.DescripcionAgencia, 
	   Agencia.Direccion, 
	   Agencia.Telefono,
	   AgenciaDeposito.CodAgencia, 
	   AgenciaDeposito.CodDeposito, 
	   AgenciaDeposito.DescripcionDeposito, 
	   AgenciaDeposito.PorcDescuentooIncremento, 
	   AgenciaDeposito.EstadoArticulo
from Agencia join AgenciaDeposito
on agencia.CodAgencia = AgenciaDeposito.CodAgencia


insert into Agencia_AgenciaDeposito (CodAgenciaDeposito, 
									 CodDeposito, 
									 DescripcionDeposito, 
									 PorcDescuentooIncremento, 
									 EstadoArticulo)
values (2, 720, 'Deposito de Prueba', 0, 'N');

insert into Agencia_AgenciaDeposito (CodAgencia, 
									 DescripcionAgencia, 
									 Direccion, 
									 Telefono)
values (3, 'Sucursal CDE', 'CDE', '061-741258');

delete from Agencia_AgenciaDeposito
where codagencia = 3;

delete from Agencia_AgenciaDeposito
where codagenciadeposito = 2
and coddeposito = 720;

update Agencia_AgenciaDeposito set descripcionagencia = 'Sucursal de Prueba'
where codagencia = 3;

update Agencia_AgenciaDeposito set DescripcionDeposito = 'Sucursal de Prueba'
where codagenciadeposito = 2
and coddeposito = 720;
