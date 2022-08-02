--Alumno: Tomas Alvarez 

drop table alquiler
drop table propietario_espacio
drop table espacio_cochera
drop table cliente
drop table servicio
drop table propietario
drop table edificio

-- 2
create table edificio(
	cod_edificio		integer not null,
	nombre				varchar(30) not null,
	direccion			varchar(30) not null,
	telefono			integer not null,
	constraint PK_edificio_END
		primary key(cod_edificio)
)

create table propietario(
	cod_propietario		integer not null,
	nombre				varchar(30) not null,
	direccion			varchar(30) not null,
	telefono			integer not null,
	constraint PK_propietario_END
		primary key(cod_propietario)
)

create table servicio(
	cod_servicio		integer not null,
	nombre				varchar(30) not null,
	costo_dia			integer not null,
	constraint PK_servicio_END
		primary key(cod_servicio)
)

create table cliente(
	doc_cliente			integer not null,
	nombre				varchar(30) not null,
	apellido			varchar(30) not null,
	direccion			varchar(30) not null,
	telefono			integer not null,
	constraint PK_cliente_END
		primary key(doc_cliente)
)


create table espacio_cochera(
	cod_espacio			integer not null,
	cod_edificio		integer not null,
	costo_hora			integer not null,
	costo_dia			integer not null,
	constraint PK_espacio_cochera_END
		primary key(cod_espacio,cod_edificio),
	constraint FK_espacio_cochera_edificio_END
		foreign key(cod_edificio) references edificio
)

create table propietario_espacio(
	num_propiedad		integer not null,
	cod_espacio			integer not null,
	cod_edificio		integer not null,
	cod_propietario		integer not null,
	fechaInicio			datetime not null,
	fechaFin			datetime,
	constraint PK_propietario_espacio_END
		primary key(num_propiedad,cod_espacio,cod_edificio),
	constraint FK_propietario_espacio_espacio_cochera_END
		foreign key(cod_espacio,cod_edificio) references espacio_cochera,
	constraint FK_propietario_espacio_propietario_END
		foreign key(cod_propietario) references propietario
)

create table alquiler(
	num_alquiler		integer not null,
	cod_espacio			integer not null,
	cod_edificio		integer not null,
	cod_servicio		integer not null,
	doc_cliente			integer not null,
	fechaAlquiler		datetime not null,
	fechaInicio			datetime not null,
	fechaFin			datetime,
	constraint PK_alquiler_END
		primary key(num_alquiler),
	constraint FK_alquiler_espacio_cochera_END
		foreign key(cod_espacio,cod_edificio) references espacio_cochera,
	constraint FK_alquiiler_servicio_END
		foreign key(cod_servicio) references servicio,
	constraint FK_alquiiler_cliente_END
		foreign key(doc_cliente) references cliente
)

insert into propietario
values (1,'NOMBRE1','DIRECCION-1P',123),
		(2,'NOMBRE2','DIRECCION-2P',456),
		(3,'NOMBRE3','DIRECCION-3P',789),
		(4,'NOMBRE4','DIRECCION-4P',987)

insert into edificio
values (1,'EDIFICIO1','DIRECCION-1E',123),
		(2,'EDIFICIO2','DIRECCION-2E',456),
		(3,'EDIFICIO3','DIRECCION-3E',789),
		(4,'EDIFICIO4','DIRECCION-4E',987)

insert into servicio
values (1,'SERVICIO1',1000),
		(2,'SERVICIO2',2000),
		(3,'SERVICIO3',3000),
		(4,'SERVICIO4',4000)

insert into cliente
values (1,'NOMBRE1','APELLIDO1','DIRECCION-1C',123),
		(2,'NOMBRE2','APELLIDO2','DIRECCION-2C',567),
		(3,'NOMBRE3','APELLIDO3','DIRECCION-3C',789),
		(4,'NOMBRE4','APELLIDO4','DIRECCION-4C',978)


insert into espacio_cochera
values (01001,1,1000,2000),
		(01002,1,1000,2000),
		(02001,1,1000,2000),
		(02002,1,1000,2000),
		(-01001,1,1000,2000),

		(01001,2,3000,4000),
		(01002,2,3000,4000),
		(02001,2,3000,4000),
		(02002,2,3000,4000),
		(-01001,2,3000,4000),
		(-01002,2,3000,4000),

		(01001,3,5000,6000),
		(01002,3,5000,6000),
		(02001,3,5000,6000),
		(02002,3,5000,6000),
		(-01001,3,5000,6000),
		(-01002,3,5000,6000)

insert into propietario_espacio
values (1,01001,1,1,'2021-06-28','2021-06-29'),
		(2,01002,1,1,'2021-06-02','2021-07-05'),
		(5,02001,1,1,'2021-04-12','2021-05-10'),
		(6,02002,1,2,'2021-05-30','2021-08-05'),

		(7,02001,2,1,'2021-05-28','2021-06-23'),
		(8,02002,2,1,'2021-07-28','2021-07-30'),
		(9,-01001,2,1,'2021-06-14','2021-06-23'),
		(10,-01002,2,2,'2021-07-28','2021-07-30'),

		(11,01001,3,1,'2021-06-28','2021-07-25'),
		(12,01001,3,1,'2021-07-28','2021-07-29'),
		(13,01001,3,3,'2021-08-28','2021-08-30')

insert into alquiler
values (1,01001,1,1,1,'2021-06-10','2021-06-11 18:00','2021-06-11 19:00'),
		(2,01002,1,2,2,'2021-06-15','2021-06-16 18:00','2021-06-17 18:00'),
		(3,02001,1,3,3,'2021-06-20','2021-06-24 18:00','2021-06-26 11:00'),
		(4,01001,1,1,1,'2021-05-20','2021-05-24 18:00','2021-06-26 11:00')

-- 3 
-------------------------------------------------------------------------------------------------------------------------------------
--tablas						insert								delete							update
---------------------------------------------------------------------------------------------------------------------------------------
--propietarioespacio			Controlar							-----							Controlar
----------------------------------------------------------------------------------------------------------------------------------------
--espaciocochera				----								-----							Controlar
---------------------------------------------------------------------------------------------------------------------------------------
--propietario					----								-----							Controlar
----------------------------------------------------------------------------------------------------------------------------------------

create or alter trigger ti_ri_propietario_espacio
on propietario_espacio
for insert
as
begin
	if exists(
		select pe.cod_edificio,pe.cod_espacio
		from propietario_espacio pe
		group by pe.cod_edificio,pe.cod_espacio,pe.fechaFin
		having count(pe.fechaFin) > 1)
		or exists(
			select pe.cod_edificio,pe.cod_espacio
			from propietario_espacio pe
			group by pe.cod_edificio,pe.cod_espacio,pe.fechaInicio
			having count(pe.fechaInicio) > 1
		)

	  begin 
	     raiserror ('En este intervalo de fechas, ya hay un propietario designado', 16, 1)
	     rollback
      end
end
go

-- No lo permite debido a que genera un conflicto
insert into propietario_espacio
values (14,01001,1,2,'2021-06-28','2021-06-29')

-- Lo permite
insert into propietario_espacio
values (14,01001,1,2,'2022-06-28','2022-06-29')



create or alter trigger tu_ri_propietario_espacio_p
on propietario_espacio
for update
as
begin
	if update(num_propiedad)
	  begin 
	     raiserror ('No se permite cambiar el num de la propiedad', 16, 1)
	     rollback
      end
end
go

create or alter trigger tu_ri_propietario_espacio_ce
on propietario_espacio
for update
as
begin
	if update(cod_espacio)
	  begin 
	     raiserror ('No se permite cambiar el cod del espacio', 16, 1)
	     rollback
      end
end
go

create or alter trigger tu_ri_propietario_espacio_pe
on propietario_espacio
for update
as
begin
	if update(cod_edificio)
	  begin 
	     raiserror ('No se permite cambiar cod del edificio', 16, 1)
	     rollback
      end
end
go



-- 4
create or alter procedure informacion_prop
(
	@cod_propietario	integer,
	@fechaDesde			datetime,
	@fechaHasta			datetime
)
as 
begin
	select ed.nombre,pe.cod_espacio,c.nombre,a.fechaInicio,a.fechaFin
		from propietario_espacio pe
		join alquiler a
			on pe.cod_espacio = a.cod_espacio
			and pe.cod_edificio = a.cod_edificio
		join edificio ed
			on ed.cod_edificio = pe.cod_edificio
		join cliente c
			on c.doc_cliente = a.doc_cliente
		where pe.fechaInicio >= @fechaDesde and pe.fechaFin <= @fechaHasta
		and a.fechaInicio >= @fechaDesde and a.fechaFin <= @fechaHasta
		and pe.cod_propietario = @cod_propietario
end

exec informacion_prop 1, '2021-02-01','2021-06-30' 

exec informacion_prop 2, '2021-02-01','2021-06-30' 

exec informacion_prop 3, '2021-02-01','2021-06-30' 


--Alumno: Tomas Alvarez 


/*
Pruebas
select ed.nombre,pe.cod_espacio,c.nombre,a.fechaInicio,a.fechaFin
		from propietario_espacio pe
		join alquiler a
			on pe.cod_espacio = a.cod_espacio
			and pe.cod_edificio = a.cod_edificio
		join edificio ed
			on ed.cod_edificio = pe.cod_edificio
		join cliente c
			on c.doc_cliente = a.doc_cliente
		where pe.fechaInicio >= '2021-02-01' and pe.fechaFin <= '2021-06-30' 
		and a.fechaInicio >= '2021-02-01' and a.fechaFin <= '2021-06-30' 
		and pe.cod_propietario = '1'
*/