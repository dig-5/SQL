-- Triggers
-- Ejecución Implícita
-- DML
   -- Tabla 
   -- Insert, Update, Delete
   -- No tienen parámetros
   -- Transacción Autocommit
   -- Reglas de Negocios
   -- Auditoría
   -- After/for 
   -- Instead Of
   -- Before (no SQL Server)
   -- Row (no SQL Server)
   -- Statement
      -- Insert -- inserted 
	  -- Delete -- deleted
	  -- Update -- inserted
	            -- deleted
	  -- if update (nombre de columna) -- Insert y Update
	-- sp_settriggerorder
	-- no se ejecuta en  BULK INSERT (al menos que se incluya en la sentencia), ni en truncate

-- DDL
   -- Servidor
   -- Base de Datos
   		--Auditoría (XML)



/*
1. Triggers en SQL Server:

Los triggers en SQL Server son objetos de base de datos diseñados para responder automáticamente a 
eventos específicos, como inserciones, actualizaciones o eliminaciones en tablas. 
Los triggers permiten ejecutar código personalizado cuando ocurren estos eventos.


2. Ejecución Implícita:

Los triggers se ejecutan de forma implícita cuando se produce un evento desencadenante, a diferencia de funciones o SP. 
No es necesario llamarlos explícitamente; 
se activan automáticamente en respuesta a eventos. 


3. Triggers DML (Data Manipulation Language):

Los triggers DML responden a eventos relacionados con operaciones de manipulación de datos, 
como inserciones, actualizaciones y eliminaciones en tablas.


4. Tabla de Referencia:

Los triggers DML están asociados a una tabla específica y se activan cuando se realiza una operación en esa tabla.
*/

use Facturacion

go

-- Crear una tabla de ejemplo
CREATE TABLE Tabla (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(50)
);

GO

CREATE or alter TRIGGER TrINsDelUptTabla
ON Tabla
for INSERT
AS
BEGIN
    -- Código 
    PRINT 'fila insertada trigger TrINsDelUptTabla';
END;

go

CREATE or alter TRIGGER NombreDelTriggerParaDelete
ON Tabla
AFTER delete
AS
BEGIN
    -- Código 
    PRINT 'fila borrada trigger NombreDelTriggerParaDelete';
END;

go

CREATE or alter TRIGGER NombreDelTriggerParaUpdate
ON Tabla
AFTER update
AS
BEGIN
    -- Código 
    PRINT 'fila actualizada trigger NombreDelTriggerParaUpdate';
END;

go


CREATE or alter TRIGGER NombreDelTriggerCombinados
ON Tabla
AFTER update, delete, insert
-- AFTER delete, update
-- AFTER delete, insert
-- AFTER update, insert
AS
BEGIN
    print 'Se realizó una acción. trigger NombreDelTriggerParaInsert'
    
END;

GO



CREATE or alter TRIGGER NombreDelTriggerParaInsert
ON Tabla
AFTER insert
AS
declare @Nombre varchar(255);
BEGIN
    -- Código 
	select @Nombre=Nombre from inserted; 

	if (select Nombre from inserted) = 'Test'
		throw 50000, 'Error', 1;


    PRINT 'nombre: ' +@Nombre;

END;

insert into Tabla
select 500, 'A1' union
select 503, 'A2' union
select 504, 'A3';


insert into Tabla
select 400, 'A1';

/*
5. No Tienen Parámetros:

Los triggers DML no tienen parámetros formales, pero pueden 
acceder a los datos utilizando las tablas especiales "inserted" y "deleted".

Otros motores
new old
*/

-- Crear un trigger "AFTER INSERT" en MiTabla
alter TRIGGER NombreDelTriggerCombinados
ON Tabla
AFTER update, delete, insert
AS
DECLARE @cantidadFilas int;
BEGIN
   if exists(select 1 from inserted)
    begin
        if exists(select 1 from deleted)
            PRINT 'fila actualizada trigger NombreDelTriggerCombinados';
        else
            PRINT 'fila insertada trigger NombreDelTriggerCombinados';

        set @cantidadFilas = (select count(1) from inserted);
    end;
    else
    begin
        PRINT 'fila borrada trigger NombreDelTriggerCombinados';
        set @cantidadFilas = (select count(1) from deleted);
    end;

    print 'Cantidad Filas: ' + cast(@cantidadFilas as varchar(10));
END;

truncate table Tabla;

select * from Tabla


-- Insertar un nuevo registro en MiTabla
INSERT INTO Tabla (ID, Nombre) VALUES (1, 'Ejemplo');

INSERT INTO Tabla (ID, Nombre) VALUES (2, 'Ejemplo'), (3, 'Ejemplo'), (4, 'Ejemplo'), (7, 'Ejemplo'), 
(6, 'Ejemplo'), (5, 'Ejemplo'), (8, 'Ejemplo'), (9, 'Ejemplo'), (10, 'Ejemplo');

delete from Tabla where id in (1);

delete from Tabla where id in (2,3);


update Tabla set Nombre=Nombre where id in (4);

update Tabla set Nombre=Nombre where id in (5,6,7);


/*
6. Transacción Autocommit:

Los triggers DML se ejecutan en el contexto de una transacción autocommit, lo que significa que no necesitas 
iniciar ni confirmar una transacción dentro de un trigger.


7. Reglas de Negocios:

Los triggers pueden utilizarse para aplicar reglas de negocios en la base de datos, 
garantizando la integridad de los datos 
o realizando validaciones específicas.
*/

go


alter TRIGGER NombreDelTriggerCombinados
ON Tabla
AFTER update, delete, insert
AS
DECLARE @cantidadFilas int;
BEGIN
    /*if ROWCOUNT_BIG() =0
        return;
    */

    IF (@@ROWCOUNT = 0)  
        RETURN;


   if exists(select 1 from inserted)
    begin
        if exists(select 1 from deleted)
        begin
            PRINT 'fila actualizada trigger NombreDelTriggerCombinados';

            if exists(select 1 from inserted where nombre not like 'A%')
                THROW 50000, 'El nombre debe comenzar con la letra A para la actualización', 1;

        end;
        else
        begin
            PRINT 'fila insertada trigger NombreDelTriggerCombinados';
            if exists(select 1 from inserted where nombre not like 'A%')
                THROW 50000, 'El nombre debe comenzar con la letra A para el insert', 2;
        end;

        set @cantidadFilas = (select count(1) from inserted);
    end;
    else
    begin
        PRINT 'fila borrada trigger NombreDelTriggerCombinados';
        set @cantidadFilas = (select count(1) from deleted);
    end;

    print 'Cantidad Filas: ' + cast(@cantidadFilas as varchar(10));
END;


select * from Tabla

update  Tabla set nombre='AEjemplo Actualizado' where id=10;

update  Tabla set nombre='AEemplo' where id=10;

update  Tabla set nombre='AEemplo' where id=100;


insert into Tabla
values(2, 'AEjemplo');

insert into Tabla
values(20, 'AEjemplo');

insert into Tabla
values(10, 'Ejemplo');




/*
8. Auditoría:

Los triggers se pueden utilizar para registrar cambios en la base de datos, lo que facilita la auditoría y el 
seguimiento de actividades.
*/

-- drop table TablaAuditoria
CREATE TABLE TablaAuditoria (
    ID INT,
    Nombre VARCHAR(50),
    Fecha datetime, 
    accion char(1),
	primary key (Id, Fecha, accion)
);


go

CREATE TRIGGER AuditoriaTabla
ON Tabla
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    insert into TablaAuditoria
    select id, nombre, GETDATE(), 'I' from inserted
    where not exists(select 1 from deleted);

    insert into TablaAuditoria
    select id, nombre, GETDATE(), 'U' from inserted
    where exists(select 1 from deleted);

    insert into TablaAuditoria
    select id, nombre, GETDATE(), 'D' from deleted
    where not exists(select 1 from inserted);
END;


select * from TablaAuditoria;


delete from Tabla where id=10

/*
9. After/For:

Los triggers pueden definirse como "AFTER"  o "FOR" eventos de inserción, actualización o eliminación, 
dependiendo de cuándo deben ejecutarse.


10. Instead Of:

Los triggers "INSTEAD OF" se utilizan en vistas y permiten reemplazar una operación (por ejemplo, una actualización) 
en lugar de realizarla.

*/

go

create table Tabla2(
	Id int primary key,
	Nombre varchar(10)
);

go

CREATE or alter TRIGGER TriggerInsteadOF
ON Tabla2
Instead of INSERT
AS
BEGIN
    -- Código 
    insert into TablaAuditoria
    select *, getdate(), 'O' from inserted;
END;


select * from Tabla2;

select * from TablaAuditoria;

INSERT INTO Tabla2 (ID, Nombre) VALUES (20, 'Ejemplo');



/*
11. Before (no SQL Server) y Row (no SQL Server):

Estos tipos de triggers son específicos de otros sistemas de gestión de bases de datos (no SQL Server). 
"BEFORE" se ejecuta antes de la operación, mientras que "ROW" se ejecuta por cada fila afectada.


12. Statement:

Los triggers "STATEMENT" se ejecutan una vez por cada operación (por ejemplo, una única vez para una instrucción "INSERT" 
que afecte a varias filas). Pueden acceder a las tablas "inserted" y "deleted" para ver todos los cambios.


13. sp_settriggerorder:

La función sp_settriggerorder se utiliza para establecer el orden de ejecución de los triggers cuando hay 
varios triggers asociados a una tabla.
*/


SELECT
* 
-- name, type_desc, is_instead_of_trigger
FROM sys.triggers
WHERE parent_id = OBJECT_ID('Tabla');

EXEC sp_helptrigger 'dbo.tabla2';  

 
exec sp_settriggerorder 
@triggername= 'NombreDelTriggerParaUpdate', 
@order='First', 
@stmttype = 'update';



select name,
objectproperty ( id, 'ExecIsInsertTrigger' ) [insert],
objectproperty ( id, 'ExecIsUpdateTrigger' ) [update],
objectproperty ( id, 'ExecIsDeleteTrigger' ) [delete],

objectproperty ( id, 'ExecIsFirstInsertTrigger' ) [1º insert],
objectproperty ( id, 'ExecIsFirstUpdateTrigger' ) [1º update],
objectproperty ( id, 'ExecIsFirstDeleteTrigger' ) [1º delete],

objectproperty ( id, 'ExecIsLastInsertTrigger' ) [ultimo insert],
objectproperty ( id, 'ExecIsLastUpdateTrigger' ) [ultimo update],
objectproperty ( id, 'ExecIsLastDeleteTrigger' ) [ultimo delete]
, *
from sysobjects
where
objectproperty ( id, 'IsTrigger' ) = 1



/*

14. No se Ejecuta en BULK INSERT ni en TRUNCATE:

Los triggers no se ejecutan automáticamente cuando se utiliza la instrucción "BULK INSERT" para insertar 
datos masivamente, 
ni cuando se ejecuta "TRUNCATE TABLE" para vaciar una tabla.


15. Triggers DDL (Data Definition Language):

Además de los triggers DML, SQL Server también admite triggers DDL que responden a eventos de definición de datos, 
como la creación o modificación de tablas o procedimientos almacenados.


16. Auditoría (XML, en triggers ddl):

En SQL Server, se pueden utilizar triggers DDL para auditar eventos de servidor o base de datos y registrarlos 
en un formato XML para su análisis posterior.
*/




-- tener en cuenta nested trigger

IF ( (SELECT TRIGGER_NESTLEVEL( OBJECT_ID('TI_DetalleTransaccion') , 'AFTER' , 'DML' ) ) > 5 )  
   RAISERROR('Trigger xyz nested more than 5 levels.',16,-1)  


IF ( (SELECT trigger_nestlevel() ) > 5 )  
   RAISERROR  
      ('This statement nested over 5 levels of triggers.',16,-1)



update  Tabla set nombre='AEemplo' where id=30;




ALTER DATABASE Facturacion SET RECURSIVE_TRIGGERS ON;  




-- habilitar 
-- alter table [table] [enable | disable] trigger [triggername]
-- DISABLE TRIGGER [table] ON [triggername];


disable trigger NombreDelTriggerParaDelete on Tabla;

enable trigger NombreDelTriggerParaDelete on Tabla;



drop trigger NombreDelTriggerParaDelete;









-- drop trigger TrInsPais;

go
-- drop trigger TrInsCiudad 
create trigger TrInsCiudad on Ciudad after insert -- , delete , update
as
begin
		print 'Se insertó fila/s ';
end;

-- select * from Ciudad order by 1 desc

insert into Ciudad values(2, 'Villa Elisa');

insert into Ciudad values(3, 'Encarnación');

go

-- drop trigger TrInsCiudad 

go


alter trigger TrInsCiudad on Ciudad after insert
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		IF (ROWCOUNT_BIG() = 0)RETURN;	

		-- raiserror('No se pueden insertar datos',16,1);

	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
		
		
	end catch
	return;
end;

-- insert into Ciudad values(2, 'Encarnación');


go

alter trigger TrInsCiudad on Ciudad after insert, delete
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		-- IF (ROWCOUNT_BIG() = 0)RETURN;	
		-- print ROWCOUNT_BIG();

		-- insert
		if exists(select 1 from inserted)
		begin
			print 'Se insertó';
		end;
		--if exists(select 1 from deleted)
		else
		begin
			print 'Se borró';
		end;
		
	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
	end catch
	return;
end;

insert into Ciudad values(9, 'Ita');

Delete from Ciudad where CiudadNro=9;


go




create trigger TrUpdCiudad on Ciudad after update
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		-- IF (ROWCOUNT_BIG() = 0)RETURN;	
		-- print ROWCOUNT_BIG();

		-- insert
		if exists(select 1 from inserted)
		begin
			print 'datos nuevos';
		end;
		if exists(select 1 from deleted)
		-- else
		begin
			print 'datos viejos';
		end;
		
	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
	end catch
	return;
end;

insert into Ciudad values(10, 'Ita');

Delete from Ciudad where CiudadNro=9;

update Ciudad set Nombre='Test' where CiudadNro=9;



go




create trigger TrUpdDelUpdCiudad on Ciudad after update, insert, delete
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		-- IF (ROWCOUNT_BIG() = 0)RETURN;	
		-- print ROWCOUNT_BIG();

		-- insert
		if exists(select 1 from inserted) and not exists(select 1 from deleted)
		begin
			print 'insert';
		end;
		else if exists(select 1 from deleted) and not exists(select 1 from inserted)
		-- else
		begin
			print 'delete';
		end;
		else if exists(select 1 from deleted) and exists(select 1 from inserted)
		begin
			print 'update';
		end;
		
	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
	end catch
	return;
end;




insert into Ciudad values(9, 'Ita');

Delete from Ciudad where CiudadNro=9;

update Ciudad set Nombre='Test' where CiudadNro=9;


go




-- select * from Cobrador

create /*or alter*/ trigger TrInsPersona on Persona after insert
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		if exists(select * from inserted where email is null)
			raiserror('La persona debe tener email',16,1);


		if exists(select * from inserted where len(Nombre)<3 or len(Apellido)<3)
			raiserror('Nombre o apellido muy cortos',16,1);
		
	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
		
	end catch;

	return;
end;


go

select * from Persona order by 1 desc;


alter table Persona NOCHECK CONSTRAINT ALL;

alter table Persona CHECK CONSTRAINT ALL;


insert into Persona 
select 1, 'María', 'Perez', 'Carlos antonio lopez', '098111111', 1, 'maria@gmail.com';


insert into Persona 
select 2, 'Alberto', 'Gonzalez', 'España', '021422111', 2, 'mihares@gmail.com';

insert into Persona 
select 3, 'te', 'apellido', 'casa', '021422111', 2,  'mihares@gmail.com';

insert into Persona 
select 3 id, 'tsse' nombre, 'apellido' apellido, 'casa' direccion, '021422111' telefono, 2 ciudad,  'mihares@gmail.com' email
union
select 4, 'Alberto', 'Gonzalez', 'España', '021422111', 2, 'mihares@gmail.com';


go

-- drop table PersonaHistorico;

create table PersonaHistorico(
	PersonaNro int, 
	Nombre varchar(50), 
	Apellido varchar(50), 
	Domicilio varchar(50), 
	Telefono varchar(50), 
	CiudadNro int, 
	Email varchar(50), 
	Fecha datetime, 
	Accion varchar(1), 
	primary key(PersonaNro, Fecha, Accion)
);

go

-- alter table Cobrador enable trigger TrUpdCobrador
create /*or alter*/ trigger TrUpdPersona on Persona after update
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		insert into PersonaHistorico(PersonaNro, Fecha,Nombre,Apellido,Domicilio,Telefono,CiudadNro,Email,Accion)
		select PersonaNro, getdate(),Nombre,Apellido,Domicilio,Teléfono,CiudadNro,Email,'U' 
		from deleted;


	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
		
	end catch;

	return;
end;


select * from PersonaHistorico;



select * from Persona order by 1 desc

select * from PersonaHistorico



update Persona set email='test@uaa.edu.py' where PersonaNro=1;

update Persona set Nombre='Zorrilla', email='desarrollo@uaa.edu.py';



go






go

create /*or alter*/ trigger TrDelPersona on Persona after delete
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		if (select count(*) from deleted)>1
			raiserror('Solo se puede borrar una fila a la vez',16,1);

	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
	end catch;

	return;
end;



select * from Persona order by 1 desc


insert into Persona 
select 3, 'Tatiana', 'Ortega', 'C A Lopez', '0991123456', 3, 'tortega@yahoo.com';


delete from Persona where PersonaNro in (1);


go







go









create or alter trigger TrInsDelUptDetalleTransaccion on DetalleTransaccion after Insert , update , delete
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		-- insert
		if exists(select 1 from inserted) and not exists(select 1 from deleted)
		begin
			-- validar que estado sean A
			if exists(select * from inserted I
						join Transaccion T on T.TransaccionNro=I.TransaccionNro
						where T.Estado!='A')
				raiserror('Una de las transacciones tiene estado distinto a ´A´',16,1);

			-- validar la existencia en stock
			-- forma no correcta
			/*if exists(select * from inserted I
						join StockProducto SP on I.LocalNro=SP.LocalNro and I.DepositoNro=SP.DepositoNro 
												and I.ProductoNro=SP.ProductoNro and I.FechaVencimiento=SP.FechaVencimiento
						where SP.Existencia<I.Cantidad) */
			if exists(select 1 from StockProducto SP
						join (select LocalNro, DepositoNro, ProductoNro, FechaVencimiento, sum(Cantidad) Cantidad
								from inserted
								group by LocalNro, DepositoNro, ProductoNro, FechaVencimiento
							) I on I.LocalNro=SP.LocalNro and I.DepositoNro=SP.DepositoNro 
								and I.ProductoNro=SP.ProductoNro and I.FechaVencimiento=SP.FechaVencimiento
						where  SP.Existencia<I.Cantidad)
			raiserror('Falta de stock',16,1);


			/*descontar de stock la cantidad*/
			update SP
			set Existencia = Existencia - I.Cantidad
			from StockProducto SP
			join (select LocalNro, DepositoNro, ProductoNro, FechaVencimiento, sum(Cantidad) Cantidad
					from inserted
					group by LocalNro, DepositoNro, ProductoNro, FechaVencimiento
			) I on I.LocalNro=SP.LocalNro and I.DepositoNro=SP.DepositoNro 
				and I.ProductoNro=SP.ProductoNro and I.FechaVencimiento=SP.FechaVencimiento;
			
			
			
		end;
		-- update
		else if exists(select 1 from inserted) and exists(select 1 from deleted)
		begin
			-- validar que estado sean A
			if exists(select * from inserted I
						join Transaccion T on T.TransaccionNro=I.TransaccionNro
						where T.Estado!='A')
				raiserror('Una de las transacciones tiene estado distinto a ´A´',16,1);


			-- no se pueden actualizar las pks, la cantidad ni el tipo impuesto
			if update(TransaccionNro) or update(LocalNro) or update(DepositoNro) or update(ProductoNro) 
				or update(FechaVencimiento) or update(Cantidad) or update(TipoImpuestoNro)
				raiserror('Columnas no se pueden actualizar',16,1);

			/*solamente se pueden actualizar tipo producto igual a 1*/
			if exists(select 1 from deleted D
					join Producto P on P.ProductoNro=D.ProductoNro
					where P.TipoProductoNro!=1)
				raiserror('Producto no es del tipo 1',16,1);

		end;
		else
		begin
			-- validar que estado sean A
			if exists(select * from deleted I
						join Transaccion T on T.TransaccionNro=I.TransaccionNro
						where T.Estado!='A')
				raiserror('Una de las transacciones tiene estado distinto a ´A´',16,1);


			-- no se puede eliminar filas que hagan referencia a detalle transferencia
			if exists(select 1 from deleted D
						left join DetalleTransferencia DT on DT.TransaccionNro=D.TransaccionNro 
															and DT.ProductoNro=D.ProductoNro 
															and DT.FechaVencimiento=D.FechaVencimiento
						where DT.TransaccionNro is not null)
				raiserror('Existen filas dentro de detalle transferencia.',16,1);


			/*sumar al stock*/
			update SP
			set Existencia = Existencia + I.Cantidad
			from StockProducto SP
			join (select LocalNro, DepositoNro, ProductoNro, FechaVencimiento, sum(Cantidad) Cantidad
					from deleted
					group by LocalNro, DepositoNro, ProductoNro, FechaVencimiento
			) I on I.LocalNro=SP.LocalNro and I.DepositoNro=SP.DepositoNro 
				and I.ProductoNro=SP.ProductoNro and I.FechaVencimiento=SP.FechaVencimiento;

		end;


	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);

	end catch

	return;
end;




go

create trigger Tr_UpdCompra on Compra after update
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		-- verificar cambios de estados
		if exists(select 1 from deleted where Estado!='A') or exists(select 1 from inserted where Estado!='C')
			raiserror('Los estados no corresponden',16,1);

		-- verificar que solo estado se actuzalice
		if update(NroCompra) or update(CodProveedor) or update(NroFacturaProveedor) or update(CodAgencia) or update(CodDeposito)
			or update(FechaCotizacion) or update(MontoCambio) or update(FechaPedido) or update(FechaRecepcion) or update(Plazo)
			or update(MontoCostoDolares) or update(MontoCostoGuaranies)
			raiserror('Solo se puede actualziar estado',16,1);

		-- actualizar existencia en articulodespoticoagencia
		update ADA set 
		Existencia = ADA.Existencia+T.Cantidad
		from AgenciaDepositoArticulo ADA
		join(select C.CodAgencia, C.CodDeposito, C.NroArticulo, C.FechaVencto, sum(C.Cantidad) Cantidad from inserted I
			join DetalleCompra C on I.NroCompra=C.NroCompra
			group by C.CodAgencia, C.CodDeposito, C.NroArticulo, C.FechaVencto) T on T.CodAgencia=ADA.CodAgencia 
			and T.CodDeposito=ADA.CodDeposito and T.NroArticulo=ADA.NroArticulo and T.FechaVencto=ADA.FechaVencto;

		--Actualziar ultimo precio de compra en articulo
		update A set
		CostoDolares=1,
		CostoGuaranies=1
		from Articulo A
		join (Select DC.NroArticulo,DC.NroCompra, DC.CostoDolares, DC.CostoGuaranies from inserted I 
				join DetalleCompra DC on I.NroCompra=DC.NroCompra) T on A.NroArticulo=T.NroArticulo
		and T.NroCompra = (select top 1 1 from inserted I join DetalleCompra DC on DC.NroCompra=I.NroCompra
							where DC.NroArticulo=A.NroArticulo order by I.FechaPedido desc);

	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		--preguntar por el error  
		--IF @ErrorMessage is null
			--ROLLBACK TRANSACTION
		--desplegar el error
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
		--ROLLBACK TRANSACTION
	end catch
end







GO





create trigger Tr_InsDelUpdDealleFactura on DetalleFactura after delete, update, insert
as
-- declarar variables
DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;
begin
	begin try
		-- verificar tipo de accion dml
		if exists(select 1 from inserted) and not exists (select 1 from deleted)
		begin
			-- insert
			-- verificar que el cod regimen no sea nulo
			if exists(select 1 from inserted where CodRegimen is null)
				RAISERROR ('Codigo regimen no puede ser nulo',16,1);

			-- cantidad mayor a 0
			if exists (select 1 from inserted where Cantidad<1)
				RAISERROR ('cantidad no puede ser menor a 1',16,1);

			-- verificar disponibilidad stock
			if exists(select 1 from inserted I
					join AgenciaDepositoArticulo ADA on I.CodAgencia=ADA.CodAgencia and I.CodDeposito=ADA.CodDeposito and
					I.NroArticulo=ADA.NroArticulo and I.FechaVencto=ADA.FechaVencto
					group by I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto
					having sum(I.Cantidad)>avg(ADA.Existencia))
				RAISERROR ('Existencia no corresponde',16,1);

			--calculo de montoiva, montonetoiva, precioNeto, precio dolares y guaranies
			update DF set 
			MontoIva=case when R.PorcentajeIVA>0 then DF.MontoTotal else 0 end,
			MontoNetoIva=DF.MontoTotal - (DF.MontoTotal/((100+R.PorcentajeIVA)/100)),
			PrecioNeto = DF.MontoTotal/((100+R.PorcentajeIVA)/100),
			PrecioDolares = DF.MontoTotal/F.MontoCambio
			from DetalleFactura DF
			join inserted I on DF.NroFactura=I.NroFactura and DF.CodAgencia=I.CodAgencia and DF.CodDeposito=I.CodDeposito and DF.NroArticulo=I.NroArticulo and DF.FechaVencto=I.FechaVencto
			join Factura F on I.NroFactura=F.NroFactura
			join Regimen R on DF.CodRegimen=R.CodRegimen;


			-- obtener costo dolares, costo guaranies, de la última compra
			update DF set 
			CostoGuaranies=CD.CostoGuaranies,
			CostoDolares=CD.CostoGuaranies
			from DetalleFactura DF
			join inserted I on DF.NroFactura=I.NroFactura and DF.CodAgencia=I.CodAgencia and DF.CodDeposito=I.CodDeposito and DF.NroArticulo=I.NroArticulo and DF.FechaVencto=I.FechaVencto
			join DetalleCompra CD on CD.NroCompra = (select top 1 C.NroCompra 
										from Compra C
										join DetalleCompra DC on C.NroCompra=DC.NroCompra
										where DC.CodAgencia=I.CodAgencia and DC.CodDeposito=I.CodDeposito and DC.NroArticulo=I.NroArticulo and DC.FechaVencto=I.FechaVencto
										order by C.FechaPedido desc)
				and CD.CodAgencia=I.CodAgencia and CD.CodDeposito=I.CodDeposito and CD.NroArticulo=I.NroArticulo and CD.FechaVencto=I.FechaVencto

			--actualizar disponibilidad
			update ADA set
			Existencia=ADA.Existencia - I.Cantidad
			from AgenciaDepositoArticulo ADA
			join (select I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto, sum(I.Cantidad) Cantidad
				 from inserted I group by I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto) I on I.CodAgencia=ADA.CodAgencia 
				 and I.CodDeposito=ADA.CodDeposito and I.NroArticulo=ADA.NroArticulo and I.FechaVencto=ADA.FechaVencto;
			
			--actualizar cabecera
			update F set
			MontoTotal = F.MontoTotal + I.MontoTotal,
			MontoIva = F.MontoIva+ I.MontoIva,
			MontoNetoIva = F.MontoNetoIva+ I.MontoNetoIva
			from Factura F
			join (select I.NroFactura,sum(I.MontoTotal) MontoTotal, sum(I.MontoIva) MontoIva, sum(I.MontoNetoIva) MontoNetoIva 
				from inserted I group by I.NroFactura) I on F.NroFactura=I.NroFactura;


		end
		else if not exists(select 1 from inserted) and exists (select 1 from deleted)
		begin
			-- delete
			
			-- solo pueden eliinarse detalles de facturas de mas de 31 días
			if exists (select 1 from deleted d join Factura F on F.NroFactura=D.NroFactura where DATEDIFF(day,F.FechaEmision, getdate()) <=31)
				RAISERROR ('Error al eliminar la factura',16,1);

			-- actualizar cabecera
			update F set
			MontoTotal = F.MontoTotal - I.MontoTotal,
			MontoIva = F.MontoIva- I.MontoIva,
			MontoNetoIva = F.MontoNetoIva- I.MontoNetoIva
			from Factura F
			join (select I.NroFactura,sum(I.MontoTotal) MontoTotal, sum(I.MontoIva) MontoIva, sum(I.MontoNetoIva) MontoNetoIva 
				from deleted I group by I.NroFactura) I on F.NroFactura=I.NroFactura;


			--actualizar disponibilidad
			update ADA set
			Existencia=ADA.Existencia + I.Cantidad
			from AgenciaDepositoArticulo ADA
			join (select I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto, sum(I.Cantidad) Cantidad
				 from inserted I group by I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto) I on I.CodAgencia=ADA.CodAgencia 
				 and I.CodDeposito=ADA.CodDeposito and I.NroArticulo=ADA.NroArticulo and I.FechaVencto=ADA.FechaVencto;


		end
		else
		begin
			-- update
			-- solo pueden actualizarse las siguientes columnas
			if update(NroFactura) or update(CodAgencia) or update(CodDeposito) or update(NroArticulo) or update(FechaVencto)
				RAISERROR ('No puden actualizar estos campos',16,1);

			-- verificar que el cod regimen no sea nulo
			if exists(select 1 from inserted where CodRegimen is null)
				RAISERROR ('Codigo regimen no puede ser nulo',16,1);

			-- cantidad mayor a 0
			if exists (select 1 from inserted where Cantidad<1)
				RAISERROR ('cantidad no puede ser menor a 1',16,1);


			-- solo si se actualizan estos campos continuar
			if update(Cantidad) or update(MontoTotal) or update(CodRegimen)
			begin

				-- verificar disponibilidad stock
				if exists(select 1 from inserted I
						join AgenciaDepositoArticulo ADA on I.CodAgencia=ADA.CodAgencia and I.CodDeposito=ADA.CodDeposito and
						I.NroArticulo=ADA.NroArticulo and I.FechaVencto=ADA.FechaVencto
						join deleted d on D.CodAgencia=ADA.CodAgencia and D.CodDeposito=ADA.CodDeposito and
						D.NroArticulo=ADA.NroArticulo and D.FechaVencto=ADA.FechaVencto
						group by I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto
						having (sum(I.Cantidad) - sum(D.Cantidad))>avg(ADA.Existencia))
					RAISERROR ('Existencia no corresponde',16,1);



				-- solo si se actualiza cod regimen
				if update(CodRegimen) 
					update DF set 
					MontoIva=case when R.PorcentajeIVA>0 then DF.MontoTotal else 0 end,
					MontoNetoIva=DF.MontoTotal - (DF.MontoTotal/((100+R.PorcentajeIVA)/100)),
					PrecioNeto = DF.MontoTotal/((100+R.PorcentajeIVA)/100),
					PrecioDolares = DF.MontoTotal/F.MontoCambio
					from DetalleFactura DF
					join inserted I on DF.NroFactura=I.NroFactura and DF.CodAgencia=I.CodAgencia and DF.CodDeposito=I.CodDeposito and DF.NroArticulo=I.NroArticulo and DF.FechaVencto=I.FechaVencto
					join Factura F on I.NroFactura=F.NroFactura
					join Regimen R on DF.CodRegimen=R.CodRegimen;




				--actualizar disponibilidad devolver
				update ADA set
				Existencia=ADA.Existencia + I.Cantidad
				from AgenciaDepositoArticulo ADA
				join (select I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto, sum(I.Cantidad) Cantidad
					 from deleted I group by I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto) I on I.CodAgencia=ADA.CodAgencia 
					 and I.CodDeposito=ADA.CodDeposito and I.NroArticulo=ADA.NroArticulo and I.FechaVencto=ADA.FechaVencto;

				--actualizar disponibilidad, sacar
				update ADA set
				Existencia=ADA.Existencia - I.Cantidad
				from AgenciaDepositoArticulo ADA
				join (select I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto, sum(I.Cantidad) Cantidad
					 from inserted I group by I.CodAgencia, I.CodDeposito, I.NroArticulo, I.FechaVencto) I on I.CodAgencia=ADA.CodAgencia 
					 and I.CodDeposito=ADA.CodDeposito and I.NroArticulo=ADA.NroArticulo and I.FechaVencto=ADA.FechaVencto;
			
				--actualizar cabecera
				update F set
				MontoTotal = F.MontoTotal + I.MontoTotal,
				MontoIva = F.MontoIva+ I.MontoIva,
				MontoNetoIva = F.MontoNetoIva+ I.MontoNetoIva
				from Factura F
				join (select I.NroFactura,sum(I.MontoTotal) MontoTotal, sum(I.MontoIva) MontoIva, sum(I.MontoNetoIva) MontoNetoIva 
					from inserted I group by I.NroFactura) I on F.NroFactura=I.NroFactura;
							
				--actualizar cabecera
				update F set
				MontoTotal = F.MontoTotal - I.MontoTotal,
				MontoIva = F.MontoIva+ I.MontoIva,
				MontoNetoIva = F.MontoNetoIva+ I.MontoNetoIva
				from Factura F
				join (select I.NroFactura,sum(I.MontoTotal) MontoTotal, sum(I.MontoIva) MontoIva, sum(I.MontoNetoIva) MontoNetoIva 
					from deleted I group by I.NroFactura) I on F.NroFactura=I.NroFactura;

			end


		end


	end try
	begin catch
		--captura el error
		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();
		--preguntar por el error  
		--IF @ErrorMessage is null
			--ROLLBACK TRANSACTION
		--desplegar el error
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
		--ROLLBACK TRANSACTION
	end catch
end
















CREATE TABLE Auditoria(
	id int primary key,
	fecha datetime NULL,
	usuario text NULL,
	servidor text NULL,
	datos xml NULL
);

go

select * from Auditoria

create trigger DDLServer on database
for ddl_database_level_events
as
begin

	declare @xml xml;

	select @xml = eventdata();

	insert into dbo.Auditoria 
	select coalesce(max(Id),0)+1, getdate(), suser_sname(), host_name(), @xml 
	from Auditoria;
end;


go



create trigger T_Server on all server
for create_database
as begin
	raiserror('No puede crear DD',16,1);
	rollback tran;
end;




