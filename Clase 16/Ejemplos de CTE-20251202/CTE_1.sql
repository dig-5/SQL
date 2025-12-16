WITH PlandeCuentas (NroCuentaPadre, NroCuenta, DescripcionCuenta, NivelCuenta)
AS
(SELECT cc.NroCuentaPadre, cc.NroCuenta, cc.DescripcionCuenta, 0 as NivelCuenta
 FROM CuentaContable cc
 WHERE cc.NroCuenta = cc.NroCuentaPadre
 AND cc.NroCuenta LIKE '1%'
 
 UNION ALL

 SELECT cc.NroCuentaPadre, cc.NroCuenta, cc.DescripcionCuenta, pc.NivelCuenta + 1
 FROM CuentaContable cc
 JOIN PlandeCuentas pc 
 ON pc.NroCuenta = cc.NroCuentaPadre
 AND cc.NroCuenta LIKE '1%'
 WHERE cc.NroCuenta <> cc.NroCuentaPadre
)

SELECT * FROM PlandeCuentas
ORDER BY NroCuentaPadre, NroCuenta
OPTION (MAXRECURSION 10000)

