--Cláusula OUTPUT
-- INSERT
-- UPDATE
-- DELETE

insert into Agencia (CodAgencia, 
					 DescripcionAgencia,
					 Direccion,
					 Telefono)
output inserted.*
values (4, 'CDE', 'CDE', '061-423568');

insert into Agencia (CodAgencia, 
					 DescripcionAgencia,
					 Direccion,
					 Telefono)
output inserted.CodAgencia, inserted.DescripcionAgencia
values (5, 'PJC', 'PJC', '061-423568'),
       (6, 'ENC', 'ENC', '071-423568');

declare @vAgencia table (CodAgencia smallint, 
						 DesAgencia varchar(50));

insert into Agencia (CodAgencia, 
					 DescripcionAgencia,
					 Direccion,
					 Telefono)
output inserted.CodAgencia, inserted.DescripcionAgencia
into @vAgencia
values (7, 'CO', 'CO', '061-423568'),
       (8, 'PILAR', 'PILAR', '071-423568');

select * from @vAgencia;

