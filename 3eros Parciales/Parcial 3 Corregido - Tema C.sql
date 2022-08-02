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
 horas_totales			smallint		null,
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



SET DATEFORMAT dmy;
insert into solicitudes (año_solicitud, nro_solicitud, fecha_solicitud, nro_area_solicita, nro_personal_solicita, nro_servicio, fecha_entrega, horas_totales)
values (2017,  1, '27-01-2019 10:00', 10, 1, 200, null, null),
       (2017,  2, '27-02-2019 10:00', 20, 1, 200, null, null),
       (2017,  3, '27-03-2019 10:00', 20, 4, 300, null, null),
       (2017,  4, '27-04-2019 10:00', 40, 2, 300, null, null),
       (2017,  5, '27-05-2019 10:00', 50, 1, 100, null, null)

insert into solicitudes (año_solicitud, nro_solicitud, fecha_solicitud, nro_area_solicita, nro_personal_solicita, nro_servicio, fecha_entrega, horas_totales)
values (2018,  1, '28-01-2019 10:00', 10, 1, 100, null, null),
       (2018,  2, '28-02-2019 10:00', 30, 8, 100, null, null),
       (2018,  3, '28-03-2019 10:00', 40, 9, 300, null, null),
       (2018,  4, '28-04-2019 10:00', 40, 9, 200, null, null),
       (2018,  5, '28-05-2019 10:00', 40, 9, 200, null, null)

insert into solicitudes (año_solicitud, nro_solicitud, fecha_solicitud, nro_area_solicita, nro_personal_solicita, nro_servicio, fecha_entrega, horas_totales)
values (2019,  1, '10-01-2019 10:00', 10, 1, 100, null, null),
       (2019,  2, '20-02-2019 10:00', 30, 8, 200, null, null),
       (2019,  3, '30-03-2019 10:00', 40, 9, 300, null, null),
       (2019,  4, '10-04-2019 10:00', 40, 9, 300, null, null),
       (2019,  5, '20-05-2019 10:00', 50, 5, 100, null, null),
       (2019,  6, '30-06-2019 10:00', 10, 1, 100, null, null),
       (2019,  7, '10-07-2019 10:00', 10, 3, 100, null, null),
       (2019,  8, '20-08-2019 10:00', 10, 3, 300, null, null),
       (2019,  9, '30-09-2019 10:00', 20, 6, 200, null, null),
       (2019, 10, '10-10-2019 10:00', 50,10, 200, null, null),
       (2019, 11, '20-11-2019 10:00', 50, 1, 100, null, null),
       (2019, 12, '20-12-2019 10:00', 50, 5, 100, null, null),
       (2019, 13, '20-12-2019 10:00', 50,10, 300, null, null),
       (2019, 14, '25-12-2019 10:00', 20, 4, 200, null, null),
       (2019, 15, '30-12-2019 10:00', 40, 4, 200, null, null),
       (2019, 16, '30-12-2019 10:00', 20, 5, 200, null, null)
go

insert into ordenes_trabajo (año_solicitud, nro_solicitud, nro_orden_trabajo, nro_servicio, nro_area, nro_personal, estado, fecha_inicio, fecha_fin, horas_totales)
values (2017,  1, 1, 200,  20, 5, 'F', '30-01-2017', '11-03-2017', 620),
       (2017,  1, 2, 200,  20, 6, 'F', '31-01-2017', '02-02-2017', 30),
       (2017,  2, 1, 200,  20, 6, 'P', null,         null,         null),
       (2017,  3, 1, 300,  30, 8, 'A', '01-03-2017', '01-03-2017', null),
       (2017,  4, 1, 300,  30, 8, 'E', '01-05-2017', null,         null),
       (2017,  5, 1, 100,  10, 1, 'F', '27-04-2017', '12-05-2017', 150)

insert into ordenes_trabajo (año_solicitud, nro_solicitud, nro_orden_trabajo, nro_servicio, nro_area, nro_personal, estado, fecha_inicio, fecha_fin, horas_totales)
values (2018,  1, 1, 100,  10, 1, 'P', null,         null,         null),
       (2018,  1, 2, 100,  10, 2, 'F', '01-03-2018', '15-03-2018', 140),
       (2018,  1, 3, 100,  30, 7, 'F', '01-04-2018', '30-04-2018', 360),
       (2018,  2, 1, 100,  20, 4, 'A', '01-06-2018', '01-06-2018', 120),
       (2018,  3, 1, 300,  30, 8, 'E', '01-06-2018', null,         null),
       (2018,  4, 1, 200,  20, 5, 'F', '29-08-2018', '31-08-2018', 10),
       (2018,  5, 1, 200,  20, 6, 'F', '12-09-2018', '22-09-2018', 350)

SET DATEFORMAT ymd;
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
   1. Se debe implementar una regla de integridad que controle que el personal asignado a cada servicio debe 
      pertenecer al área responsable del servicio.
	  Para esto deberá:
	  a. Programar una consulta que devuelva el personal de cada servicio que no pertenece al área responsable 
	     del servicio
      b. Elaborar una tabla de análisis de operaciones que determine los triggers requeridos para controlar esa RI
	  c. Programar dichos triggers

   2. Programar un procedimiento almacenado que actualice la cantidad de horas totales y la fecha de entrega de la 
      solicitud (solo en el caso de que TODAS sus órdenes de trabajo estén finalizadas y/o anuladas). 
	  La fecha de entrega de la solicitud será la máxima fecha de finalización de todas sus órdenes de trabajo.
	  Para el cálculo de la cantidad de horas, suponer 0 horas para las órdenes de trabajo anuladas.

      NOTA: Una posible lógica para la solución podría ser la de crear un cursor con las solicitudes que tengan
	  todas sus órdenes de trabajo finalizadas y/o anuladas y luego para cada fila de ese cursor, obtener la 
	  máxima fecha de finalización de sus órdenes y la suma de las horas totales de sus órdenes, y actualice
	  la fecha de entrega y horas_totales en la solicitud.
	  
*/

--Resolución
--1.
--Hay que ver si el personal que se inserta en personal_servicios, realmente pertenece al area del servicio responsable.
--Personal:
select * 
	from dbo.personal_servicios ps
--Areas responsables por servicio:
select *
	from dbo.servicios

update servicios
set nro_area_responsable = 10
from servicios
where nro_servicio = 100

--a.
select *
	from dbo.personal_servicios	ps
		join dbo.servicios s
			on ps.nro_servicio = s.nro_servicio
where ps.nro_area != s.nro_area_responsable



---------------------------------------------------------------------------------------------------------------------------------
--tabla								insert											delete						update
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
--personal_servicios				controlar que pertenezca al area				----						Controlar que
--																												pertenezca al area
--																												cuando se cambia.
---------------------------------------------------------------------------------------------------------------------------------
--servicios							No tiene personal_servicios						No permitir porque sino 	No dejaría porque si tienen personal asignado
--									vinculados. Nada.								quedan personal_servicios	se romperia todo lo otro.
--																					sin servicios. A parte FK.
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

create trigger ti_personal_servicios
on dbo.personal_servicios
for insert
as
begin

	if exists (select *
				from inserted ps
					join dbo.servicios s
						on ps.nro_servicio = s.nro_servicio
			where ps.nro_area != s.nro_area_responsable)
	begin
		raiserror('No coinciden el número de área del servicio con el número de área responsable de ese servicio.', 16, 1)
		rollback
	end

end
go

create trigger tu_personal_servicios
on dbo.personal_servicios
for update
as
begin
	if exists (select *
				from inserted ps
					join dbo.servicios s
						on ps.nro_servicio = s.nro_servicio
			where ps.nro_area != s.nro_area_responsable)
	begin
		raiserror('No coinciden el número de área del servicio con el número de área responsable de ese servicio.', 16, 1)
		rollback
	end

end
go

--No haría falta porque la FK no nos dejaría, si es que hay un personal asignado a ese servicio.
create trigger td_servicios
on dbo.servicios
for delete
as
begin
	raiserror('No se puede eliminar un servicio.', 16, 1)
	rollback
end
go


create trigger tu_servicios
on dbo.servicios
for update
as
begin
	if UPDATE(nro_area_responsable)
	begin
		raiserror('No se puede.', 16, 1)
		rollback
	end
end
go



/*2. Programar un procedimiento almacenado que actualice la cantidad de horas totales y la fecha de entrega de la 
      solicitud (solo en el caso de que TODAS sus órdenes de trabajo estén finalizadas y/o anuladas). 
	  La fecha de entrega de la solicitud será la máxima fecha de finalización de todas sus órdenes de trabajo.
	  Para el cálculo de la cantidad de horas, suponer 0 horas para las órdenes de trabajo anuladas.

      NOTA: Una posible lógica para la solución podría ser la de crear un cursor con las solicitudes que tengan
	  todas sus órdenes de trabajo finalizadas y/o anuladas y luego para cada fila de ese cursor, obtener la 
	  máxima fecha de finalización de sus órdenes y la suma de las horas totales de sus órdenes, y actualice
	  la fecha de entrega y horas_totales en la solicitud.*/

--2.
--Hay que actualizar horas totales y fecha en SOLICITUDES si es que sus ÓRDENES estan FINALIZADAS o ANULADAS.
--La FECHA_ENTREGA de la SOLICITUD	 es la maxima fecha de finalizacion de TODAS SUS ORDENES DE TRABAJO.
--Las ANULADAS, las horas son 0.

select *
	from solicitudes sol
		join ordenes_trabajo ot
			on sol.nro_solicitud = ot.nro_solicitud
		   and sol.año_solicitud = ot.año_solicitud
	where ot.estado = 'F' or ot.estado = 'A'

select * 
	from ordenes_trabajo
	order by año_solicitud, nro_solicitud
select *
	from solicitudes
	order by año_solicitud, nro_solicitud

update solicitudes
set fecha_entrega = null, horas_totales = null
from solicitudes

create or alter procedure dbo.actualizar
as
begin
	
	--Solicitud con todas sus ordenes finalizadas y/o anuladas:
	/*select *
		from dbo.solicitudes sol
			join dbo.ordenes_trabajo ot
				on sol.nro_solicitud = ot.nro_solicitud
			   and sol.año_solicitud = ot.año_solicitud
	where ot.estado = 'A' or ot.estado = 'F'*/


	declare		@año_solicitud_s			smallint,
				@nro_solicitud_s			smallint,
				@fecha_solicitud_s			smalldatetime,
				@nro_area_solicitada_s		smallint,
				@nro_personal_solicita_s	smallint,
				@nro_servicio_s				smallint,
				@fecha_entrega_s			date,
				@horas_totales_s			smallint,

				@año_solicitud_ot			smallint,
				@nro_solicitud_ot			smallint,
				@nro_orden_trabajo_ot		tinyint,
				@nro_servicio_ot			smallint,
				@nro_area_ot				smallint,
				@nro_personal_ot			smallint,
				@estado_ot					char(1),
				@fecha_inicio_ot			date,
				@fecha_fin_ot				date,
				@horas_totales_ot			smallint,

				@maxima_fecha_fin			date,
				@horas_totales_ordenes		integer


	--Cursor:
	declare cur cursor for
	select sol.año_solicitud, sol.nro_solicitud, ot.fecha_fin, ot.horas_totales
	from solicitudes sol
		join ordenes_trabajo ot
			on sol.nro_solicitud = ot.nro_solicitud
		   and sol.año_solicitud = ot.año_solicitud
	where ot.estado = 'F' or ot.estado = 'A'

	open cur
		fetch cur into @año_solicitud_s, @nro_solicitud_s,
		@fecha_fin_ot, @horas_totales_ot
		
		while @@fetch_status = 0
		begin
			set @maxima_fecha_fin = @fecha_fin_ot
			set @horas_totales_ordenes = 0
			set @nro_solicitud_ot = @nro_solicitud_s
			set @año_solicitud_ot = @año_solicitud_s

			while @@fetch_status = 0 and @año_solicitud_s = @año_solicitud_ot and @nro_solicitud_s = @nro_solicitud_ot
				begin
					--Buscamos la máxima fecha de finalización:
					if @maxima_fecha_fin < @fecha_fin_ot
						begin
							set @maxima_fecha_fin = @fecha_fin_ot
						end
					--Vamos sumando las horas totales de cada orden:
					set @horas_totales_ordenes = @horas_totales_ordenes + isnull(@horas_totales_ot, 0)

					

					fetch cur into @año_solicitud_s, @nro_solicitud_s,
					@fecha_fin_ot, @horas_totales_ot
				end


				update dbo.solicitudes
					set fecha_entrega = @maxima_fecha_fin, horas_totales = @horas_totales_ordenes
					where nro_solicitud = @nro_solicitud_ot and año_solicitud = @año_solicitud_ot
		end

	close cur
	deallocate cur
end
go

execute dbo.actualizar
go

select * from solicitudes


select *
	from solicitudes sol
		join ordenes_trabajo ot
			on sol.nro_solicitud = ot.nro_solicitud
		   and sol.año_solicitud = ot.año_solicitud
	where ot.estado = 'F' or ot.estado = 'A'