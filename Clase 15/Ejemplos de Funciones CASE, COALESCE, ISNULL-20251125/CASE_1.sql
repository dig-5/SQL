
select case situacioncliente
            when 'C' then 'Cobro Apremiante'
            when 'I' then 'Incobrable'
            when 'N' then 'Normal'
            else 'Otros'
       end as Situacion,
       *
from Cliente
order by CodCliente;