select * from CtaCte
where NroCuenta = 31673401
order by NroCuenta desc

select case when codconcepto between 1 and 9 then ctacte.debito else 0 end as Debito,
       case when codconcepto not between 1 and 9 then ctacte.Credito * -1 else 0 end as Credito,
       case when codconcepto between 1 and 9 then ctacte.debito else ctacte.Credito * -1 end as Saldo
from CtaCte
where NroCuenta = 10005101
compute sum(case when codconcepto between 1 and 9 then ctacte.debito else ctacte.Credito * -1 end);


select nrocuenta, razonsocial, 
       dbo.FNCObtieneSaldoCuenta (NroCuenta,
								  1,
								  null) as Saldo
from cuenta
--where NroCuenta = 31673401
order by 3 desc

select nrocuenta, razonsocial, 
       saldo = dbo.FNCObtieneSaldoCuenta (NroCuenta, default, default)
from cuenta
where dbo.FNCObtieneSaldoCuenta (NroCuenta, default, default) > 10000000
order by 3 desc
