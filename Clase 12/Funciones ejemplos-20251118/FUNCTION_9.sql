select CuentaContable.NroCuenta,
       CuentaContable.DescripcionCuenta,
	   SaldoCuenta.periodo,
	   SaldoCuenta.codagencia,
	   SaldoCuenta.codcentrocosto,
	   SaldoCuenta.codcentrocosto_2,
	   SaldoCuenta.codmoneda,
	   SaldoCuenta.Saldo
from CuentaContable
join dbo.FNCObtienSaldoCuentasMSTV (1,
                                    null,
								    201301,
								    201304,
								    null,
								    null,
								    null,
								    null)
  as SaldoCuenta on CuentaContable.CodEmpresa = SaldoCuenta.CodEmpresa
                and CuentaContable.NroCuenta = SaldoCuenta.NroCuenta
order by CuentaContable.NroCuenta;