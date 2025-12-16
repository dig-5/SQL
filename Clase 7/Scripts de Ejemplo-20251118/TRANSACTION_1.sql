-- Transacciones
-- Test ACID (Atomicity, Consistency, Isolation, Durability)

-- Inicio de la Transacción (BEGIN TRANSACTION)
-- Finalización de la Transacción
	-- Compromete los cambios en la base de datos (COMMIT TRANSACTION)
	-- Rechaza los cambios en la base de datos (ROLLBACK TRANSACTION)

-- Autocommit

INSERT 

UPDATE 

DELETE

-- Implícitas

SET IMPLICIT_TRANSACTIONS ON
INSERT
UPDATE
DELETE
COMMIT TRANSACTION
INSERT
UPDATE
DELETE
ROLLBACK TRANSACTION
SET IMPLICIT_TRANSACTIONS OFF

-- Explícitas

BEGIN TRANSACTION
INSERT 
UPDATE
DELETE
COMMIT TRANSACTION

BEGIN TRANSACTION
INSERT 
UPDATE
DELETE
ROLLBACK TRANSACTION

BEGIN TRANSACTION
INSERT 
UPDATE
	BEGIN TRANSACTION
	DELETE
	ROLLBACK TRANSACTION
COMMIT TRANSACTION

--Transacciones

-- Transaccion explícitas

begin try

begin transaction;
a
b
c
d
e
f
g
commit transaction;

end try

begin catch

rollback transaction;

end catch

-- Transacciones autocommit

insert
update
delete

-- Transacciones implícitas

set implicit_transactions on
a
b
c
d
commit transaction;
e
f
g
rollback transaction;
h
i
j
k
commit transaction;
set implicit_transactions off
 