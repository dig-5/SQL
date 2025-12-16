/*
schemas
	- orden logico de objetos
tablas
	- modo de guardar representar datos
	- pk
	- columnas
	- nombres unicos por schema
secuenciadores
	- 
index
	- 
*/

/*drop
create 
alter
*/
begin transaction;


use Clase02

create table Agencia2(
	CodAgencia smallint ,
	DesAgencia varchar(50),-- 'Mcal lopez'
	Direccion text,
	Estado char(1)
);


DROP TABLE Agencia;
-- nivel columa
create table Agencia(
	CodAgencia smallint primary key,
	DesAgencia varchar(50) not null unique
);


DROP TABLE Agencia;

go

-- nivel tabla
create table Agencia(
	CodAgencia smallint,
	DesAgencia varchar(50) not null,
	primary key (CodAgencia),
	unique (DesAgencia)
);

drop table Agencia


drop table Agencia
-- nivel tabla con nombre presonalizos
create table Agencia3(
	CodAgencia smallint,
	DesAgencia varchar(50) not null,
	constraint PK_Agencia_CodAgencia primary key (CodAgencia),
	constraint UQ_Agencia_DesAgencia unique (DesAgencia)
);

go 
create table Agencia4(
	CodAgencia smallint primary key,
	DesAgencia varchar(50) not null,
	constraint UQ_Agencia_DesAgencia unique (DesAgencia),
	-- unique(CodAgencia,DesAgencia)
	constraint UQ_Agencia_CodAgencia_DesAgencia unique (CodAgencia, DesAgencia)
);




create table AgenciaDeposito (
	CodAgencia smallint references Agencia(CodAgencia),
	CodDeposito smallint, 
	DesDeposito varchar(50) not null,
	primary key (CodAgencia , CodDeposito)
);
 1 1 1
 1 2 2
 1 3 3 
 2 1
 3 1

 1 1
 1 2
 1 3
 2 4
 3 5


create table AgenciaDepositoAlternativa (
	CodAgencia smallint references Agencia(CodAgencia),
	CodDeposito smallint primary key, 
	DesDeposito varchar(50) not null,
	unique (CodAgencia , CodDeposito)
);


create table AgenciaDepositoAlternativa2 (
	ID int primary key,
	CodDeposito smallint,
	CodAgencia smallint references Agencia(CodAgencia),
	DesDeposito varchar(50) not null,
	unique (CodAgencia , CodDeposito)
);

go


create table AgenciaDepositoArticulo2(
	CodAgencia smallint, 
	CodDeposito smallint,
	NroArticulo int, -- references Articulo,
	FechaVencto date,
	Existencia float not null default 0 check(Existencia>=0 /*and Existencia<=100*/),
	primary key (CodAgencia,CodDeposito , NroArticulo, FechaVencto),
	foreign key (CodAgencia, CodDeposito) references AgenciaDeposito(CodAgencia, CodDeposito)
	-- ,foreign key (CodAgencia, CodDeposito) references AgenciaDeposito(CodAgencia, CodDeposito)
	-- , constraint CK_Existencia Check(Existencia>=0)
	-- ,check(Existencia>=0)
);


create table Articulo(
	NroArticulo int primary key,
	DesArticulo varchar(50) not null unique,
	Estado char(1) not null 
		-- check (Estado in ('A', 'I'))
		check (Estado = 'A' or Estado ='I'),
	PrecioDolares money
);


alter table AgenciaDepositoArticulo 
	add constraint FK_AgenciaDepositoArticulo_Articulo 
		foreign key (NroArticulo) references Articulo;



alter table Articulo 
	add Peso real not null;



alter table Articulo 
	add volumen real not null;

alter table  AgenciaDepositoArticulo
	drop CK__AgenciaDe__Exist__5812160E;


create table Regimen (
	CodRegimen int,
	DesRegimen varchar(30) unique,
	PorcentajeIVA real not null
);



alter table Regimen
	alter column CodRegimen int not null;


alter table Regimen 
	add constraint PK_Regimen_CodRegimen
		primary key (CodRegimen);


