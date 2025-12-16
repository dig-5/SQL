select CtaCte.NroCuenta, 
       Cuenta.RazonSocial,
       CtaCte.NroFactura,
       CtaCte.FechaCambio,
       CtaCte.CodConcepto,
       CtaCte.Concepto,
       case when CtaCte.CodMoneda = 0 and CtaCte.CodConcepto between 1 and 9 then CtaCte.Debito else 0 end as DebitoDl,
       case when CtaCte.CodMoneda = 0 and CtaCte.CodConcepto not between 1 and 9 then CtaCte.Credito else 0 end as CreditoDl,
       case when CtaCte.CodMoneda = 1 and CtaCte.CodConcepto between 1 and 9 then CtaCte.Debito else 0 end as DebitoGs,
       case when CtaCte.CodMoneda = 1 and CtaCte.CodConcepto not between 1 and 9 then CtaCte.Credito else 0 end as CreditoGs
from CtaCte join Cuenta on CtaCte.NroCuenta = Cuenta.NroCuenta
where YEAR(ctacte.fechacambio) = 2012
order by CtaCte.NroCuenta, CtaCte.FechaCambio

compute sum(case when CtaCte.CodMoneda = 0 and CtaCte.CodConcepto between 1 and 9 then CtaCte.Debito else 0 end),
        sum(case when CtaCte.CodMoneda = 0 and CtaCte.CodConcepto not between 1 and 9 then CtaCte.Credito else 0 end),
        sum(case when CtaCte.CodMoneda = 1 and CtaCte.CodConcepto between 1 and 9 then CtaCte.Debito else 0 end),
        sum(case when CtaCte.CodMoneda = 1 and CtaCte.CodConcepto not between 1 and 9 then CtaCte.Credito else 0 end);
