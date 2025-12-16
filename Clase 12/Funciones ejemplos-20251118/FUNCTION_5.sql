select max(periodo) from detalleasiento;
select * from detalleasiento where periodo between 201301 and 201304
and nrocuenta = '40127';

select dbo.FNCObtienSaldoCuenta (1,
                                 '40127',
								 201301,
								 201304,
								 null,
								 null,
								 null,
								 null);

select dbo.FNCObtienSaldoCuenta (1,
                                 '40127',
								 201301,
								 201304,
								 2,
								 null,
								 null,
								 null);

select nrocuenta, DescripcionCuenta,
       dbo.FNCObtienSaldoCuenta (1,
                                 nrocuenta,
								 201301,
								 201304,
								 null,
								 null,
								 null,
								 null)
from cuentacontable 
where nrocuenta between '40121' and '40127'
and dbo.FNCObtienSaldoCuenta (1,
                                 nrocuenta,
								 201301,
								 201304,
								 null,
								 null,
								 null,
								 null) is not null;


