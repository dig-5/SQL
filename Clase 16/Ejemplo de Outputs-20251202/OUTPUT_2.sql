delete from agencia
output deleted.*
where codagencia between 7 and 8;

select * from agencia;

delete from agencia
output deleted.CodAgencia, deleted.DescripcionAgencia
where codagencia between 5 and 6;

update agencia set telefono = null
output deleted.*, inserted.*
where CodAgencia = 4;
