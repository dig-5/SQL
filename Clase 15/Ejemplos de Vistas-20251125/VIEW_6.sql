CREATE VIEW v_Datos_Sistema (Usuario, FechaHora, EstacionTrabajo, Aplicacion)
AS SELECT SUSER_NAME(), GETDATE(), HOST_NAME(), APP_NAME();

SELECT * FROM v_Datos_Sistema;
