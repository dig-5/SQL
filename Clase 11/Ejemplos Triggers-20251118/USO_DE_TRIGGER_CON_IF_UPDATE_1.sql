INSERT INTO AJUSTE (CodTipoAjuste,
					NroComprobante,
					FechaAjuste,
					Estado,
					Observacion,
					NroOT)
VALUES (1, '04112014-1', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-2', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-3', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-4', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-5', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-6', GETDATE(), 'A', 'Ajuste de Prueba', NULL);

INSERT INTO AJUSTE (CodTipoAjuste,
					NroComprobante,
					FechaAjuste,
					Estado,
					Observacion,
					NroOT)
VALUES (1, '04112014-1', GETDATE(), 'A', 'Ajuste de Prueba', 1000000),
       (1, '04112014-2', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-3', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-4', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-5', GETDATE(), 'A', 'Ajuste de Prueba', NULL),
       (1, '04112014-6', GETDATE(), 'A', 'Ajuste de Prueba', NULL);

SELECT * FROM Ajuste
WHERE NroComprobante LIKE '04112014%';

UPDATE Ajuste SET Estado = 'A'
WHERE NroComprobante LIKE '04112014%';

UPDATE Ajuste SET CodEmpresa = 1,
				Periodo	= 201209,
				NroAsiento = 91,
				Estado = 'C'
WHERE NroComprobante LIKE '04112014%';

ALTER TABLE Ajuste DISABLE TRIGGER ALL;
ALTER TABLE Ajuste ENABLE TRIGGER ALL;

DISABLE TRIGGER [TIUD_Ajuste] ON Ajuste;
ENABLE TRIGGER [TIUD_Ajuste] ON Ajuste;

DISABLE TRIGGER ALL ON Ajuste;
ENABLE TRIGGER ALL ON Ajuste;

