select case contador 
            when 1 then 'Cliente Principal'
            when 2 then 'Cliente Secundario'
            when 3 then 'Cliente Secundarísimo'
            else 'Cliente Re-hiper-archi-Secundario'
       end,
       nrocuenta,
       razonsocial,
       contador
from cuenta
order by nrocuenta;