insert into Agencia
values ('Casa Central', 'Mcal.López y Saraví', '021-612880');

select * from Agencia;

insert into Agencia (DesAgencia, 
					 TelAgencia, 
					 DirAgencia)
values ('Sucursal CDE', 
		'061-876543', 
		'Adrián Jara y Rodríguez de Francia');

insert into Agencia (DesAgencia, 
					 DirAgencia)
values ('Sucursal Coronel Oviedo', 
		'Mcal.estigarribia y Villarrica');

insert into Agencia (DesAgencia, 
					 TelAgencia, 
					 DirAgencia)
values ('Sucursal Villarrica',
        DEFAULT,
        null);

