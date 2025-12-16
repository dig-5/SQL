select * from v_Zona_Ciudad
order by CodCiudad;

insert into v_Zona_Ciudad 
values (1, 8, 'Asunción', 100, 1, 'Centro', 0);

alter table ciudad disable trigger all;
insert into v_Zona_Ciudad (CodCiudad, CodPais, Ciudad)
values (101, 8, 'Asunción');

insert into v_Zona_Ciudad (CodZona, CodCiudadZona, Zona, CostoReparto)
values (100, 101, 'Centro', 0);

select * from ciudad
order by codciudad;
select * from Zona
order by codciudad;

delete from v_Zona_Ciudad
where zona = 'Centro';
delete from v_Zona_Ciudad
where CodCiudad = 100;

update v_Zona_Ciudad set ciudad = 'CDE'
where codciudad = 100;
