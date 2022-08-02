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
 constraint CK__personal_servicios_responsable__END
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

select * from ordenes_trabajo
select * from solicitudes
select * from personal_servicios
select * from servicios
select * from personal_areas
select * from areas
go

-- Mostrar para cada área, las horas trabajadas por todo su personal, por cada año, entre el 2017 y el 2019, teniendo en cuenta solo las
-- órdenes de trabajo finalizadas. El resultado debe estar completo, es decir, si un área en un año no tiene horas trabajadas, entonces mostrar 0.
-- El formato es el siguiente:
/*     NRO_AREA NOM_AREA	AÑO  HORAS
      -------- ------------ ---- -----
         10	   AREA 10		2017	56
         10	   AREA 10		2018   142
         10	   AREA 10		2019	14
         20	   AREA 20		2017	 0
         20	   AREA 20		2018	28
         20	   AREA 20		2019	 0
		 ordenar por nom_area y año
*/

select a.nro_area, a.area, ot.año_solicitud as año, sum(ot.horas_totales) as horas 
	from areas a
		join ordenes_trabajo ot
			on a.nro_area = ot.nro_area
		where estado = 'F'
			group by a.nro_area, a.area, ot.año_solicitud
		order by a.area, año
go

-- Mostrar para cada empleado la cantidad de órdenes de trabajo finalizadas, pendientes y en ejecución.
-- El resultado debe estar completo, es decir, si un empleado no tiene órdenes de trabajo en ninguno de esos estados, se lo debe agregar
-- con valores 0 para cada uno de esos totales. El formato es el siguiente: 
/*   NRO_AREA NRO_EMPLEADO	NOM_EMPLEADO	FINALIZADAS	PENDIENTES EN EJECUCION
      -------- ------------ ------------    ----------- ---------- ------------
         10         1       EMPLEADO 10-1		7			2			0
         10         2       EMPLEADO 10-2		1			0			4
         10         3       EMPLEADO 10-3		0			0			0
						ordenar por nom_empleado y nro_area
*/

select ot.nro_area, pa.nro_personal, pa.nom_personal, 
	finalizadas = count(case when ot.estado = 'F' then 1 else null end),
	pendientes = count(case when ot.estado = 'P' then 1 else null end),
	en_ejecucion = count(case when ot.estado = 'E' then 1 else null end)
	from ordenes_trabajo ot
		join personal_areas pa
			on ot.nro_personal = pa.nro_personal
		   and ot.nro_area = pa.nro_area
	where ot.estado in ('F','P','E')
	group by ot.nro_area, pa.nro_personal, pa.nom_personal
	order by pa.nom_personal, ot.nro_area
go

select * from ordenes_trabajo
select * from solicitudes
select * from personal_servicios
select * from servicios
select * from personal_areas
select * from areas
go
