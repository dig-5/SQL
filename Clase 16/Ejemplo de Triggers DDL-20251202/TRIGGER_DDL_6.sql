DISABLE TRIGGER T_Comercial ON DATABASE; --ddl

DISABLE TRIGGER ALL ON DATABASE; --ddl

ENABLE TRIGGER T_Comercial ON DATABASE; --ddl

DISABLE TRIGGER S_Servidor ON ALL SERVER; --ddl

ENABLE TRIGGER S_Servidor ON ALL SERVER; --ddl

DISABLE TRIGGER ti_factura ON Factura; --dml

ENABLE TRIGGER ti_factura ON Factura; --dml

DISABLE TRIGGER ALL ON Factura; --dml
ENABLE TRIGGER ALL ON Factura; --dml

DISABLE TRIGGER ti_factura, td_factura ON Factura; --dml
ENABLE TRIGGER ti_factura, td_factura ON Factura; --dml

ALTER TABLE factura DISABLE TRIGGER ti_factura, td_factura;
ALTER TABLE factura ENABLE TRIGGER ti_factura, td_factura;
