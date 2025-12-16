use master



SELECT 
    DB_NAME(database_id) AS DatabaseName, 
    type_desc AS FileType,
    name AS LogicalName,
    physical_name AS PhysicalPath
FROM sys.master_files;



-- crear db con filestream
CREATE DATABASE ClasesFacturacion
ON PRIMARY 
    (NAME = 'ArchivoPrincipal',
     FILENAME = '/var/opt/mssql/data/ArchivoPrincipal.mdf',
     SIZE = 4MB,
     MAXSIZE = 100MB,
     FILEGROWTH = 1MB),
FILEGROUP Tablas -- default
    (NAME = 'ArchivoTablas',
     FILENAME = '/var/opt/mssql/data/ArchivoTablas.ndf',
     SIZE = 2MB,
     MAXSIZE = 50MB,
     FILEGROWTH = 1MB),
FILEGROUP Indices
    (NAME = 'ArchivoIndices',
     FILENAME = '/var/opt/mssql/data/ArchivoIndices.ndf',
     SIZE = 2MB,
     MAXSIZE = 50MB,
     FILEGROWTH = 1MB)
/*,FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM
    (NAME = 'ArchivoImagenes',
     FILENAME = '/var/opt/mssql/data/FileStreamData',
     MAXSIZE = 100MB)*/
LOG ON 
    (NAME = 'ArchivoLog1',
     FILENAME = '/var/opt/mssql/data/ArchivoLog1.ldf',
     SIZE = 2MB,
     MAXSIZE = 25MB,
     FILEGROWTH = 1MB),
    (NAME = 'ArchivoLog2',
     FILENAME = '/var/opt/mssql/data/ArchivoLog2.ldf',
     SIZE = 2MB,
     MAXSIZE = 25MB,
     FILEGROWTH = 1MB);


-- cambiar nombre logico data
ALTER DATABASE ClasesFacturacion
MODIFY FILE (NAME = 'ArchivoIndices', NEWNAME = 'ArchivoDeIndices');


-- cambiar nombre fisico file
ALTER DATABASE ClasesFacturacion SET OFFLINE WITH ROLLBACK IMMEDIATE;

-- cambiaar ubicacion o nombre de file SO
ALTER DATABASE ClasesFacturacion
MODIFY FILE (NAME = 'ArchivoDeIndices', FILENAME = '/var/opt/mssql/data/ArchivoDeIndices.ndf');

-- online
ALTER DATABASE ClasesFacturacion SET ONLINE;


-- cambiar nombre DB
ALTER DATABASE ClasesFacturacion
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

ALTER DATABASE ClasesFacturacion
MODIFY NAME = ClasesFacturacionNuevo;

ALTER DATABASE ClasesFacturacionNuevo
SET MULTI_USER;



-- filegroup default
ALTER DATABASE ClasesFacturacionNuevo
MODIFY FILEGROUP Tablas DEFAULT;

ALTER DATABASE ClasesFacturacionNuevo
MODIFY FILEGROUP [PRIMARY] DEFAULT;


-- Crear el nuevo filegroup
ALTER DATABASE ClasesFacturacionNuevo
ADD FILEGROUP OtroFilegroup;

ALTER DATABASE ClasesFacturacionNuevo
ADD FILE (
    NAME = 'OtroFilegroup',
    FILENAME = '/var/opt/mssql/data/OtroFilegroup.ndf',
    SIZE = 100MB, -- Tamaño inicial del archivo
    MAXSIZE = UNLIMITED, -- Tamaño máximo que puede alcanzar el archivo
    FILEGROWTH = 10MB -- En cuánto crecerá automáticamente el archivo cuando se llene
) TO FILEGROUP OtroFilegroup;


ALTER DATABASE ClasesFacturacionNuevo
MODIFY FILEGROUP OtroFilegroup DEFAULT;



use ClasesFacturacionNuevo;



-- Crear la tabla en el filegroup 'Tablas' pero con la clave primaria en el filegroup 'Indices'
CREATE TABLE Personas (
    ID INT CONSTRAINT PK_Personas_ID PRIMARY KEY,
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    Documento NVARCHAR(50),
    constraint UQNombreApellido unique (Nombre, Apellido, Documento)
) ON Tablas;


CREATE TABLE Personas (
    ID INT CONSTRAINT PK_Personas_ID PRIMARY KEY ON Tablas
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    Documento NVARCHAR(50),
    constraint UQNombreApellido unique (Nombre, Apellido, Documento)
);


CREATE TABLE Personas (
    ID INT CONSTRAINT PK_Personas_ID PRIMARY KEY nonclustered ON Indices,
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    Documento NVARCHAR(50),
    constraint UQNombreApellido unique (Nombre, Apellido, Documento)
) on Tablas;



-- Crear la tabla en el filegroup 'Tablas' pero con la clave primaria en el filegroup 'Indices'
CREATE TABLE Personas (
    ID INT CONSTRAINT PK_Personas_ID PRIMARY KEY ON Tablas
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    Documento NVARCHAR(50),
    constraint UQNombreApellido unique (Nombre, Apellido, Documento) on Indices
);


-- primera opción
ALTER TABLE Personas
ADD FechaNacimiento DATE;

-- update

ALTER TABLE Personas
modifyt column FechaNacimiento DATE not null;



-- segunda opción
ALTER TABLE Personas
ADD FechaNacimiento DATE not null default '1900-12-31';




ALTER TABLE Personas
ADD Edad AS DATEDIFF(YEAR, FechaNacimiento, GETDATE());


ALTER TABLE Personas
ADD Edad AS DATEDIFF(YEAR, FechaNacimiento, GETDATE()) PERSISTED;


ALTER TABLE Personas
ADD SalarioGuaranies AS SalarioDolares * 7500;



-- se crea en filegroup tablas
CREATE TABLE Ciudad (
    ID INT,
    Nombre NVARCHAR(100),
    Pais NVARCHAR(100)
) ON Tablas;

-- setear not null
ALTER TABLE Ciudad
ALTER COLUMN ID INT NOT NULL;

-- creamos la pk en filegroup correspondiente
ALTER TABLE Ciudad
ADD CONSTRAINT PK_Ciudad_ID PRIMARY KEY (ID) ON Indices;


-- cambiar de filegroup la tabla creada
ALTER TABLE Ciudad
drop PK_Ciudad_ID;

ALTER TABLE Ciudad
ADD CONSTRAINT PK_Ciudad_ID PRIMARY KEY (ID) ON Tablas


go

EXEC sp_rename 'Ciudad', 'Ciudades';

GO

EXEC sp_rename 'Ciudades.PK_Ciudad_ID', 'PK_Ciudades_ID';


EXEC sp_rename 'Ciudades.PK_Ciudad_sdf54sd4f6sd5f4', 'PK_Ciudades_ID';


-- estrucura tabla
SELECT 
COLUMN_NAME, 
DATA_TYPE, 
CHARACTER_MAXIMUM_LENGTH, 
IS_NULLABLE
FROM  INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Personas';

-- pk
SELECT 
OBJECT_NAME(object_id) AS ConstraintName, 
type_desc AS ConstraintType
FROM  sys.check_constraints
WHERE parent_object_id = OBJECT_ID('Personas')

-- constraint
SELECT 
OBJECT_NAME(object_id), 
type_desc
FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('Personas');

-- cambiar nombre de columna
EXEC sp_rename 'Personas.ID', 'NroPersona', 'COLUMN';



create table Paises(
    NroPais int primary key,
    Nombre varchar(100)
) on Tablas;



create table Sexo(
    NroSexo smallint,
    Sexo text

) on Tablas;

create table Titulos(
    ID int PRIMARY KEY nonCLUSTERED ON Indices,
    Descripcion text
) on Tablas;



SELECT 
fg.name filegroup, o.name tabla,
*
FROM sys.filegroups fg
JOIN sys.allocation_units au ON fg.data_space_id = au.data_space_id
JOIN sys.partitions p ON au.container_id = p.partition_id
JOIN sys.objects o ON p.object_id = o.object_id
WHERE o.type = 'U';  -- Solo tablas de usuario


SELECT 
    fg.name AS FileGroupName, 
    OBJECT_NAME(p.object_id) AS ObjectName, 
    CASE 
        WHEN p.index_id = 0 THEN 'Heap'
        WHEN p.index_id = 1 THEN 'Clustered Index'
        ELSE 'Nonclustered Index'
    END AS ObjectType,
    i.name AS IndexName
    --, *
FROM sys.filegroups fg
INNER JOIN sys.allocation_units au ON fg.data_space_id = au.data_space_id
INNER JOIN sys.partitions p ON au.container_id = p.hobt_id
LEFT JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
JOIN sys.objects o ON p.object_id = o.object_id
WHERE -- p.object_id > 100 
 o.type = 'U'
ORDER BY fg.name, OBJECT_NAME(p.object_id), p.index_id;



go


-- schemas
use ClasesFacturacionNuevo;


SELECT CURRENT_USER, ORIGINAL_LOGIN(), USER_NAME(), SCHEMA_NAME();




CREATE LOGIN Test WITH PASSWORD = '_AbC123:';
CREATE USER TestUsuario FOR LOGIN Test;
ALTER SERVER ROLE sysadmin ADD MEMBER Test;

EXECUTE AS user = 'TestUsuario';



CREATE SCHEMA Esquema2 AUTHORIZATION TestUsuario;

-- CREATE SCHEMA Esquema2;



ALTER USER TestUsuario WITH DEFAULT_SCHEMA = Esquema2;


ALTER AUTHORIZATION ON SCHEMA::Esquema2 TO TestUsuario



drop schema Esquema2

ALTER SCHEMA dbo
TRANSFER Esquema2.OtraTablaa;


ALTER SCHEMA DepartamentoVenta
TRANSFER Ventas.Facturacion;


CREATE Table OtraTablaa(
    id int
)





-- lista de schemas
SELECT * FROM sys.schemas;


go 





 /*
Tanto las columnas IDENTITY como las secuencias (SEQUENCE) se utilizan para generar valores únicos para una columna en SQL Server, 
pero existen algunas diferencias importantes entre ambas:

Personalización: las secuencias ofrecen una mayor personalización que las columnas IDENTITY. 
Las secuencias permiten especificar el valor inicial, el incremento, el valor máximo, el valor mínimo y otras opciones. 
Las columnas IDENTITY solo permiten especificar el valor inicial y el incremento.

Flexibilidad: las secuencias ofrecen una mayor flexibilidad que las columnas IDENTITY. 
Las secuencias se pueden utilizar en cualquier tabla y se pueden utilizar para generar valores para varias columnas en una tabla. 
Las columnas IDENTITY solo se pueden utilizar en una columna específica.

Ciclo de vida: las secuencias tienen un ciclo de vida independiente de las tablas, lo que significa que las secuencias se pueden utilizar en varias tablas 
y se pueden reutilizar después de que se elimine una tabla. Las columnas IDENTITY se eliminan junto con la tabla que las contiene.

Performance: las secuencias suelen ser más eficientes en términos de rendimiento que las columnas IDENTITY, 
especialmente en situaciones de alta concurrencia o transacciones masivas.
 */





CREATE SEQUENCE SqSecuenciador
    AS INT -- numeric(12,2), bigint, smallint, float
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 1000
    CYCLE
    CACHE 10;

drop SEQUENCE Test.DecSeq ;

CREATE SEQUENCE Test.DecSeq  
    AS decimal(4,2)   
    START WITH 125  
    INCREMENT BY .22  
    MINVALUE 100  
    MAXVALUE 200  
    CYCLE  
    CACHE 3  
;  


SELECT NEXT VALUE FOR Test.DecSeq;  




CREATE TABLE Tabla (
    ID INT DEFAULT (NEXT VALUE FOR SqSecuenciador) PRIMARY KEY,
    Name NVARCHAR(100)
);







CREATE SEQUENCE Ventas.SqClubSecuenciador
    AS bigint   
    START WITH 1 
    INCREMENT BY 1
; 



CREATE TABLE Club (
    IdClub bigint PRIMARY KEY,
    Nombre VARCHAR(100)
);

ALTER TABLE dbo.Club 
ADD IdClub bigint DEFAULT (NEXT VALUE FOR Ventas.SqClubSecuenciador);




ALTER TABLE dbo.Club 
ADD CONSTRAINT DF_Club_ID
DEFAULT (NEXT VALUE FOR Ventas.SqClubSecuenciador) FOR IdClub;



-- identity
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);


SET IDENTITY_INSERT Employees ON;

INSERT INTO Employees (EmployeeID, FirstName, LastName) VALUES (10, 'Jane', 'Smith');

SET IDENTITY_INSERT Employees OFF;



INSERT INTO Employees (FirstName, LastName) VALUES ('Anna', 'White');
SELECT SCOPE_IDENTITY() AS LastInsertedID;



SELECT IDENT_CURRENT('Employees') AS CurrentIdentityValue;


DBCC CHECKIDENT('Employees', RESEED, 22);



-- Deshabilitar la restricción
ALTER TABLE MiTabla
NOCHECK CONSTRAINT FK_MiTabla_OtraTabla;



alter table foreign_table2 check constraint all;








/*
solo lectura
lectura escritura
*/


ALTER DATABASE Clase507
SET READ_ONLY;

-- lectura escritura
ALTER DATABASE Clase507
SET READ_WRITE;















/*indices*/
create index IDXCiudades on Ciudades(NroPais);



create index IDX_ArticulosMarcaProveedor on Articulos(CodMarca ,CodProveedor);

create index IDXAtletasNroPaisNroSexo on Atletas(NroPais, NroSexo);

create index IDXAtletasNroPais on Atletas(NroPais);


create unique index IDX_ArticulosCodigoBarra on Articulos(CodigoBarra);



Fillfactor = 80,
PAD_INDEX = ON,
drop_existing = on,
ignore_dup_key = OFF,
Data_compression = page,
SORT_IN_TEMPDB = ON,
STATISTICS_NORECOMPUTE = ON,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON,
ONLINE = ON, -- solo nonclustered
MAXDOP = 4,
RESUMABLE = ON,
MAX_DURATION = 30,
OPTIMIZE_FOR_SEQUENTIAL_KEY = ON -- solo indices clustered


/*
Fillfactor
Fillfactor es una opción de configuración que determina cuánto espacio se debe dejar en cada 
página de índice durante la creación del índice. Un Fillfactor del 80% indica que cada página   
de índice estará llena en un 80%, dejando un 20% de espacio libre para futuras inserciones 
o actualizaciones.


PAD_INDEX: Controla si se aplica el valor de FILLFACTOR al último nivel de índice intermedio. Los valores posibles son ON y OFF (valor predeterminado).

drop_existing = ON: Esta opción indica que si ya existe un índice con el mismo nombre, se eliminará antes de crear el nuevo índice.

ignore_dup_key = OFF: Esta opción especifica si se deben generar errores cuando se intenta insertar un valor duplicado en la columna indexada. 
Si se establece en OFF, se generará un error si se intenta insertar un valor duplicado. Si se establece en ON, la inserción simplemente será ignorada.

Data_compression = PAGE: Esta opción indica que se utilizará la compresión de datos a nivel de página para el índice. La compresión de datos puede ayudar 
a reducir el tamaño de almacenamiento del índice y mejorar el rendimiento de las consultas, pero puede aumentar el uso de la CPU.

SORT_IN_TEMPDB: Controla si se realiza la clasificación de datos en la base de datos tempdb durante la creación del índice. Los valores posibles son ON y OFF 
(valor predeterminado).

STATISTICS_NORECOMPUTE: Controla si se deben deshabilitar las actualizaciones automáticas de estadísticas para el índice. Los valores posibles 
son ON y OFF (valor predeterminado).

ALLOW_ROW_LOCKS: Controla si se permiten bloqueos a nivel de fila para el índice. Los valores posibles son ON (valor predeterminado) y OFF.

ALLOW_PAGE_LOCKS: Controla si se permiten bloqueos a nivel de página para el índice. Los valores posibles son ON (valor predeterminado) y OFF.

ONLINE: Controla si la operación de índice se realiza en línea (sin bloquear la tabla). Los valores posibles son ON y OFF (valor predeterminado). 
Ten en cuenta que esta opción solo está disponible en SQL Server Enterprise Edition.

MAXDOP: Especifica el número máximo de grados de paralelismo que se utilizarán durante la creación del índice. El valor debe ser un entero, 
y el valor predeterminado es 0, lo que indica que se utilizará la configuración del sistema.

RESUMABLE: Esta opción permite que las operaciones de creación y reconstrucción de índices se realicen de manera reanudable. 
Si una operación de índice se interrumpe debido a un error o una pausa manual, se puede reanudar desde el punto en el que se detuvo. 
Esta opción está disponible solo en SQL Server 2017 (14.x) y versiones posteriores.

MAX_DURATION: Cuando se utiliza con la opción RESUMABLE, esta opción especifica la cantidad máxima de tiempo, en minutos, 
que una operación de índice puede ejecutarse antes de ser pausada automáticamente. El valor debe ser un entero.

OPTIMIZE_FOR_SEQUENTIAL_KEY: Esta opción mejora el rendimiento de las operaciones de inserción en tablas con claves de índice clustered secuenciales, 
como columnas IDENTITY o columnas de tipo de datos datetime2 con valores crecientes.

*/



create index IDXArticulos_CodLinea on Articulos(CodLinea)
with (  
    Fillfactor = 80,
    PAD_INDEX = ON,
    drop_existing = on,
    ignore_dup_key = OFF,
    Data_compression = page,
    SORT_IN_TEMPDB = ON,
    STATISTICS_NORECOMPUTE = ON,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON,
    -- ONLINE = ON, -- solo nonclustered
    MAXDOP = 4,
    RESUMABLE = ON,
    MAX_DURATION = 30,
    OPTIMIZE_FOR_SEQUENTIAL_KEY = ON -- solo indices clustered
);


create index IDX_Articulos_CodRegimen on Articulos(CodRegimen) 
include(DesArticulo, CodigoBarra);


create clustered index IDX_Atletas_NroPais on Atletas(NroPais);


-- select * from Atletas where NroPais=10 and NroSexo=1;
-- select Nombre, FechaNacimiento from Atletas where NroPais=10 and NroSexo=1;
create index IDXAtletasNroPaisNroSexo on Atletas(NroPais, NroSexo)
include(Nombre, FechaNacimiento)
with(
	 drop_existing = on
);



create index IDXAtletasNroPais on Atletas(NroPais)
with(
	RESUMABLE = ON,
	MAX_DURATION = 30,
	drop_existing = on,
	ONLINE = ON
);

alter index IDXAtletasNroPais on Atletas pause; /*abort;*/ /*resume;*/


create index IDX_Articulos_CodProveedor on Articulos(CodProveedor) 
include(DesArticulo, CodigoBarra)
with(
    Fillfactor = 80,
    PAD_INDEX = ON,
    drop_existing = off,
    ignore_dup_key = OFF
);



create index IDX_Articulos_CodProveedor on Articulos(CodProveedor) 
include(DesArticulo, CodigoBarra)
with(
    Fillfactor = 80,
    PAD_INDEX = ON,
    drop_existing = on,
    ignore_dup_key = OFF
);

select * from AgenciaDepositoArticulo

create index IDXAtletasFechaNacimiento on Atletas(FechaNacimiento)
where (FechaNacimiento>= '2000-01-01' and FechaNacimiento<='2023-12-31');




drop index IDX_AgenciaDepositoArticulo on AgenciaDepositoArticulo;

-- deshabilitar
alter index all on Atletas disable;


-- habilitar
alter index all on Atletas rebuild;

alter index IDX_AgenciaDepositoArticulo on Atletas disable;

alter index IDX_AgenciaDepositoArticulo on Atletas rebuild;

-- reorganizar indicees
alter index all on Atletas reorganize;


-- borrar varios indices a la vez
drop index IDX_AgenciaDepositoArticulo on AgenciaDepositoArticulo;
drop index AgenciaDepositoArticulo.IDX_AgenciaDepositoArticulo, AgenciaDepositoArticulo.IDX_AgenciaDeposito;




    CREATE INDEX IX_Atletas
ON Atletas (NroPais)
WHERE ((Peso>50 AND Estatura > 190)
and (Peso < 100 AND Estatura < 250));






-- reconstruir con propiedades especificas
ALTER INDEX IDX_AgenciaDepositoArticulo ON AgenciaDeposito REBUILD WITH (FILLFACTOR = 50,STATISTICS_NORECOMPUTE = ON);




-- tipos de datos

create type TyDeposito from int not null;

create table DepositosHistorico(
    NroDeposito TyDeposito primary key,
    Fecha datetime
);









