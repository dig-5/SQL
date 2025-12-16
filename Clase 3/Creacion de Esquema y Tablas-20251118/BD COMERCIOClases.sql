
/*
1.     Crear la BD (Comercio) definiendo filename, name, sizes, maxsize en el filegroup por defecto, crear un 
file principal, uno secundario, uno de tipo filestream y tres logfiles.
*/


use master;

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DbComercio')
BEGIN
    DROP DATABASE DbComercio;
    -- ALTER DATABASE DbComercio SET single_user WITH ROLLBACK IMMEDIATE;
END



go


-- select  InstanceDefaultDataPath = serverproperty('InstanceDefaultDataPath'),InstanceDefaultLogPath = serverproperty('InstanceDefaultLogPath');


/*
1.     Crear la BD (Comercio) definiendo filename, name, sizes, maxsize en el filegroup por defecto, crear un 
file principal, uno secundario, uno de tipo filestream y tres logfiles.
*/

use master;

/* crear BD segun especificaciones dadas */
CREATE DATABASE DbComercio
ON(
Filename='/var/opt/mssql/data/clases/DbComercio.mdf',
Name='DbComercio'
)
;

/*
2.Agregar un filegroup denominado FGTablas definiendo un file en el mismo directorio que el punto anterior, 
así mismo hacer lo mismo con el filegroup FGIndice
*/

alter database DbComercio
add filegroup FGTablas;

go

alter database DbComercio
add file (
filename = '/var/opt/mssql/data/clases/DbComercio.ndf',
name = 'fileEnTabla'
) to filegroup FGTablas;

go

alter database DbComercio
add filegroup FGIndice;

go

alter database DbComercio
add file (
filename = '/var/opt/mssql/data/clases/fileEnIndice.ndf',
name = 'fileEnIndice'
) to filegroup FGIndice;




/*3. Setear el filegroup que almacena tablas por defecto, eliminar un datafile del punto 1 al igual que un logfile*/
/*3.1 Establecer el filegroup que almacena tablas por defecto*/
ALTER DATABASE DbComercio
MODIFY FILEGROUP FGTablas DEFAULT;
GO


/*
5.  Crear 2 tablas, todas con nombres definidos en los constraint o a nivel tabla, columna o con alter, tener en cuenta 
    que se deben crear en orden, es decir, no puedo crear la tabla articulo sin antes crear las tablas a las cuales hacen referencia. 
    (todas en el filegroup de tablas, y los constraint único en el filegroup de índices)
*/

use DbComercio


go
create table Agencia
(
CodAgencia smallint primary key,
DesAgencia varchar(50) not null,
constraint UQ_Agencia unique (DesAgencia) on FGIndice
) on FGTablas;
go

create table AgenciaDeposito
(
CodAgencia smallint,
CodDeposito smallint,
DesDeposito varchar(50) not null,
constraint PK_AgenciaDeposito primary key (CodAgencia, CodDeposito),
constraint FK_AgenciaDeposito_Agencia foreign key (CodAgencia) references Agencia (CodAgencia)
) on FGTablas;
go



CREATE TABLE Marca
(
CodMarca smallint PRIMARY KEY,
DesMarca varchar(40) NOT NULL,
CONSTRAINT UQ_Marca UNIQUE (DesMarca) ON FGIndice
) ON FGTablas;
GO

CREATE TABLE Linea
(
CodLinea smallint PRIMARY KEY,
DesLinea varchar(40) NOT NULL,
CONSTRAINT UQ_Linea UNIQUE (DesLinea) ON FGIndice
) ON FGTablas;
GO


CREATE TABLE Regimen
(
CodRegimen int PRIMARY KEY ON FGTablas,
DesRegimen varchar(30) NOT NULL,
PorcentajeIVA REAL NOT NULL,
CONSTRAINT UQ_Regimen UNIQUE (DesRegimen) ON FGIndice
);
GO

CREATE TABLE Pais
(
CodPais smallint PRIMARY KEY,
DesPais varchar(50) NOT NULL,
CONSTRAINT UQ_Pais UNIQUE (DesPais) ON FGIndice
)
ON FGTablas;
GO

CREATE TABLE Zona
(
CodZona smallint PRIMARY KEY,
DesZona varchar(40) NOT NULL,
CONSTRAINT UQ_Zona UNIQUE (DesZona) ON FGIndice
) ON FGTablas;
GO

CREATE TABLE Moneda
(
CodMoneda smallint PRIMARY KEY,
DesMoneda varchar(50) NOT NULL,
CONSTRAINT UQ_Moneda UNIQUE (DesMoneda) ON FGIndice
) ON FGTablas;
GO



CREATE TABLE Proveedor(
CodProveedor int NOT NULL PRIMARY KEY,
RazonSocial varchar(50) NOT NULL,
RUC varchar(50) NOT NULL,
Telefono varchar(50) NULL,
Fax varchar(50) NULL,
Email varchar(50) NULL,
CodPais smallint NOT NULL,
CONSTRAINT FK_Pais FOREIGN KEY (CodPais) REFERENCES Pais(CodPais),
CONSTRAINT UQ_RazonSocial UNIQUE (RazonSocial) ON FGIndice,
CONSTRAINT UQ_Ruc UNIQUE (RUC) ON FGIndice
) ON FGTablas;
GO

CREATE TABLE Articulo(
NroArticulo int NOT NULL PRIMARY KEY,
DesArticulo varchar(50) NOT NULL,
CodigoBarra varchar(50) NOT NULL,
CodMarca smallint NOT NULL,
CodLinea smallint NOT NULL,
CodProveedor int NOT NULL,
CodRegimen int NOT NULL,
Peso real NOT NULL,
Volumen real NOT NULL,
CostoDolares real NOT NULL,
CostoGuaranies real NOT NULL,
PrecioDolares money NOT NULL,
Estado bit NOT NULL,
CONSTRAINT FK_Marca FOREIGN KEY (CodMarca) REFERENCES Marca(CodMarca),
CONSTRAINT FK_Linea FOREIGN KEY (CodLinea) REFERENCES Linea(CodLinea),
CONSTRAINT FK_Proveedor FOREIGN KEY (CodProveedor) REFERENCES Proveedor(CodProveedor),
CONSTRAINT FK_Regimen FOREIGN KEY (CodRegimen) REFERENCES Regimen(CodRegimen),
CONSTRAINT UQ_DesArticulo UNIQUE (DesArticulo) ON FGIndice,
CONSTRAINT UQ_CodBarra UNIQUE (CodigoBarra) ON FGIndice,
CONSTRAINT CHK_Estado CHECK(Estado in ('A','I'))
) ON FGTablas
GO


CREATE TABLE Cotizacion (
CodMoneda smallint,
FechaCotizacion datetime,
MontoCambio money not null,
CONSTRAINT PK_CodMoneda_FechaCotizacion PRIMARY KEY(CodMoneda ,FechaCotizacion),
CONSTRAINT FK_CodMoneda FOREIGN KEY (CodMoneda) references Moneda
)ON FGTablas;
GO
CREATE TABLE Ramo (
CodRamo smallint,
DesRamo varchar(50) not null UNIQUE,
CONSTRAINT PK_CodRamo PRIMARY KEY(CodRamo)
)ON FGTablas;
GO


create table Vendedor (
CodVendedor smallint,
NombreVendedor varchar(50) NOT NULL,
PorComision real NOT NULL
CONSTRAINT PK_CodVendedor PRIMARY KEY(CodVendedor),
) on FGTablas;

GO

create table Cobrador(
CodCobrador smallint,
NombreCobrador varchar(50) NOT NULL,
PorComision real NOT NULL,
CONSTRAINT PK_CodCobrador PRIMARY KEY(CodCobrador),
)on FGTablas;
GO



CREATE TABLE Cuenta
(
NroCuenta int constraint pk_Cuenta_NroCuenta PRIMARY KEY,
NombreCuenta varchar(50) NOT NULL,
RazonSocial varchar(50) NOT NULL,
RUC varchar(15) NOT NULL,
Telefono varchar(15),
Direccion varchar(50),
CodVendedor smallint NOT NULL,
CodRamo smallint NOT NULL,
CodZona smallint NOT NULL,
CodCobrador smallint NOT NULL,
TotalDebitosGs money NOT NULL default 0,
TotalCreditosGs money NOT NULL default 0,
TotalDebitosDI money NOT NULL default 0,
TotalCreditosDI money NOT NULL default 0,
Estado char(1) NOT NULL,
check (Estado = 'A' or Estado ='I'),
CONSTRAINT FK_CodVendedor FOREIGN KEY (CodVendedor) REFERENCES Vendedor(CodVendedor),
CONSTRAINT FK_Ramo FOREIGN KEY (CodRamo) REFERENCES Ramo(CodRamo),
CONSTRAINT FK_Zona FOREIGN KEY (CodZona) REFERENCES Zona(CodZona),
CONSTRAINT FK_Cobrador FOREIGN KEY (CodCobrador) REFERENCES Cobrador(CodCobrador),
) ON FGTablas;
go



create table Concepto (
CodConcepto smallint,
DesConcepto varchar(40) NOT NULL UNIQUE ON FGIndice,
DebitooCredito smallint CHECK (DebitooCredito IN (1, -1)),
CONSTRAINT PK_CodConcepto PRIMARY KEY(CodConcepto),
)on FGTablas;

go




CREATE TABLE Factura (
NroFactura int IDENTITY(1,1),
NroCuenta int NOT NULL,
CodVendedor smallint NOT NULL,
PorcComision real NOT NULL,
CodAgencia smallint NOT NULL,
CodDeposito smallint NOT NULL,
CodMoneda smallint NOT NULL,
FechaCotizacion datetime NOT NULL,
MontoCambio money NOT NULL,
FechaEmision datetime,
FechaRendicion datetime,
Plazo int NOT NULL,
PorcDescuento real NOT NULL DEFAULT 0,
MontoTotal money,
MontoIVA money,
MontoNetoIVA money,
CONSTRAINT PK_NroFactura  PRIMARY KEY(NroFactura ),
)on FGTablas;
GO


create table CtaCte(
NroCtaCte int IDENTITY(1,1),
NroCuenta int NOT NULL,
CodAgencia smallint NOT NULL,
CodMoneda smallint NOT NULL,
FechaOperacion datetime NOT NULL,
FechaVencimiento datetime NOT NULL,
CodConcepto smallint NOT NULL,
NroFactura int NOT NULL, --fk
Debito money NOT NULL,
Credito money NOT NULL,
Concepto varchar(60) NOT NULL,
CONSTRAINT PK_NroCtaCte PRIMARY KEY(NroCtaCte),
CONSTRAINT FK_NroCuenta FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta),
CONSTRAINT FK_CodAgencia FOREIGN KEY (CodAgencia) REFERENCES Agencia(CodAgencia),
CONSTRAINT FK_CodMoneda2 FOREIGN KEY (CodMoneda) REFERENCES Moneda(CodMoneda),
CONSTRAINT FK_CodConcepto FOREIGN KEY (CodConcepto) REFERENCES Concepto(CodConcepto),
CONSTRAINT FK_NroFactura FOREIGN KEY (NroFactura) REFERENCES Factura(NroFactura),
) on FGTablas
go






ALTER TABLE Factura
ADD CONSTRAINT FK_NroCuenta2 FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta),
CONSTRAINT FK_CodVendedor2 FOREIGN KEY (CodVendedor) REFERENCES Vendedor(CodVendedor),
CONSTRAINT FK_CodAgencia2 FOREIGN KEY (CodAgencia) REFERENCES Agencia(CodAgencia),
CONSTRAINT FK_CodMoneda3 FOREIGN KEY (CodMoneda) REFERENCES Moneda(CodMoneda);





/* Crear tabla TipoAjuste y AgenciaDepositoArticulo */
CREATE TABLE TipoAjuste(
CodTipoAjuste smallint PRIMARY KEY,
DesTipoAjuste varchar(40) NOT NULL,
PositivooNegativo smallint NOT NULL CHECK (PositivooNegativo IN (1, -1))
) ON FGTablas;
go
CREATE TABLE AgenciaDepositoArticulo(
CodAgencia smallint,
CodDeposito smallint,
NroArticulo int,
FechaVencto date,
Existencia float NOT NULL DEFAULT 0 CHECK (Existencia >=0),
FOREIGN KEY(CodAgencia,CodDeposito) references AgenciaDeposito(CodAgencia,CodDeposito),
FOREIGN KEY (NroArticulo) references Articulo,
primary key(CodAgencia, CodDeposito,NroArticulo, FechaVencto)
) ON FGTablas;
go


/* Crear tabla Recibo y Ajuste */
CREATE TABLE Recibo(
NroRecibo int,
NroCuenta int not null,
CodCobrador smallint not null,
FechaRecibo datetime not null,
CodAgencia smallint not null,
ImporteTotalCobrado money not null,
CONSTRAINT PK_NroRecibo PRIMARY KEY(NroRecibo),
CONSTRAINT FK_NroCuentaRecibo FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta),
CONSTRAINT FK_CodCobradorRecibo FOREIGN KEY(CodCobrador) REFERENCES Cobrador(CodCobrador),
CONSTRAINT FK_CodAgenciaRecibo FOREIGN KEY(CodAgencia) REFERENCES Agencia(CodAgencia)
) ON FGTablas;
go

CREATE TABLE Ajuste(
NroAjuste int identity(1,1),
NroComprobante varchar(15) not null,
CodAgencia smallint not null,
CodDeposito smallint not null,
FechaAjuste datetime not null,
Estado char(1),
CONSTRAINT PK_NroAjuste PRIMARY KEY(NroAjuste),
CONSTRAINT FK_CodAgenciaAjuste_CodDepositoAjuste FOREIGN KEY(CodAgencia,CodDeposito) references AgenciaDeposito(CodAgencia,CodDeposito),
CONSTRAINT CHK_EstadoAjuste CHECK(Estado in ('NN','A','C'))
) ON FGTablas;
go



/*Crear tabla NotaDeDebito y NotaDeCredito*/

CREATE TABLE NotaDeDebito(
NroNotaDebito int PRIMARY KEY,
NroCuenta INT NOT NULL,
CodAgencia SMALLINT NOT NULL,
CodMoneda SMALLINT NOT NULL,
Concepto VARCHAR(255) NOT NULL,
FechaCotizacion datetime NOT NULL,
MontoCambio MONEY NOT NULL,
MontoIVA MONEY,
MontoGravado MONEY,
MontoExento MONEY,
Estado CHAR(1) NOT NULL, CHECK (Estado = 'A' OR Estado = 'C'),
CONSTRAINT FK_NroCuenta_NotaDebito FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta),
CONSTRAINT FK_CodAgencia_NotaDebito FOREIGN KEY (CodAgencia) REFERENCES Agencia(CodAgencia),
CONSTRAINT FK_Moneda_NotaDebito FOREIGN KEY (CodMoneda) REFERENCES Moneda(CodMoneda)
) ON FGTablas;
GO

CREATE TABLE NotaDeCredito(
NroNotaCredito int PRIMARY KEY,
NroCuenta INT NOT NULL,
CodAgencia SMALLINT NOT NULL,
CodMoneda SMALLINT NOT NULL,
Concepto VARCHAR(255) NOT NULL,
FechaCotizacion datetime NOT NULL,
MontoCambio MONEY NOT NULL,
MontoIVA MONEY,
MontoGravado MONEY,
MontoExento MONEY,
Estado CHAR(1) NOT NULL, CHECK (Estado = 'A' OR Estado = 'C'),
CONSTRAINT FK_NroCuenta_NotaCredito FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta),
CONSTRAINT FK_CodAgencia_NotaCredito FOREIGN KEY (CodAgencia) REFERENCES Agencia(CodAgencia),
CONSTRAINT FK_Moneda_NotaCredito FOREIGN KEY (CodMoneda) REFERENCES Moneda(CodMoneda)
) ON FGTablas;
GO



create table Compra(
       NroCompra INT PRIMARY KEY IDENTITY(1,1),
       CodProveedor INT NOT NULL,
       NroFacturaProveedor INT,
       CodAgencia SMALLINT NOT NULL,
       CodDeposito SMALLINT NOT NULL,
       CodMoneda SMALLINT NOT NULL,
       FechaCotizacion DATETIME NOT NULL,
       MontoCambio MONEY NOT NULL,
       FechaPedido DATETIME NOT NULL,
       FechaRecepcion DATETIME,
       Plazo INT NOT NULL,
       Estado CHAR(1) NOT NULL,
       MontoCostoDolares MONEY ,
       MontoCostoGuaranies MONEY,

       CONSTRAINT FK_PROV_COD_PROV FOREIGN KEY (CodProveedor) REFERENCES Proveedor(CodProveedor),
       CONSTRAINT FK_COD_AGEN_DEPOS FOREIGN KEY (CodAgencia, CodDeposito) REFERENCES AgenciaDeposito(CodAgencia, CodDeposito),      
       CONSTRAINT FK_COD_MON_FECHA_COTI FOREIGN KEY (CodMoneda , FechaCotizacion) REFERENCES                                                         Cotizacion(CodMoneda , FechaCotizacion), 
       CONSTRAINT CHK_ESTADO2 CHEcK(Estado in('A','C')  )     
 
) on FGTablas;
go


/*Tabla Compra*/

create table Transferencia(
       NroTransferencia INT constraint pk_Transferencia_NroTransferencia PRIMARY KEY IDENTITY(1,1),
       NroNotaEnvio INT,
       CodAgenciaSalida SMALLINT NOT NULL,
       CodDepositoSalida SMALLINT NOT NULL,
       CodAgenciaEntrada SMALLINT NOT NULL,
       CodDepositoEntrada SMALLINT NOT NULL,
       FechaTransferencia DATETIME NOT NULL,
       EstadoSalida CHAR(1) NOT NULL,
       EstadoEntrada CHAR(1) NOT NULL,

       CONSTRAINT FK_COD_AGEN_DEPOS_SALIDA FOREIGN KEY (CodAgenciaSalida, CodDepositoSalida) REFERENCES           AgenciaDeposito(CodAgencia, CodDeposito),      
       CONSTRAINT FK_COD_AGEN_DEPOS_ENTRADA FOREIGN KEY (CodAgenciaEntrada, CodDepositoEntrada)                         REFERENCES  AgenciaDeposito(CodAgencia, CodDeposito), 
       CONSTRAINT CHK_ESTADO_SALIDA CHEcK(EstadoSalida in('A','C')),
       CONSTRAINT CHK_ESTADO_ENTRADA CHEcK(EstadoEntrada in('A','C'))        
 
) on FGTablas;
go





/*Tabla DetalleNotaDeCredito */
CREATE TABLE DetalleNotaDeCredito (
NroNotaCredito INT,
NroFactura INT,
NroArticulo INT,
CodRegimen INT,
PorcentajeIVA REAL,
MontoTotal MONEY,
MontoIVA MONEY,
MontoGravado MONEY,
MontoExento MONEY,
PRIMARY KEY (NroNotaCredito, NroFactura, NroArticulo),
CONSTRAINT FK_NroNotaCredito FOREIGN KEY (NroNotaCredito) REFERENCES NotaDeCredito(NroNotaCredito),
CONSTRAINT FK_NroFactura111 FOREIGN KEY (NroFactura) REFERENCES Factura(NroFactura),
CONSTRAINT FK_NroArticulo FOREIGN KEY (NroArticulo) REFERENCES Articulo(NroArticulo),
CONSTRAINT FK_CodRegimen FOREIGN KEY (CodRegimen) REFERENCES Regimen(CodRegimen)
)on FGTablas

GO
/*Tabla DetalleNotaDeDebito */

CREATE TABLE DetalleNotaDeDebito (
NroNotaDebito INT,
NroFactura INT,
NroArticulo INT,
CodRegimen INT,
PorcentajeIVA REAL,
MontoTotal MONEY,
MontoIVA MONEY,
MontoGravado MONEY,
MontoExento MONEY,
PRIMARY KEY (NroNotaDebito, NroFactura, NroArticulo),
CONSTRAINT FK_NroNotaDebito FOREIGN KEY (NroNotaDebito) REFERENCES NotaDeDebito(NroNotaDebito),
CONSTRAINT FK_NroFactura3 FOREIGN KEY (NroFactura) REFERENCES Factura(NroFactura),
CONSTRAINT FK_NroArticulo01 FOREIGN KEY (NroArticulo) REFERENCES Articulo(NroArticulo),
CONSTRAINT FK_CodRegimen00 FOREIGN KEY (CodRegimen) REFERENCES Regimen(CodRegimen)
)on FGTablas
GO



/*Tabla DetalleFactura */
CREATE TABLE DetalleFactura (
NroFactura int,
CodAgencia smallint,
CodDeposito smallint,
NroArticulo int,
FechaVencto datetime,
CostoDolares real,
CostoGuaranies real,
PrecioDolares money not null,
PrecioNeto money,
CodRegimen int,
PorcentajeIVA real,
Cantidad float not null,
MontoTotal money,
MontoIVA money,
MontoNetoIVA money,
PRIMARY KEY (NroFactura, CodAgencia, CodDeposito, NroArticulo, FechaVencto),
CONSTRAINT FK_DetalleFacturaNroFactura FOREIGN KEY (NroFactura) REFERENCES Factura(NroFactura),
CONSTRAINT FK_DetalleFacturaCodAgencia FOREIGN KEY (CodAgencia) REFERENCES Agencia(CodAgencia),
CONSTRAINT FK_DetalleFacturaCodRegimen FOREIGN KEY (CodRegimen) REFERENCES Regimen(CodRegimen),
)on FGTablas;
GO



/* Crear tabla DetalleCompra y DetalleTransferencia*/

create table DetalleCompra(
    NroCompra int,
    CodAgencia smallint, 
    CodDeposito smallint,
    NroArticulo int, 
    FechaVencto date,
    CostoDolaresAnterior real,
    CostoGuaraniesAnterior real, 
    CostoDolares real,
    CostoGuaranies real,
    CodRegimen int,
    Cantidad float not null,
    MontoCostoDolares money,
    MontoCostoGuaranies money,

    primary key(NroCompra,CodAgencia, CodDeposito, NroArticulo, FechaVencto),
    CONSTRAINT FK_Compra_NroCompra FOREIGN KEY (NroCompra) REFERENCES Compra(NroCompra),
    CONSTRAINT FK_AgenciaDepositoArticulo FOREIGN KEY (CodAgencia,CodDeposito, NroArticulo, FechaVencto) REFERENCES AgenciaDepositoArticulo(CodAgencia,CodDeposito, NroArticulo, FechaVencto),
    CONSTRAINT FK_Regimen_CodRegimen FOREIGN KEY (CodRegimen) REFERENCES Regimen(CodRegimen),
)on FGTablas;
go

create table DetalleTransferencia(
    NroTransferencia int,
    CodAgencia smallint,
    CodDeposito smallint,
    NroArticulo int,
    FechaVencto date, 
    CostoDolares real,
    CostoGuaranies real,
    Cantidad float not null,

    primary key(NroTransferencia,CodAgencia, CodDeposito, NroArticulo, FechaVencto),
    CONSTRAINT FK_Transferencia_NroTransferencia FOREIGN KEY (NroTransferencia) REFERENCES Transferencia(NroTransferencia),
    CONSTRAINT FK_DetalleTransferenciaAgenciaDepositoArticulo FOREIGN KEY (CodAgencia,CodDeposito, NroArticulo, FechaVencto) REFERENCES AgenciaDepositoArticulo(CodAgencia,CodDeposito, NroArticulo, FechaVencto)
) on FGTablas;
go






--DETALLE AJUSTE

CREATE TABLE DetalleAjuste (

    NroAjuste int,

    CodAgencia SMALLINT,

    CodDeposito SMALLINT,

    NroArticulo INT,

    FechaVencto date,

    CodTipoAjuste SMALLINT NOT NULL,

    CostoDolares REAL,

    CostoGuaranies REAL,

    Cantidad FLOAT NOT NULL,
    PRIMARY KEY (NroAjuste, CodAgencia, CodDeposito, NroArticulo, FechaVencto),

    CONSTRAINT FK_TipoAjuste_NroAjuste FOREIGN KEY (NroAjuste) REFERENCES Ajuste ,

    CONSTRAINT FK_Agencia_CodAgencia FOREIGN KEY (CodAgencia,CodDeposito, NroArticulo, FechaVencto) REFERENCES AgenciaDepositoArticulo,

    CONSTRAINT FK_Deposito_CodDeposito FOREIGN KEY (CodTipoAjuste) REFERENCES TipoAjuste 

);





/*
6. Crear 4 índices de las fks que existen poniéndoles nombre con configuración de estadísticas, bloqueos de filas, 
borrar si existe.
*/

CREATE INDEX IDX_FK_NroFactura ON DetalleFactura (NroFactura)
WITH (ALLOW_ROW_LOCKS = ON,

      STATISTICS_NORECOMPUTE = On
      -- ,drop_existing = on
      )

ON [FGIndice];


CREATE INDEX IDX_FK_CodAgencia ON DetalleFactura (CodAgencia)

WITH (ALLOW_ROW_LOCKS = ON,

      STATISTICS_NORECOMPUTE = ON)

ON [FGIndice];


CREATE INDEX IDX_FK_CodRegimen ON DetalleFactura (CodRegimen)

WITH (ALLOW_ROW_LOCKS = ON,

      STATISTICS_NORECOMPUTE = ON)

ON [FGIndice];


CREATE INDEX IDX_FK_CodVendedor ON Vendedor (CodVendedor)

WITH (ALLOW_ROW_LOCKS = ON,

      STATISTICS_NORECOMPUTE = ON)

ON [FGIndice];




CREATE INDEX IDX_MarcaLineaArticulo on Articulo (CodMarca, CodLinea)

WITH (-- DROP_EXISTING = ON,

STATISTICS_NORECOMPUTE = OFF,

     ALLOW_ROW_LOCKS = ON)

ON [FGIndice];

-- 2. articulo en agencia deposito

CREATE INDEX IDX_AgenciaDepositoArticulo on AgenciaDepositoArticulo (NroArticulo)

WITH (-- DROP_EXISTING = ON,

STATISTICS_NORECOMPUTE = OFF,

     ALLOW_ROW_LOCKS = ON)

ON FGIndice;

-- 3. pais en proveedor

CREATE INDEX IDX_Pais on Proveedor (CodPais)

WITH (-- DROP_EXISTING = ON,

STATISTICS_NORECOMPUTE = OFF,

     ALLOW_ROW_LOCKS = ON)

ON FGIndice;

-- 4. agencia/deposito en ajuste

CREATE INDEX IDX_AgenciaDepositoAjuste on Ajuste (CodAgencia, CodDeposito)

WITH (-- DROP_EXISTING = ON,

STATISTICS_NORECOMPUTE = OFF,

     ALLOW_ROW_LOCKS = ON)

ON FGIndice;



--1.CodDeposito en Factura
CREATE INDEX IDX_FACTURA_COD_DEPOSITO_FK ON Factura(CodDeposito)
WITH (
-- DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
)ON FGIndice;
GO

--2. CodMoneda en Factura
CREATE INDEX IDX_FACTURA_COD_MONEDA_FK ON Factura(CodMoneda)
WITH (

STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
)ON FGIndice;
GO

--3. CodVendedor en Cuenta
CREATE INDEX IDX_CUENTA_COD_VENDEDOR_FK ON Cuenta(CodVendedor)
WITH (

STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
)ON FGIndice;
GO

--4. CodRamo en Cuenta
CREATE INDEX IDX_CUENTA_COD_RAMO_FK ON Cuenta(CodRamo)
WITH (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
)ON FGIndice;
GO





--(OBS: Pequeña corrección por error de sintaxis)
--6. Crear 4 índices de las fks que existen poniéndoles nombre con configuración de estadísticas, bloqueos de filas, borrar si existe.

--1.CodDeposito en Factura
CREATE INDEX IDX_FACTURA_COD_DEPOSITO_FK ON Factura(CodDeposito)
WITH (
DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);
GO

--2. CodMoneda en Factura
CREATE INDEX IDX_FACTURA_COD_MONEDA_FK ON Factura(CodMoneda)
WITH (
DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);
GO

--3. CodVendedor en Cuenta
CREATE INDEX IDX_CUENTA_COD_VENDEDOR_FK ON Cuenta(CodVendedor)
WITH (
DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
)
GO

--4. CodRamo en Cuenta
CREATE INDEX IDX_CUENTA_COD_RAMO_FK ON Cuenta(CodRamo)
WITH (
DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);
GO









--6. Crear 4 índices de las fks que existen poniéndoles nombre con configuración de estadísticas, bloqueos de filas, borrar si existe.

--1.CodAgencia en Recibo
CREATE INDEX IDX_RECIBO_COD_AGENCIA_FK ON Recibo(CodAgencia)
WITH (

STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);
GO

--2. CodCobrador en Recibo
CREATE INDEX IDX_RECIBO_COD_COBRADOR_FK ON Recibo(CodCobrador)
WITH (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);
GO

--3. NroCuenta en Recibo
CREATE INDEX IDX_RECIBO_NRO_CUENTA_FK ON Recibo(NroCuenta)
WITH (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);
GO

--4. CodMoneda en NotaDeDebito
CREATE INDEX IDX_NOTA_DE_DEBITO_COD_MONEDA_FK ON NotaDeDebito(CodMoneda)
WITH (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);
GO








/*1. CODLINEA ARTICULO*/
create index IDX_Articulo_CodLinea_FK on Articulo(CodLinea)
with (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);

/*2.CODMARCA ARTICULO*/
create index IDX_Articulo_CodMarca_FK on Articulo(CodMarca)
with (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);

/*3. CODPROVEEDOR ARTICULO*/
create index IDX_Articulo_CodProveedor_FK on Articulo(CodProveedor)
--include(DesArticulo, CodigoBarra)
with (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);


/*4.CODPAIS PROVEEDOR*/
create index IDX_PROVEEDOR_CODPAIS_FK  on PROVEEDOR(CODPAIS)
with (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);







--4. Crear 4 índices de las fks que existen poniéndoles nombre con configuración de estadísticas, bloqueos de filas, borrar si existe.
--1. CodMoneda Cotizacion
CREATE INDEX IDX_COTIZACION_CODMONEDA_FK ON Cotizacion(CodMoneda)
WITH (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);

--2.NroCuenta Factura
CREATE INDEX IDX_FACTURA_NROCUENTA_FK ON Factura(NroCuenta)
WITH (
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);

--3. CodVendedor Factura
CREATE INDEX IDX_FACTURA_CODVENDEDOR_FK ON Factura(CodVendedor)
WITH (

STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);


--4.CodAgencia Factura
CREATE INDEX IDX_FACTURA_CODAGENCIA_FK ON Factura(CodAgencia)
WITH (

STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON
);










/* Índice en la columna CodMoneda de la tabla Cotizacion para acelerar búsquedas por moneda. */
CREATE INDEX IDX_Cotizacion_CodMoneda
ON Cotizacion (CodMoneda)
WITH (
-- DROP_EXISTING = ON, /* Reemplaza el índice existente si es necesario. */
STATISTICS_NORECOMPUTE = ON, /* Evita la recomputación automática de estadísticas. */
ALLOW_ROW_LOCKS = ON, /* Permite bloqueos de fila. */
ALLOW_PAGE_LOCKS = ON /* Permite bloqueos de página. */
);

/* Índice en la columna DesArticulo de la tabla Articulo para acelerar búsquedas por descripción de artículo. */
CREATE INDEX IDX_Articulo_DesArticulo
ON Articulo (DesArticulo)
WITH (
-- DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
);

/* Índice en la columna RazonSocial de la tabla Proveedor para acelerar búsquedas por razón social. */
CREATE INDEX IDX_Proveedor_RazonSocial
ON Proveedor (RazonSocial)
WITH (
-- DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
);

/* Índice en la columna DesPais de la tabla Pais para acelerar búsquedas por nombre de país. */
CREATE INDEX IDX_Pais_DesPais
ON Pais (DesPais)
WITH (
-- DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
);










CREATE INDEX IDX_FK_AgenciaDeposito_Agencia
ON AgenciaDeposito (CodAgencia)
WITH (
-- DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
);
GO

CREATE INDEX IDX_FK_AgenciaDeposito_Deposito
ON AgenciaDeposito (CodDeposito)
WITH (
-- DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
);
GO

CREATE INDEX IDX_FK_Cotizacion_CodMoneda
ON Cotizacion (CodMoneda)
WITH (
-- DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
);
GO
CREATE INDEX IDX_FK_Factura_NroCuenta
ON Factura (NroCuenta)
WITH (
-- DROP_EXISTING = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON
);
GO



create index IDX_ADA_NroArticulo_FK on AgenciaDepositoArticulo(NroArticulo)
with(
-- drop_existing = on,
statistics_norecompute = on,
allow_row_locks = on
);






/*
8.     Crear un secuenciador, definiendo todas sus propiedades a criterio. Establecer ese secuenciador como valor por defecto para la pk de las tablas recibo, cotización)
*/

CREATE SEQUENCE Secuenciador
AS INT
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO CYCLE;
go


ALTER TABLE Recibo
ADD CONSTRAINT DF_Recibo_NroRecibo DEFAULT NEXT VALUE FOR Secuenciador FOR NroRecibo;



ALTER TABLE Moneda
ADD CONSTRAINT DF_moneda_CodMoneda DEFAULT NEXT VALUE FOR Secuenciador FOR CodMoneda;





/*
9.     Para la table transferencia, cambiar de identity a un valor de un secuenciador por defecto. Crearlo previamente.
*/
CREATE SEQUENCE SecuenciadorTransferencia
AS INT
START WITH 1
INCREMENT BY 1
MINVALUE 1
NO CYCLE;

/* Modificar la tabla Transferencia para utilizar el secuenciador por defecto */

ALTER TABLE DetalleTransferencia
DROP CONSTRAINT FK_Transferencia_NroTransferencia;


ALTER TABLE Transferencia
DROP CONSTRAINT pk_Transferencia_NroTransferencia;

ALTER TABLE Transferencia
DROP COLUMN NroTransferencia;

ALTER TABLE Transferencia
ADD NroTransferencia INT not null DEFAULT NEXT VALUE FOR SecuenciadorTransferencia;

ALTER TABLE Transferencia
ADD CONSTRAINT pk_Transferencia_NroTransferencia PRIMARY KEY (NroTransferencia);

ALTER TABLE DetalleTransferencia
ADD CONSTRAINT FK_Transferencia_NroTransferencia foreign KEY (NroTransferencia) references Transferencia;





alter table NotaDeCredito drop constraint FK_NroCuenta_NotaCredito;
alter table NotaDeDebito drop constraint FK_NroCuenta_NotaDebito;
alter table Recibo drop constraint FK_NroCuentaRecibo;
alter table Factura drop constraint FK_NroCuenta2;
alter table CtaCte drop constraint FK_NroCuenta;



alter table Cuenta drop constraint pk_Cuenta_NroCuenta;
alter table Cuenta drop column NroCuenta;

ALTER TABLE Cuenta
ADD NroCuenta INT not null IDENTITY(1,1);

ALTER TABLE Cuenta
ADD CONSTRAINT pk_Cuenta_NroCuenta PRIMARY KEY (NroCuenta);

alter table NotaDeCredito add
CONSTRAINT FK_NroCuenta_NotaCredito FOREIGN KEY (NroCuenta) REFERENCES Cuenta;
alter table NotaDeDebito add
CONSTRAINT FK_NroCuenta_NotaDebito FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta);
alter table Recibo add
CONSTRAINT FK_NroCuentaRecibo FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta);

alter table Factura add
CONSTRAINT FK_NroCuenta2 FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta);


alter table CtaCte add
CONSTRAINT FK_NroCuenta FOREIGN KEY (NroCuenta) REFERENCES Cuenta(NroCuenta);


