-- EXAMEN FINAL SBD - 2022
-- Alumno: Ventura Gino
-------------------------------------------------------------------------------------------
-- EJERCICIO 1) 
-- El modelo esta adjunto en el archivo .zip

-- EJERCICIO 2) 

drop table licitaciones
drop table sorteos
drop table suscripciones
drop table clientes
drop table grupos
drop table planes
drop table costos_modelos
drop table modelos
go

create table  modelos (
	codigo_modelo		varchar(30)		not null,
	nombre_modelo		varchar(50)		not null,
	
	primary key(codigo_modelo)
)
go

create table costos_modelos (
	codigo_modelo		varchar(30)		not null,
	codigo_periodo		char(6)		    not null,		--AAAAMM
	costo_mes_año		decimal(10,2)	not null,

	primary key(codigo_modelo, codigo_periodo),
	foreign key(codigo_modelo) references modelos(codigo_modelo)
)
go

create table planes (
	codigo_plan			varchar(30)		not null,
	denominacion		varchar(30)		not null,
	cantidad_cuotas		int				not null,

	primary key(codigo_plan)
)
go

create table grupos (
	codigo_grupo		int				not null,
	codigo_modelo		varchar(30)		not null,
	codigo_plan			varchar(30)		not null,

	primary key(codigo_grupo),
	foreign key(codigo_modelo) references modelos(codigo_modelo),
	foreign key(codigo_plan) references planes(codigo_plan)
)
go

create table clientes (
	numero_cliente		int				not null,
	numero_documento	int				not null,
	apellido			varchar(50)		not null,
	nombre				varchar(50)		not null,
	direccion			varchar(50)		not null,
	telefono			varchar(25)		not null,

	primary key(numero_cliente)
)
go

create table suscripciones (
	numero_suscripcion	int				not null,
	codigo_grupo		int				not null,
	numero_cliente		int				not null,
	fecha_suscripcion	date			not null,
	numero_correlativo	int				not null,

	primary key(numero_suscripcion),
	foreign key(codigo_grupo) references grupos(codigo_grupo),
	foreign key(numero_cliente) references clientes(numero_cliente),
)
go

create table sorteos (
	periodo_sorteo		char(6)			not null,
	codigo_grupo		int				not null,
	numero_suscripcion	int				not null,
	numero_orden		int				not null,
	adjudicado			char(1)			not null,

	primary key(periodo_sorteo, codigo_grupo),
	foreign key(codigo_grupo) references grupos(codigo_grupo),
	foreign key(numero_suscripcion) references suscripciones(numero_suscripcion),
	check(adjudicado in ('S', 'N'))
)
go

create table licitaciones (
	periodo_licitacion	char(6)			not null,
	codigo_grupo		int				not null,
	numero_suscripcion	int				not null,
	cantidad_cuotas		int				not null,
	adjudicado			char(1)			not null,

	primary key(periodo_licitacion, codigo_grupo),
	foreign key(codigo_grupo) references grupos(codigo_grupo),
	foreign key(numero_suscripcion) references suscripciones(numero_suscripcion),
	check(adjudicado in ('S', 'N'))
)
go

select * from licitaciones
select * from sorteos
select * from suscripciones
select * from clientes
select * from grupos
select * from planes
select * from costos_modelos
select * from modelos
go

-- EJERCICIO 3)
--------------------------------------------------------------------------------------------
-- REGLA DE INTEGRIDAD: En cada grupo, cada suscriptor no puede tener mas de una adjudicacion
-- (sin importar si es por sorteo o licitacion)
--------------------------------------------------------------------------------------------
-- A. Consulta select de registros con problemas:

select s.codigo_grupo, s.numero_suscripcion
	from sorteos s
		join licitaciones l
			on s.codigo_grupo = l.codigo_grupo
		where s.numero_suscripcion = l.numero_suscripcion
		  and s.adjudicado = 'S'
		  and l.adjudicado = 'S'
go

--------------------------------------------------------------------------------------------
--       TABLA			 |       INSERT	     |		 DELETE		 | 		UPDATE  
--------------------------------------------------------------------------------------------
-- 		SORTEOS			 |         SI		 |		   NO		 |		  SI
--------------------------------------------------------------------------------------------
--		LICITACIONES     |         SI        |         NO		 |        SI
--------------------------------------------------------------------------------------------
-- Insert en SORTEOS: si se inserta un sorteo, se debe verificar que el adjudicado no haya 
-- sido adjudicado en el grupo anteriormente.
-- Delete en SORTEOS: si se elimina un sorteo, no deja de cumplir una RI algo que no existe.
-- Update en SORTEOS: si se actualiza un sorteo, no se debe permitir modificar el grupo del 
-- sorteo, si se actualiza el numero_suscriptor, se debe controlar que no haya sido adjudicado
-- anteriormente, si se actualiza el estado de adjudicado se debe verificar que tampoco haya 
-- sido adjudicado. 
--------------------------------------------------------------------------------------------
-- Insert en LICITACIONES: si se inserta una licitacion, se debe verificar que el adjudicado 
-- no haya sido adjudicado en el grupo anteriormente.
-- Delete en LICITACIONES: si se elimina una licitacion, no deja de cumplir una RI algo que 
-- no existe.
-- Update en LICITACIONES: si se actualiza una licitacion, no se debe permitir modificar el 
-- grupo de la licitacion, si se actualiza el numero_suscriptor, se debe controlar que no 
-- haya sido adjudicado anteriormente, si se actualiza el estado de adjudicado se debe verificar 
-- que tampoco haya sido adjudicado anteriormente. 
--------------------------------------------------------------------------------------------

-- Trigger insert en sorteos:
if OBJECT_ID('tri_in_sorteos') is not null
	drop trigger tri_in_sorteos
go

create or alter trigger tri_in_sorteos
on sorteos
for insert
	as
	begin
		if exists(select s.codigo_grupo, s.numero_suscripcion
					from sorteos s
						join licitaciones l
							on s.codigo_grupo = l.codigo_grupo
						where s.numero_suscripcion = l.numero_suscripcion
						  and s.adjudicado = 'S'
						  and l.adjudicado = 'S')
						begin
			raiserror('El suscriptor adjudicado en este sorteo, ya fue adjudicado anteriormente', 16, 1)
			rollback
		end
	end
go

-- Trigger update en sorteos por el codigo de grupo:
if OBJECT_ID('tri_up_sorteos_codgrup') is not null
	drop trigger tri_up_sorteos_codgrup
go


create or alter trigger tri_up_sorteos_codgrup
on sorteos
for update
	as
	begin
		if update(codigo_grupo)
		begin
			raiserror('No se permite cambiar el codigo de grupo del sorteo', 16, 1)
		end
	end
go

-- Trigger update en sorteos:
if OBJECT_ID('tri_up_sorteos') is not null
	drop trigger tri_up_sorteos
go

create or alter trigger tri_up_sorteos
on sorteos
for update
	as
	begin
		if exists(select s.codigo_grupo, s.numero_suscripcion
					from sorteos s
						join licitaciones l
							on s.codigo_grupo = l.codigo_grupo
						where s.numero_suscripcion = l.numero_suscripcion
						  and s.adjudicado = 'S'
						  and l.adjudicado = 'S')
		begin
			raiserror('El suscriptor ya ha sido adjudicado anteriormente', 16, 1)
			rollback
		end
	end
go

-- Trigger insert en licitaciones:
if OBJECT_ID('tri_in_licitaciones') is not null
	drop trigger tri_in_licitaciones
go

create or alter trigger tri_in_licitaciones
on licitaciones
for insert
	as
	begin
		if exists(select s.codigo_grupo, s.numero_suscripcion
					from sorteos s
						join licitaciones l
							on s.codigo_grupo = l.codigo_grupo
						where s.numero_suscripcion = l.numero_suscripcion
						  and s.adjudicado = 'S'
						  and l.adjudicado = 'S')
						begin
			raiserror('El suscriptor licitado, ya fue adjudicado anteriormente', 16, 1)
			rollback
		end
	end
go

-- Trigger update en licitaciones por el codigo de grupo:
if OBJECT_ID('tri_up_licitaciones_codgrup') is not null
	drop trigger tri_up_licitaciones_codgrup
go

create or alter trigger tri_up_licitaciones_codgrup
on licitaciones
for update
	as
	begin
		if update(codigo_grupo)
		begin
			raiserror('No se permite cambiar el codigo de grupo de la licitacion', 16, 1)
		end
	end
go

-- Trigger update en licitaciones:
if OBJECT_ID('tri_up_licitaciones') is not null
	drop trigger tri_up_licitaciones
go

create or alter trigger tri_up_licitaciones
on licitaciones
for update
	as
	begin
		if exists(select s.codigo_grupo, s.numero_suscripcion
					from sorteos s
						join licitaciones l
							on s.codigo_grupo = l.codigo_grupo
						where s.numero_suscripcion = l.numero_suscripcion
						  and s.adjudicado = 'S'
						  and l.adjudicado = 'S')
		begin
			raiserror('El suscriptor ya ha sido licitado anteriormente', 16, 1)
			rollback
		end
	end
go

--------------------------------------------------------------------------------------------
-- EJERCICIO 4)

create or alter procedure procedimiento
-- Variables ingresadas
(
	@modelo			varchar(30),
	@plan			varchar(30)
)
as
	begin
	declare @resultados	table (
		numero_grupo				int, 
		numero_suscriptor			int,
		numero_correlativo			int,
	)

		-- Consulta que devolveria la cantidad de suscriptores que no tienen 
		-- grupo para ese modelo y plan determinado
		select count(*)
			from grupos g 
				join suscripciones s
					on g.codigo_grupo = s.codigo_grupo
			where g.codigo_modelo = @modelo
			  and g.codigo_plan = @plan
			  and s.codigo_grupo is null

		/**** No supe como armar los grupos ****/
	end

-- Ejecutar el procedimiento
exec procedimiento 'Duster-Z-16', 'Renault Duster Zen 1.6'
