select * from agenciadepositoarticulo
where nroarticulo = 23424
order by codagencia, coddeposito;

select * from agenciadeposito 
where codagencia =2 
order by coddeposito;

select * from transferencia where nrotransferencia = 106360;
select * from detalletransferencia where nrotransferencia = 106360;

update transferencia set coddepositoentrada = 810
where nrotransferencia = 106360

select * from transferencia where estadosalida = 'A'
order by nrotransferencia desc;

select * from agenciadepositoarticulo
where codagencia = 2
and coddeposito = 30
order by existencia desc;



execute PRCCierraTrasferencia 106360;
