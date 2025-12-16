create type T_Cliente as table (IdCliente int not null identity(1, 1) primary key,
                                RazonSocial varchar(256) not null,
						        RUC ruc);

declare @vCliente T_Cliente;

insert into @vCliente 
values ('Prueba 1', '800436-1'),
       ('Prueba 2', '800437-1'),
       ('Prueba 3', '800438-1'),
       ('Prueba 4', '800439-1'),
       ('Prueba 5', '800440-1'),
       ('Prueba 6', '800450-1');

select * from @vCliente;

