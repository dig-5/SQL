INSERT INTO v_Ventas_Historicas (CodAgencia, 
								 CodVendedor, 
								 NroCuenta, 
								 NroArticulo, 
								 Periodo, 
								 Cantidad, 
								 MontoNeto)
SELECT 1, 120, 12001, 10345, 201412, 100, 5000000;

SELECT * FROM v_Ventas_Historicas
WHERE Periodo BETWEEN 201001 AND 201012
ORDER BY NroArticulo, Cantidad DESC;
