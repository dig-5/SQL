EXECUTE SLCCuentaXOrden_1 101, 'N';

EXECUTE SLCCuentaXOrden_1 NULL, 'R';

DECLARE @ValorRetorno INT;
EXECUTE @ValorRetorno = SLCCuentaXOrden_1 NULL, 'R';
SELECT @ValorRetorno;
