select max(fechacambio) from compra;
select min(fechacambio) from compra;

select fechacambio, count(*)
from compra
group by fechacambio
order by 2 desc;

update compra set estado = 'A' where FechaCambio = '2012-01-23';

select * from compra where FechaCambio = '2012-06-20';
select DC.* from Compra C join DetalleCompra DC on C.NroCompra = DC.NroCompra
where C.FechaCambio = '2012-06-20';

DELETE FROM DetalleCompra
FROM Compra C JOIN DetalleCompra DC ON C.NroCompra = DC.NroCompra
WHERE C.FechaCambio = '2012-01-23';

DELETE FROM Compra
FROM Compra C LEFT OUTER JOIN DetalleCompra DC ON C.NroCompra = DC.NroCompra
WHERE DC.NroCompra IS NULL;

