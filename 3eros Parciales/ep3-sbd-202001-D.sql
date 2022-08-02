-- INGENIERIA EN INFORMATICA - SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL Nº 2 - 26-05-2020

/* ---------------------------------------------------------------------------------------------------------------
   La siguiente base de datos da soporte a un sistema de gestión de solicitudes de servicios internos de una 
   empresa.
   Se registra la siguiente información:
   - Áreas de la empresa (cada área puede ser un área que provee un servicio, pero además puede solicitar un 
     servicio
   - Personal que trabaja en cada área
   - Servicios que se brindan desde diferentes áreas indicando cual es el área responsable. La ejecución de un servicio 
     puede constar de varias tareas que son ejecutadas a partir de órdenes de trabajo.
   - El personal que realiza cada servicio indicando quien es el responsable (solo puede haber uno por servicio)
   - Las solicitudes de servicio
   - Las órdenes de trabajo asociadas a cada solicitud (cada servicio puede tener una o varias órdenes de trabajo 
     cada una de ellas ejecutada por un empleado)
   - En la medida en que las órdenes de trabajo son ejecutadas se registra su fecha de inicio, fecha de 
     finalización y la cantidad de horas dedicadas a la ejecución de la misma.
	 Los estados de la cada orden de trabajo son:
	 P: Pendiente (no se informan fecha_inicio, fecha_fin ni horas_totales)
	 A: Anulada (se informa fecha_inicio = fecha_fin)
	 E: En ejecución (se informa fecha_inicio
	 F: Finalizada (se informa fecha_inicio, fecha_fin y horas_totales
   - La fecha de entrega de la solicitud es la máxima fecha de finalización de todas sus órdenes de compra y solo
     se informa si hay por lo menos una orden finalizada y las demás están también finalizadas o anuladas.
   --------------------------------------------------------------------------------------------------------------- */

drop table ordenes_trabajo
drop table solicitudes
drop table personal_servicios
drop table servicios
drop table personal_areas
drop table areas
go

create table areas
(
 nro_area			smallint	not null,
 area				varchar(40)	not null,
 primary key (nro_area),
 unique (area)
)
go

create table personal_areas
(
 nro_area				smallint	not null,
 nro_personal			smallint	not null,
 nom_personal			varchar(40)	not null,
 primary key (nro_area, nro_personal),
 foreign key (nro_area) references areas
)
go

create table servicios
(
 nro_servicio			smallint	not null,
 servicio				varchar(40)	not null,
 nro_area_responsable	smallint	not null,
 primary key (nro_servicio),
 unique (servicio),
 foreign key (nro_area_responsable) references areas
)
go

create table personal_servicios
(
 nro_servicio			smallint	not null,
 nro_area				smallint	not null,
 nro_personal			smallint	not null,
 responsable			char(1)		not null,
 primary key (nro_servicio, nro_area, nro_personal),
 foreign key (nro_servicio) references servicios,
 foreign key (nro_area, nro_personal) references personal_areas,
 check (responsable in ('S','N'))
)
go

create table solicitudes
(
 año_solicitud			smallint		not null,
 nro_solicitud			smallint		not null,
 fecha_solicitud		smalldatetime	not null,
 nro_area_solicita		smallint		not null,
 nro_personal_solicita	smallint		not null,
 nro_servicio			smallint		not null,
 fecha_entrega			date			null,
 primary key (año_solicitud, nro_solicitud),
 foreign key (nro_area_solicita, nro_personal_solicita) references personal_areas,
 foreign key (nro_servicio) references servicios
)
go

create table ordenes_trabajo
(
 año_solicitud					smallint	not null,
 nro_solicitud					smallint	not null,
 nro_orden_trabajo				tinyint		not null,
 nro_servicio					smallint	not null,
 nro_area						smallint	not null,
 nro_personal					smallint	not null,
 estado							char(1)		not null,
 fecha_inicio					date		null,
 fecha_fin						date		null,
 horas_totales					smallint	null,
 primary key (año_solicitud, nro_solicitud, nro_orden_trabajo), 
 foreign key (año_solicitud, nro_solicitud) references solicitudes,
 foreign key (nro_servicio, nro_area, nro_personal) references personal_servicios,
 check (estado = 'P' and fecha_inicio is null     and fecha_fin is null     or -- PENDIENTE
        estado = 'A' and fecha_inicio is not null and fecha_fin is not null and fecha_inicio = fecha_fin or -- ANULADO
        estado = 'E' and fecha_inicio is not null and fecha_fin is null     or -- EN EJECUCIÓN
        estado = 'F' and fecha_inicio is not null and fecha_fin is not null and horas_totales > 0) -- FINALIZADO
)
go


insert into areas (nro_area, area)
values (10, 'AREA 10'),
       (20, 'AREA 20'),
       (30, 'AREA 30'),
       (40, 'AREA 40'),
       (50, 'AREA 50'),
       (60, 'AREA 60')
go

insert into personal_areas (nro_area, nro_personal, nom_personal)
values (10, 1, 'EMPLEADO 10-1'),
       (10, 2, 'EMPLEADO 10-2'),
       (10, 3, 'EMPLEADO 10-3')

insert into personal_areas (nro_area, nro_personal, nom_personal)
values (20, 1, 'EMPLEADO 20-1'),
       (20, 4, 'EMPLEADO 20-4'),
       (20, 5, 'EMPLEADO 20-5'),
       (20, 6, 'EMPLEADO 20-6')

insert into personal_areas (nro_area, nro_personal, nom_personal)
values (30, 7, 'EMPLEADO 30-7'),
       (30, 8, 'EMPLEADO 30-8')

insert into personal_areas (nro_area, nro_personal, nom_personal)
values (40, 2, 'EMPLEADO 40-2'),
       (40, 4, 'EMPLEADO 40-4'),
       (40, 9, 'EMPLEADO 40-9')

insert into personal_areas (nro_area, nro_personal, nom_personal)
values (50, 1, 'EMPLEADO 50-1'),
       (50, 5, 'EMPLEADO 50-5'),
       (50, 10, 'EMPLEADO 50-10')

insert into personal_areas (nro_area, nro_personal, nom_personal)
values (60, 9, 'EMPLEADO 60-9'),
       (60, 10, 'EMPLEADO 60-10')
go

insert into servicios (nro_servicio, servicio, nro_area_responsable)
values (100, 'SERVICIO 100', 10),
       (200, 'SERVICIO 200', 20),
       (300, 'SERVICIO 300', 30)
go

insert into personal_servicios (nro_servicio, nro_area, nro_personal, responsable)
values (100, 10, 1, 'S'),
       (100, 10, 2, 'N'),
       (100, 10, 3, 'N'),
       (100, 20, 4, 'N'),
       (100, 30, 7, 'N')

insert into personal_servicios (nro_servicio, nro_area, nro_personal, responsable)
values (200, 20, 5, 'S'),
       (200, 20, 6, 'N')

insert into personal_servicios (nro_servicio, nro_area, nro_personal, responsable)
values (300, 30, 8, 'S')
go

set dateformat ymd;
go

insert into solicitudes (año_solicitud, nro_solicitud, fecha_solicitud, nro_area_solicita, nro_personal_solicita, nro_servicio, fecha_entrega)
values (2017,  1, '2019-01-27 10:00', 10, 1, 200, '2017-03-11'),
       (2017,  2, '2019-02-27 10:00', 20, 1, 200, null),
       (2017,  3, '2019-03-27 10:00', 20, 4, 300, null),
       (2017,  4, '2019-04-27 10:00', 40, 2, 300, null),
       (2017,  5, '2019-05-27 10:00', 50, 1, 100, '2017-05-12')

insert into solicitudes (año_solicitud, nro_solicitud, fecha_solicitud, nro_area_solicita, nro_personal_solicita, nro_servicio, fecha_entrega)
values (2018,  1, '2019-01-28 10:00', 10, 1, 100, null),
       (2018,  2, '2019-02-28 10:00', 30, 8, 100, null),
       (2018,  3, '2019-03-28 10:00', 40, 9, 300, null),
       (2018,  4, '2019-04-28 10:00', 40, 9, 200, '2018-08-31'),
       (2018,  5, '2019-05-28 10:00', 40, 9, 200, '2018-09-22')

insert into solicitudes (año_solicitud, nro_solicitud, fecha_solicitud, nro_area_solicita, nro_personal_solicita, nro_servicio, fecha_entrega)
values (2019,  1, '2019-01-10 10:00', 10, 1, 100, '2019-06-01'),
       (2019,  2, '2019-02-20 10:00', 30, 8, 200, null),
       (2019,  3, '2019-03-30 10:00', 40, 9, 300, null),
       (2019,  4, '2019-04-10 10:00', 40, 9, 300, null),
       (2019,  5, '2019-05-20 10:00', 50, 5, 100, null),
       (2019,  6, '2019-06-30 10:00', 10, 1, 100, null),
       (2019,  7, '2019-07-10 10:00', 10, 3, 100, null),
       (2019,  8, '2019-08-20 10:00', 10, 3, 300, '2019-12-12'),
       (2019,  9, '2019-09-30 10:00', 20, 6, 200, null),
       (2019, 10, '2019-10-10 10:00', 50,10, 200, null),
       (2019, 11, '2019-11-20 10:00', 50, 1, 100, null),
       (2019, 12, '2019-12-20 10:00', 50, 5, 100, null),
       (2019, 13, '2019-12-20 10:00', 50,10, 300, null),
       (2019, 14, '2019-12-25 10:00', 20, 4, 200, null),
       (2019, 15, '2019-12-30 10:00', 40, 4, 200, null),
       (2019, 16, '2019-12-30 10:00', 20, 5, 200, null)
go

insert into ordenes_trabajo (año_solicitud, nro_solicitud, nro_orden_trabajo, nro_servicio, nro_area, nro_personal, estado, fecha_inicio, fecha_fin, horas_totales)
values (2017,  1, 1, 200,  20, 5, 'F', '2017-01-30', '2017-03-11', 620),
       (2017,  1, 2, 200,  20, 6, 'F', '2017-01-31', '2017-02-02', 30),
       (2017,  2, 1, 200,  20, 6, 'P', null,         null,         null),
       (2017,  3, 1, 300,  30, 8, 'A', '2017-03-01', '2017-03-01', null),
       (2017,  4, 1, 300,  30, 8, 'E', '2017-05-01', null,         null),
       (2017,  5, 1, 100,  10, 1, 'F', '2017-04-27', '2017-05-12', 150)

insert into ordenes_trabajo (año_solicitud, nro_solicitud, nro_orden_trabajo, nro_servicio, nro_area, nro_personal, estado, fecha_inicio, fecha_fin, horas_totales)
values (2018,  1, 1, 100,  10, 1, 'P', null,         null,         null),
       (2018,  1, 2, 100,  10, 2, 'F', '2018-03-01', '2018-03-15', 140),
       (2018,  1, 3, 100,  30, 7, 'F', '2018-04-01', '2018-04-30', 360),
       (2018,  2, 1, 100,  20, 4, 'A', '2018-06-01', '2018-06-01', 120),
       (2018,  3, 1, 300,  30, 8, 'E', '2018-06-01', null,         null),
       (2018,  4, 1, 200,  20, 5, 'F', '2018-08-29', '2018-08-31', 10),
       (2018,  5, 1, 200,  20, 6, 'F', '2018-09-12', '2018-09-22', 350)

insert into ordenes_trabajo (año_solicitud, nro_solicitud, nro_orden_trabajo, nro_servicio, nro_area, nro_personal, estado, fecha_inicio, fecha_fin, horas_totales)
values (2019,  1, 1, 100,  10, 1, 'F', '2019-06-01', '2019-06-01', 8),
       (2019,  1, 2, 100,  10, 2, 'A', '2019-06-07', '2019-06-07', null),
       (2019,  1, 3, 100,  30, 7, 'A', '2019-07-12', '2019-07-12', null),
       (2019,  2, 1, 200,  20, 5, 'A', '2019-08-22', '2019-08-22', null),
       (2019,  3, 1, 300,  30, 8, 'P', null,         null,         null),
       (2019,  4, 1, 300,  30, 8, 'P', null,         null,         null),
       (2019,  5, 1, 100,  10, 2, 'E', '2019-10-01', null,         null),
       (2019,  6, 1, 100,  20, 4, 'E', '2019-06-17', null,         null),
       (2019,  7, 1, 100,  10, 1, 'P', null,         null,         null),
       (2019,  7, 2, 100,  30, 7, 'A', '2019-11-12', '2019-11-12', null),
       (2019,  8, 1, 300,  30, 8, 'F', '2019-12-12', '2019-12-12', 10),
       (2019,  9, 1, 200,  20, 6, 'E', '2019-10-03', null,         null),
       (2019,  9, 2, 200,  20, 5, 'F', '2019-07-07', '2019-12-07', 10),
       (2019, 10, 1, 200,  20, 5, 'E', '2019-06-01', null,         null),
       (2019, 11, 1, 100,  10, 1, 'P', null,         null,         null),
       (2019, 12, 1, 100,  10, 2, 'A', '2019-11-03', '2019-11-03', null),
       (2019, 13, 1, 300,  30, 8, 'P', null,         null,         null),
       (2019, 14, 1, 200,  20, 6, 'E', '2019-11-13', null,         null),
       (2019, 15, 1, 200,  20, 6, 'P', null,         null,         null),
       (2019, 16, 1, 200,  20, 6, 'P', null,         null,         null)
go


/*
EJERCICIOS:
   1. Se debe implementar una regla de integridad que controle que haya un solo responsable para cada servicio.
	  Para esto deberá:
	  a. Programar una consulta que devuelva los servicios que tienen una cantidad de responsables distinto de 1
      b. Elaborar una tabla de análisis de operaciones que determine los triggers requeridos para controlar esa RI
	  c. Programar dichos triggers

   2. Programar un procedimiento almacenado que reciba como argumento el nro_servicio y devuelva la lista de personal
      con su disponibilidad o no. 
	  Aquellos que no tengan ninguna orden de trabajo pendiente o en ejecución, estarán disponibles.
	  Los que estén asignados a órdenes de trabajo pendientes o en ejecución, NO estarán disponibles.
	  Para aquellos que estén disponibles mostrar además la fecha en la que finalizaron su última orden de trabajo.
	  Mostrar nro_area, area, nro_personal, nom_personal, disponible (Si o No), fecha_ult_actividad
*/
--Resp
select ps.nro_servicio
	from personal_servicios ps
	where ps.responsable = 'S'
group by ps.nro_servicio
having (count(ps.responsable)) != 1

-----------------------------------------------------------------------------------------------------------------------
--tablas						insert						delete						update
-----------------------------------------------------------------------------------------------------------------------
--personal_servicios			Controlar					----						Controlar
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

create or alter trigger ti_personal_servicios
on personal_servicios
for insert
as
begin
	if exists (select ps.nro_servicio
				from personal_servicios ps
				where ps.responsable = 'S'
			group by ps.nro_servicio
			having (count(ps.responsable)) != 1)
	begin
		raiserror('Ya hay un responsable en este servicio.', 16, 1)
		rollback
	end
end
go

create or alter trigger tu_personal_servicios
on personal_servicios
for update
as
begin
	if exists (select ps.nro_servicio
				from personal_servicios ps
				where ps.responsable = 'S'
			group by ps.nro_servicio
			having (count(ps.responsable)) != 1)
	begin
		raiserror('Ya hay un responsable en este servicio.', 16, 1)
		rollback
	end
end
go

select *
	from personal_areas

select *
	from personal_servicios

insert into personal_servicios (nro_servicio, nro_area, nro_personal, responsable)
values (100, 50, 10, 'N')

update personal_servicios
set responsable = 'S'
where nro_servicio = 100 and nro_area = 50 and nro_personal = 10




/*2. Programar un procedimiento almacenado que reciba como argumento el nro_servicio y devuelva la lista de personal
      con su disponibilidad o no. 
	  Aquellos que no tengan ninguna orden de trabajo pendiente o en ejecución, estarán disponibles.
	  Los que estén asignados a órdenes de trabajo pendientes o en ejecución, NO estarán disponibles.
	  Para aquellos que estén disponibles mostrar además la fecha en la que finalizaron su última orden de trabajo.
	  Mostrar nro_area, area, nro_personal, nom_personal, disponible (Si o No), fecha_ult_actividad*/

create or alter procedure consulta_disponibilidad
(
	@nro_servicio		smallint
)
as
begin
	/*select ps.nro_area, a.area, ps.nro_personal, pa.nom_personal, ot.estado, ot.fecha_fin
		from personal_servicios ps
			join ordenes_trabajo ot
				on ps.nro_servicio = ot.nro_servicio
				and ps.nro_area = ot.nro_area
				and ps.nro_personal = ot.nro_personal
					join areas a
						on a.nro_area = ps.nro_area
							join personal_areas pa
								on pa.nro_area = ps.nro_area
								and pa.nro_personal = ps.nro_personal*/

	declare		@nro_area		smallint,
				@area			varchar(40),
				@nro_personal	smallint,
				@nom_personal	varchar(40),
				@estado			char(1),
				@fecha_fin		date,

				@disponibilidad	char(2),
				@cantidad_p_e	smallint,
				@nro_area_p		smallint,
				@nro_personal_p	smallint,
				@fecha_fin_p	date,
				@area_p			varchar(40),
				@nom_personal_p	varchar(40)


	declare @resultados table
	(
		nro_area			smallint,
		area				varchar(40),
		nro_personal		smallint,
		nom_personal		varchar(40),
		disponible			char(2),
		fecha_ult_actividad	date
	)

	declare cur cursor for
	select ps.nro_area, a.area, ps.nro_personal, pa.nom_personal, ot.estado, ot.fecha_fin
		from personal_servicios ps
			join ordenes_trabajo ot
				on ps.nro_servicio = ot.nro_servicio
				and ps.nro_area = ot.nro_area
				and ps.nro_personal = ot.nro_personal
					join areas a
						on a.nro_area = ps.nro_area
							join personal_areas pa
								on pa.nro_area = ps.nro_area
								and pa.nro_personal = ps.nro_personal
		where ps.nro_servicio = @nro_servicio

	open cur
	fetch cur into @nro_area, @area, @nro_personal, @nom_personal, @estado, @fecha_fin

	while @@FETCH_STATUS = 0
	begin
		set @nro_area_p = @nro_area
		set @nro_personal_p = @nro_personal
		set @cantidad_p_e = 0
		set @fecha_fin_p = @fecha_fin
		set @area_p = @area
		set @nom_personal_p = @nom_personal

		while @@FETCH_STATUS = 0 and @nro_area = @nro_area_p and @nro_personal = @nro_personal_p
		begin
			if @estado = 'P'
			begin
				set @cantidad_p_e = @cantidad_p_e + 1
			end

			if @estado = 'E'
			begin
				set @cantidad_p_e = @cantidad_p_e + 1
			end

			if @fecha_fin_p < @fecha_fin
			begin
				set @fecha_fin_p = @fecha_fin
			end

			fetch cur into @nro_area, @area, @nro_personal, @nom_personal, @estado, @fecha_fin
		end

		if @cantidad_p_e > 0
		begin
			set @disponibilidad = 'No'
		end

		if @cantidad_p_e = 0
		begin
			set @disponibilidad = 'Si'
		end

		if @disponibilidad = 'No'
		begin
			set @fecha_fin_p = NULL
		end

		insert into @resultados (nro_area, area, nro_personal, nom_personal, disponible, fecha_ult_actividad)
		values (@nro_area_p, @area_p, @nro_personal_p, @nom_personal_p, @disponibilidad, @fecha_fin_p)


	end

	close cur
	deallocate cur


	select *
		from @resultados
end


execute consulta_disponibilidad @nro_servicio = 100

select *  from ordenes_trabajo
	where nro_servicio = 100

















--Resolución
--a.
select ps.nro_servicio
	from personal_servicios ps
where ps.responsable = 'S'
group by ps.nro_servicio
having (COUNT(responsable)) != 1

--b.
---------------------------------------------------------------------------------------------------------------------------------
--tablas								insert								delete								update
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
--personal_servicios					Controlar si ya hay un resp.		----								Controlar si ya hay un resp.
---------------------------------------------------------------------------------------------------------------------------------

create or alter trigger ti_personal_servicios
on personal_servicios
for insert
as
begin
	if exists (select ps.nro_servicio
				from personal_servicios ps
			where ps.responsable = 'S'
			group by ps.nro_servicio
			having (COUNT(responsable)) != 1)
	begin
		raiserror('No se puede ingresar otro responsable.', 16, 1)
		rollback
	end

end
go

create or alter trigger tu_personal_servicios
on personal_servicios
for update
as
begin
	if exists (select ps.nro_servicio
				from personal_servicios ps
			where ps.responsable = 'S'
			group by ps.nro_servicio
			having (COUNT(responsable)) != 1)
	begin
		raiserror('No se puede ingresar otro responsable.', 16, 1)
		rollback
	end

end
go

insert into personal_areas (nro_area, nro_personal, nom_personal)
values (10, 11, 'EMPLEADO 10-11')

--Acá salta el trigger
insert into personal_servicios (nro_servicio, nro_area, nro_personal, responsable)
values (100, 10, 11, 'S')

select * from personal_areas
select * from personal_servicios


--2.
create or alter procedure personal_disponible
(
	@nro_servicio	smallint
)
as
begin
	declare		--@nro_servicio_p			smallint,
				@nro_area				smallint,
				@area					varchar(40),
				@nro_personal			smallint,
				@nom_personal			varchar(40),
				@fecha_fin				date,
				@estado					char(1),

				--@nro_servicio_proc		smallint,
				@nro_area_proc			smallint,
				@area_proc				varchar(40),
				@nro_personal_proc		smallint,
				@nom_personal_proc		varchar(40),
				@cantidad_p_e			smallint,
				@disponibilidad			char(2),
				@fecha_ult_actividad	date


	--Acá van a ir todos los resultados:
	declare @resultados table
	(
		nro_area			smallint,
		area				varchar(40),
		nro_personal		smallint,
		nom_personal		varchar(40),
		disponible			char(2),
		fecha_ult_actividad	date
	)

	declare cur cursor for
	select ps.nro_area, a.area, ps.nro_personal, pa.nom_personal, ot.fecha_fin, ot.estado
		from personal_servicios ps
			join ordenes_trabajo ot
				on ps.nro_servicio = ot.nro_servicio
			   and ps.nro_area = ot.nro_area
			   and ps.nro_personal = ot.nro_personal
				join personal_areas pa
					on pa.nro_area = ps.nro_area
				   and pa.nro_personal = ps.nro_personal
					join areas a
						on a.nro_area = ps.nro_area
		where ps.nro_servicio = @nro_servicio

	--Hay que ir personal por personal para ver si tiene ALGUN estado en P o E
	open cur
		fetch cur into @nro_area, @area, @nro_personal, @nom_personal, @fecha_fin, @estado

		while @@FETCH_STATUS = 0
		begin
			set @nro_area_proc = @nro_area
			set @nro_personal_proc = @nro_personal
			set @area_proc = @area
			set @nom_personal_proc = @nom_personal
			set @cantidad_p_e = 0
			set @fecha_ult_actividad = @fecha_fin

			--Buscando persona por persona:
			while @@FETCH_STATUS = 0 and @nro_area = @nro_area_proc and @nro_personal = @nro_personal_proc
			begin
				if @estado = 'P' or @estado = 'E'
				begin
					set @cantidad_p_e = @cantidad_p_e + 1
				end

				if @fecha_ult_actividad < @fecha_fin
				begin
					set @fecha_ult_actividad = @fecha_fin
				end

				fetch cur into @nro_area, @area, @nro_personal, @nom_personal, @fecha_fin, @estado
			end

			if @cantidad_p_e != 0
			begin
				--No está disponible
				set @disponibilidad = 'No'
			end
			else
			begin
				set @disponibilidad = 'Si'
			end


			insert into @resultados (nro_area, area, nro_personal, nom_personal, disponible, fecha_ult_actividad)
			values (@nro_area_proc, @area_proc, @nro_personal_proc, @nom_personal_proc, @disponibilidad, @fecha_ult_actividad)
		end

		

	close cur
	deallocate cur

	select * from @resultados
end

--El 10-1 no está disponible
--El 10-2 no está disponible
--El 20-4 no está disponible

--El 30-7 sí está disponible



execute personal_disponible @nro_servicio = 100