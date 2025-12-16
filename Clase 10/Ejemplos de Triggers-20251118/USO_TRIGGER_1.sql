select * from auditoriaasiento;

select * from asiento
order by fechaasiento desc;


alter table detalleasiento disable trigger all
delete from detalleasiento
where codempresa = 1 and periodo = 201304 and nroasiento between 216 and 219;
alter table detalleasiento enable trigger all

alter table TransaccionCtaCteBancaria disable trigger all

delete from TransaccionCtaCteBancaria
where codempresa = 1 and periodo = 201304 and nroasiento between 216 and 219;
update compra set nroasiento = null
where codempresa = 1 and periodo = 201304 and nroasiento between 216 and 219;

delete from asiento
where codempresa = 1 and periodo = 201304 and nroasiento between 216 and 219;

set dateformat dmy;
update asiento set fechaasiento = '30/05/2013'
where codempresa = 1 and periodo = 201304 and nroasiento between 220 and 222;

insert into asiento
values (1, 201305, 1, getdate(), null, null, 0, 0, 'A', 1, convert(varchar(20), suser_sname()), getdate(), null, null, null, null),
(1, 201305, 2, getdate(), null, null, 0, 0, 'A', 1, convert(varchar(20), suser_sname()), getdate(), null, null, null, null),
(1, 201305, 3, getdate(), null, null, 0, 0, 'A', 1, convert(varchar(20), suser_sname()), getdate(), null, null, null, null),
(1, 201305, 4, getdate(), null, null, 0, 0, 'A', 1, convert(varchar(20), suser_sname()), getdate(), null, null, null, null),
(1, 201305, 5, getdate(), null, null, 0, 0, 'A', 1, convert(varchar(20), suser_sname()), getdate(), null, null, null, null);

insert into asiento
values (1, 201305, 1, getdate(), null, null, 0, 0, 'A', 1, convert(varchar(20), suser_sname()), getdate(), null, null, null, null);

insert into asiento
values (1, 201305, 6, getdate(), null, null, 0, 0, 'A', 1, convert(varchar(20), suser_sname()), getdate(), null, null, null, null);

alter table asiento disable trigger tiud_asiento;
