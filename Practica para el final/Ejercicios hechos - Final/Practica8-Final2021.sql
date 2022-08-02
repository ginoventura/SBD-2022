-- FINAL 2021 - SBD

drop table alquileres
drop table propietarios_espacios
drop table espacios_cocheras
drop table clientes
drop table servicios
drop table propietarios
drop table edificios

create table edificios (
	codigo_edificio				int			not null,
	nombre						varchar(50)	not null,
	direccion					varchar(50)	not null,
	telefono					int			not null,

	primary key(codigo_edificio)
)

create table propietarios (
	codigo_propietario			int			not null,
	nombre_propietario			varchar(30)	not null,
	direccion					varchar(50) not null,
	telefono					int			not null,

	primary key(codigo_propietario)
)

create table servicios (
	codigo_servicio				int			not null,
	nombre_servicio				varchar(30)	not null,
	costo_dia					int			not null,

	primary key(codigo_servicio)
)

create table clientes (
	documento_cliente			int			not null,
	nombre_cliente				varchar(30)	not null,
	apellido_cliente			varchar(30)	not null,
	direccion					varchar(50)	not null,
	telefono					int			not null,

	primary key(documento_cliente)
)

create table espacios_cocheras (
	codigo_espacio				int			not null,
	codigo_edificio				int			not null,
	costo_hora					int			not null,
	costo_dia					int			not null,

	primary key(codigo_espacio, codigo_edificio),
	foreign key(codigo_edificio) references edificios(codigo_edificio)
)

create table propietarios_espacios (
	numero_propiedad			int			not null,
	codigo_espacio				int			not null,
	codigo_edificio				int			not null,
	codigo_propietario			int			not null,
	fecha_inicio				datetime	not null,
	fecha_fin					datetime,

	primary key(numero_propiedad, codigo_espacio, codigo_edificio),
	foreign key(codigo_espacio, codigo_edificio) references espacios_cocheras(codigo_espacio, codigo_edificio),
	foreign key(codigo_propietario) references propietarios(codigo_propietario)
)

create table alquileres (
	numero_alquiler				int			not null,
	codigo_espacio				int			not null,
	codigo_edificio				int			not null,
	codigo_servicio				int			not null,
	documento_cliente			int			not null,
	fecha_alquiler				datetime	not null,
	fecha_inicio				datetime	not null,
	fecha_fin					datetime,

	primary key(numero_alquiler),
	foreign key(codigo_espacio, codigo_edificio) references espacios_cocheras(codigo_espacio, codigo_edificio),
	foreign key(codigo_servicio) references servicios(codigo_servicio),
	foreign key(documento_cliente) references clientes(documento_cliente)
)

insert into propietarios
values (1, 'NOMBRE1', 'DIRECCION-1P', 123),
	   (2, 'NOMBRE2', 'DIRECCION-2P', 456),
	   (3, 'NOMBRE3', 'DIRECCION-3P', 789),
	   (4, 'NOMBRE4', 'DIRECCION-4P', 987)

insert into edificios
values (1, 'EDIFICIO1', 'DIRECCION-1E', 123),
	   (2, 'EDIFICIO2', 'DIRECCION-2E', 456),
	   (3, 'EDIFICIO3', 'DIRECCION-3E', 789),
	   (4, 'EDIFICIO4', 'DIRECCION-4E', 987)

insert into servicios
values (1, 'SERVICIO1', 1000),
	   (2, 'SERVICIO2', 2000),
	   (3, 'SERVICIO3', 3000),
	   (4, 'SERVICIO4', 4000)

insert into clientes
values (1, 'NOMBRE1', 'APELLIDO1', 'DIRECCION-1C', 123),
	   (2, 'NOMBRE2', 'APELLIDO2', 'DIRECCION-2C', 567),
	   (3, 'NOMBRE3', 'APELLIDO3', 'DIRECCION-3C', 789),
	   (4, 'NOMBRE4', 'APELLIDO4', 'DIRECCION-4C', 978)


insert into espacios_cocheras
values (01001, 1, 1000, 2000),
	   (01002, 1, 1000, 2000),
	   (02001, 1, 1000, 2000),
	   (02002, 1, 1000, 2000),
	   (-01001,1, 1000, 2000),
	   
	   (01001, 2, 3000, 4000),
	   (01002, 2, 3000, 4000),
	   (02001, 2, 3000, 4000),
	   (02002, 2, 3000, 4000),
	   (-01001,2, 3000, 4000),
	   (-01002,2, 3000, 4000),
	   			  	    
	   (01001, 3, 5000, 6000),
	   (01002, 3, 5000, 6000),
	   (02001, 3, 5000, 6000),
	   (02002, 3, 5000, 6000),
	   (-01001,3, 5000, 6000),
	   (-01002,3, 5000, 6000)

insert into propietarios_espacios
values (1, 01001, 1, 1, '2021-06-28', '2021-06-29'),
	   (2, 01002, 1, 1, '2021-06-02', '2021-07-05'),
	   (5, 02001, 1, 1, '2021-04-12', '2021-05-10'),
	   (6, 02002, 1, 2, '2021-05-30', '2021-08-05'),
	   
	   (7,  02001, 2, 1, '2021-05-28', '2021-06-23'),
	   (8,  02002, 2, 1, '2021-07-28', '2021-07-30'),
	   (9, -01001, 2, 1, '2021-06-14', '2021-06-23'),
	   (10,-01002, 2, 2, '2021-07-28', '2021-07-30'),
	   
	   (11, 01001, 3, 1, '2021-06-28', '2021-07-25'),
	   (12, 01001, 3, 1, '2021-07-28', '2021-07-29'),
	   (13, 01001, 3, 3, '2021-08-28', '2021-08-30')

insert into alquileres
values (1, 01001, 1, 1, 1, '2021-06-10', '2021-06-11 18:00', '2021-06-11 19:00'),
	   (2, 01002, 1, 2, 2, '2021-06-15', '2021-06-16 18:00', '2021-06-17 18:00'),
	   (3, 02001, 1, 3, 3, '2021-06-20', '2021-06-24 18:00', '2021-06-26 11:00'),
	   (4, 01001, 1, 1, 1, '2021-05-20', '2021-05-24 18:00', '2021-06-26 11:00')
go

select * from alquileres
select * from propietarios_espacios
select * from espacios_cocheras
select * from clientes
select * from servicios
select * from propietarios
select * from edificios
go

-- Triggers

create or alter trigger tri_in_prop_espacios
	on propietarios_espacios
	for insert
	as 
	begin
	if exists (select pe.codigo_edificio, pe.codigo_espacio
					from propietarios_espacios pe
			   group by pe.codigo_edificio, pe.codigo_espacio, pe.fecha_fin
			   having count(pe.fecha_fin) > 1)
		or exists (
			   select pe.codigo_edificio,pe.codigo_espacio
					from propietarios_espacios pe
			   group by pe.codigo_edificio,pe.codigo_espacio,pe.fecha_inicio
			   having count(pe.fecha_inicio) > 1)
		begin
			raiserror('En este intervalo de fechas, ya hay un propietario designado', 16,1)
			rollback
		end
	end
go

create or alter trigger tri_up_prop_espacios
on propietarios_espacios
for update
	as 
	begin
		if update(numero_propiedad) or update(codigo_espacio) or update (codigo_edificio)
			begin
				raiserror('No se permiten modificar estos datos.', 16, 1)
				rollback
			end
	end
go

-- Procedimiento almacenado
create or alter procedure informacion
(
	@codigo_propietario			int,
	@fechaDesde					datetime,
	@fechaHasta					datetime
)
as 
	begin
		select * 
			from propietarios_espacios pe
				join alquileres a 
					on pe.codigo_espacio = a.codigo_espacio
				   and pe.codigo_edificio = a.codigo_edificio
				join edificios ed
					on ed.codigo_edificio = pe.codigo_edificio
				join clientes c
					on c.documento_cliente = a.documento_cliente
			where pe.fecha_inicio >= @fechaDesde and pe.fecha_fin <= @fechaHasta
			  and a.fecha_inicio >= @fechaDesde and a.fecha_fin <= @fechaHasta
			  and pe.codigo_propietario = @codigo_propietario
	end

-- Ejecutar el procedimiento:
exec informacion 1, '2021-02-01','2021-06-30' 
exec informacion 2, '2021-02-01','2021-06-30' 
exec informacion 3, '2021-02-01','2021-06-30'