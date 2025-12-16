USE COLOCAR_SU_BASE_DE_DATOS
CREATE TABLE Pais (
    PaisCod SMALLINT NOT NULL,
    Nombre  VARCHAR(30) NOT NULL,
    Gentilicio VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Ciudad (
    CiudadCod   INT NOT NULL,
    Denominacion VARCHAR(50) NOT NULL,
    PaisCod     SMALLINT NOT NULL
);
GO

CREATE TABLE Hotel (
    HotelNro          INT NOT NULL,
    Denominacion      VARCHAR(50) NOT NULL,
    CiudadCod         INT NOT NULL,
    Direccion         VARCHAR(50) NOT NULL,
    Telefono          VARCHAR(15) NOT NULL,
    Fax               VARCHAR(15) NOT NULL,
    E_Mail            VARCHAR(50) NOT NULL,
    FechaHabilitacion DATETIME NOT NULL
);
GO

CREATE TABLE Piso (
    HotelNro INT NOT NULL,
    PisoNro  SMALLINT NOT NULL
);
GO

CREATE TABLE Categoria (
    CategoriaCod SMALLINT NOT NULL,
    Descripcion  CHAR(30) NOT NULL,
    Tarifa       MONEY NOT NULL
);
GO

CREATE TABLE Temporada (
    TemporadaCod SMALLINT NOT NULL,
    PaisCod      SMALLINT NOT NULL,
    Nombre       VARCHAR(30) NOT NULL,
    FechaInicio  DATETIME NOT NULL,
    FechaFin     DATETIME NOT NULL
);
GO

CREATE TABLE Cliente (
    ClienteNro   INT NOT NULL,
    Denominacion VARCHAR(60) NOT NULL,
    PaisCod      SMALLINT NOT NULL,
    Domicilio    VARCHAR(60) NOT NULL,
    Telefono     VARCHAR(10) NULL,
    Fax          VARCHAR(10) NULL,
    Saldo        MONEY NOT NULL
);
GO

CREATE TABLE Huesped (
    HuespedNro      INT NOT NULL,
    Nombre          VARCHAR(50) NOT NULL,
    Apellido        VARCHAR(50) NOT NULL,
    Direccion       VARCHAR(50) NOT NULL,
    PaisCod         SMALLINT NOT NULL,
    FechaNacimiento DATETIME NOT NULL,
    CiudadCod       INT NOT NULL,
    EstadoCivil     CHAR(3) NOT NULL,
    Domicilio       VARCHAR(60) NULL,
    Profesion       VARCHAR(50) NULL,
    DocumentoNro    VARCHAR(10) NULL,
    PasaporteNro    VARCHAR(10) NULL,
    TarjetaNro      VARCHAR(10) NULL,
    ClienteNro      INT NOT NULL
);
GO

CREATE TABLE Habitacion (
    HotelNro       INT NOT NULL,
    PisoNro        SMALLINT NOT NULL,
    HabitacionNro  SMALLINT NOT NULL,
    InternoNro     SMALLINT NOT NULL,
    CategoriaCod   SMALLINT NOT NULL
);
GO

CREATE TABLE Tarifa (
    CategoriaCod  SMALLINT NOT NULL,
    TemporadaCod  SMALLINT NOT NULL,
    Tarifa        MONEY NOT NULL
);
GO

CREATE TABLE HabitacionHistorico (
    HotelNro      INT NOT NULL,
    PisoNro       SMALLINT NOT NULL,
    HabitacionNro SMALLINT NOT NULL,
    Fecha         DATETIME NOT NULL,
    CategoriaCod  SMALLINT NOT NULL
);
GO

CREATE TABLE Hospedaje (
    HospedajeNro  INT NOT NULL,
    HuespedNro    INT NOT NULL,
    HotelNro      INT NOT NULL,
    PisoNro       SMALLINT NULL,
    HabitacionNro SMALLINT NULL,
    FechaInicio   DATETIME NOT NULL,
    CantidadDias  INT NOT NULL,
    ClienteNro    INT NOT NULL,
    TemporadaCod  SMALLINT NOT NULL,
    FechaFin      DATETIME NULL,
    MontoTotal    MONEY NOT NULL,
    MontoCancelado MONEY NOT NULL
);
GO

CREATE TABLE HospedajeHistorico (
    HospedajeNro  INT NOT NULL,
    HotelNro      INT NOT NULL,
    PisoNro       SMALLINT NOT NULL,
    HabitacionNro SMALLINT NOT NULL,
    FechaHora     DATETIME NOT NULL
);
GO

CREATE TABLE Acompanante (
    HospedajeNro INT NOT NULL,
    HuespedNro   INT NOT NULL
);
GO

CREATE TABLE Reservacion (
    HotelNro      INT NOT NULL,
    PisoNro       SMALLINT NOT NULL,
    HabitacionNro SMALLINT NOT NULL,
    FechaInicio   DATETIME NOT NULL,
    FechaFin      DATETIME NOT NULL,
    HuespedNro    INT NOT NULL,
    HospedajeNro  INT NULL
);
GO

CREATE TABLE Llamada (
    HospedajeNro INT NOT NULL,
    TiempoInicio DATETIME NOT NULL,
    TiempoFin    DATETIME NOT NULL,
    CostoLlamada MONEY NOT NULL
);
GO

CREATE TABLE Liquidacion (
    HospedajeNro INT NOT NULL,
    DetalleNro   SMALLINT IDENTITY(1,1) NOT NULL,
    Cantidad     INT NOT NULL,
    Concepto     VARCHAR(60) NOT NULL,
    Importe      MONEY NOT NULL
);
GO

CREATE TABLE TipoComponente (
    TipoCompCod SMALLINT NOT NULL,
    Descripcion VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Componente (
    ComponenteNro INT NOT NULL,
    Descripcion   VARCHAR(30) NOT NULL,
    ValorCompra   MONEY NOT NULL,
    HotelNro      INT NULL,
    PisoNro       SMALLINT NULL,
    HabitacionNro SMALLINT NULL,
    TipoCompCod   SMALLINT NOT NULL
);
GO

CREATE TABLE TipoAlimento (
    TipoAlimentoCod SMALLINT NOT NULL,
    Descripcion     VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Alimento (
    AlimentoNro     INT NOT NULL,
    Descripcion     VARCHAR(40) NOT NULL,
    TipoAlimentoCod SMALLINT NOT NULL,
    PorcImpuesto    FLOAT NOT NULL
);
GO

CREATE TABLE Ingrediente (
    AlimentoNro    INT NOT NULL,
    IngredienteNro INT NOT NULL,
    Cantidad       FLOAT NOT NULL
);
GO

CREATE TABLE HotelAlimento (
    HotelNro    INT NOT NULL,
    AlimentoNro INT NOT NULL,
    Precio      MONEY NOT NULL
);
GO

CREATE TABLE Deposito (
    HotelNro    INT NOT NULL,
    PisoNro     SMALLINT NOT NULL,
    DepositoNro SMALLINT NOT NULL,
    Descripcion VARCHAR(40) NOT NULL
);
GO

CREATE TABLE DepositoAlimento (
    HotelNro    INT NOT NULL,
    PisoNro     SMALLINT NOT NULL,
    DepositoNro SMALLINT NOT NULL,
    AlimentoNro INT NOT NULL,
    Existencia  FLOAT NOT NULL,
    Costo       FLOAT NOT NULL
);
GO

CREATE TABLE Consumo (
    ConsumoNro   INT NOT NULL,
    HospedajeNro INT NOT NULL,
    Fecha        DATETIME NOT NULL,
    HotelNro     INT NOT NULL,
    PisoNro      SMALLINT NOT NULL,
    DepositoNro  SMALLINT NOT NULL,
    MontoTotal   MONEY NOT NULL,
    Estado       CHAR(1) NOT NULL
);
GO

CREATE TABLE DetalleConsumo (
    ConsumoNro  INT NOT NULL,
    AlimentoNro INT NOT NULL,
    Cantidad    FLOAT NOT NULL,
    Precio      MONEY NOT NULL,
    Costo       MONEY NOT NULL,
    PorcImpuesto FLOAT NOT NULL
);
GO

CREATE TABLE Proveedor (
    ProveedorNro INT NOT NULL,
    RazonSocial  VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Compra (
    CompraNro    INT NOT NULL,
    FacturaNro   INT NOT NULL,
    ProveedorNro INT NOT NULL,
    HotelNro     INT NOT NULL,
    PisoNro      SMALLINT NOT NULL,
    DepositoNro  SMALLINT NOT NULL,
    MontoTotal   MONEY NOT NULL,
    Estado       CHAR(1) NOT NULL
);
GO

CREATE TABLE DetalleCompra (
    CompraNro   INT NOT NULL,
    AlimentoNro INT NOT NULL,
    Cantidad    FLOAT NOT NULL,
    Costo       FLOAT NOT NULL
);
GO

CREATE TABLE Transferencia (
    TransferenciaNro INT NOT NULL,
    Fecha            DATETIME NOT NULL,
    HotelNroOrigen   INT NOT NULL,
    PisoNroOrigen    SMALLINT NOT NULL,
    DepositoNroOrigen SMALLINT NOT NULL,
    HotelNroDestino   INT NOT NULL,
    PisoNroDestino    SMALLINT NOT NULL,
    DepositoNroDestino SMALLINT NOT NULL,
    Estado           CHAR(1) NOT NULL
);
GO

CREATE TABLE DetalleTransferencia (
    TransferenciaNro INT NOT NULL,
    AlimentoNro      INT NOT NULL,
    Cantidad         FLOAT NOT NULL,
    Costo            FLOAT NOT NULL
);
GO

CREATE TABLE Personal (
    PersonalNro   INT NOT NULL,
    Nombre        VARCHAR(40) NOT NULL,
    Apellido      VARCHAR(40) NOT NULL,
    FechaNacimiento DATETIME NOT NULL,
    FechaIngreso  DATETIME NOT NULL,
    JefeNro       INT NULL,
    HotelNro      INT NOT NULL
);
GO

CREATE TABLE PersonalHorario (
    PersonalNro INT NOT NULL,
    DiaSemana   SMALLINT NOT NULL,
    HoraEntrada DATETIME NOT NULL,
    HoraSalida  DATETIME NOT NULL
);
GO
