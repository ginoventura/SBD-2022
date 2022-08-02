/* -----------------------------------------------------------------------------------------------------------------------------------
   INGENIERÍA INFORMÁTICA – SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL RECUPERATORIA Nº 3 - 03/07/2020

   Un Instituto de Capacitación decide sistematizar sus actividades académicas. 
   Del análisis de requerimientos se obtuvo lo siguiente:

   - Cada curso se identifica por un código de 4 letras, y se requiere como información su nombre, fecha de inicio, duración en horas, cupo total, cupo por grupo y arancel.
   - Cada alumno se describe por un legajo (único), nro. de documento (único), apellido, nombre, domicilio y teléfonos.
   - Un alumno puede inscribirse en varios cursos, pero solo en un grupo por curso.
   - Según la cantidad de inscriptos el curso se puede dividir en más de un grupo.
   - Cada grupo puede estar a cargo de uno o más docentes
   - Los docentes se definen a través de un número de legajo (único),  apellido, nombre y nro. de documento (único).
   - Cada docente puede estar designado en diferentes grupos
   - Cada grupo tiene un horario semanal determinado que puede incluir uno o más días de la semana. Por ejemplo: lunes de 18 a 21 y sábados de 9 a 12.
   - El horario del curso se representa a través del día de la semana, hora de inicio y hora de fin. 

   Se diseñó una base de datos cuyo modelo de datos se adjunta.
   Se implementó a través del script siguiente:
*/

drop table horarios_grupos
drop table docentes_grupos
drop table alumnos_grupos
drop table grupos
drop table alumnos
drop table docentes
drop table cursos
go

create table cursos 
(
 cod_curso			char(4)			not null,
 nom_curso			varchar(40)		not null,
 fecha_inicio		date			not null, 
 duracion			smallint		not null,
 cupo_total			smallint		not null, 
 cupo_grupo			tinyint			not null,
 arancel 			decimal(7,2)	not	null, 
 constraint PK__cursos__END           primary key (cod_curso),
 constraint CK__cursos__duracion__END check (duracion > 0),
 constraint CK__cursos__cupos__END    check (cupo_total > 0 and cupo_grupo > 0 and cupo_total >= cupo_grupo),
 constraint CK__cursos__arancel__END  check (arancel > 0.00)
)
go

insert into cursos (cod_curso, nom_curso, fecha_inicio, duracion, cupo_total, cupo_grupo, arancel)
values ('CAP1', 'CURSO CAPACITACION 1', '2016-02-01', 40,  10,  5, 18000.00),
       ('CAP2', 'CURSO CAPACITACION 2', '2016-03-15', 60,  12,  4, 22000.00),
       ('CAP3', 'CURSO CAPACITACION 3', '2016-04-20', 40,   8,  4, 19000.00),
       ('CAP4', 'CURSO CAPACITACION 4', '2016-05-10', 40,  14,  7, 20000.00)
go
 
create table docentes
(
 nro_docente		smallint		not null,
 nro_documento		integer			not null,
 apellido			varchar(40)		not null,
 nombre				varchar(40)		not null, 
 constraint PK__docentes__END    primary key (nro_docente),
 constraint UK__docentes__1__END unique(nro_documento)
)
go

insert into docentes (nro_docente, nro_documento, apellido, nombre)
values (1, 12022879, 'PEREZ',		'ARIEL'),
       (2, 13098787, 'CORNEJO',		'JAVIER'),
       (3, 22087790, 'PELLEGRINO',	'NORA'),
       (4, 24775995, 'DEMARCO',		'GRACIELA')
go

create table alumnos
(
 nro_alumno			integer			not null,
 nro_documento		integer			not null,
 apellido			varchar(40)		not null,
 nombre				varchar(40)		not null,
 domicilio			varchar(255)	not null,
 telefonos			varchar(100)	not null, 
 constraint PK__alumnos__END    primary key (nro_alumno),
 constraint UK__alumnos__1__END unique(nro_documento)
)
go

insert into alumnos (nro_alumno, nro_documento, apellido, nombre, domicilio, telefonos)
values ( 1, 12133879, 'TORRES',			'ALBERTO',		'SAN MARTIN 145 - CÓRDOBA',			'351-3455566'),
       ( 2, 14655787, 'BARROSO',		'CARLOS',		'INDEPENDENCIA 889 - CÓRDOBA',		'351-4345667'),
       ( 3, 13556790, 'SARMIENTO',		'DORIS',		'AV. BELGRANO 1123 - BUENOS AIRES', '11-43455678'),
       ( 4, 20323333, 'PAREDES',		'ALEJANDRA',	'OBISPO TREJO 112 - SANTA FE',		'342-4567754'),
       ( 5, 21345677, 'REYNOSO',		'DARIO',		'DEAN FUNES 5533 - ROSARIO',		'341-4647789'),
       ( 6, 12546466, 'MONTERO',		'HECTOR',		'AV. RIVADAVIA 451 - CÓRDOBA',		'351-4322346'),
       ( 7, 34444321, 'LUDUEÑA',		'MARINA',		'MITRE 123 - MENDOZA',				'391-4154667'),
       ( 8, 25678334, 'GUERRERO',		'PAOLA',		'AV. GENERAL PAZ 6777 - SAN JUAN',	'392-3436667'),
       ( 9, 11347899, 'FERRERO',		'FRANCO',       'VELEZ SARSFIELD 1223 - CÓRDOBA',	'351-2252366'),
       (10, 10298969, 'GUTIERREZ',		'BEATRIZ',      'AV. ILLIA 456 - CÓRDOBA',			'351-5578899')
go

create table grupos
(
 cod_curso			char(4)			not null,
 nro_grupo			tinyint			not null,
 constraint PK__grupos__END            primary key (cod_curso, nro_grupo),
 constraint FK__grupos__cursos__1__END foreign key (cod_curso) references cursos,
 constraint CK__grupos__nro_grupo__END check (nro_grupo > 0)
)
go

insert into grupos (cod_curso, nro_grupo)
values ('CAP1', 1),
       ('CAP1', 2),
       ('CAP2', 1),
       ('CAP2', 2),
       ('CAP2', 3),
       ('CAP3', 1),
       ('CAP3', 2),
       ('CAP4', 1),
       ('CAP4', 2),
       ('CAP4', 3),
       ('CAP4', 4),
       ('CAP4', 5)
go

create table alumnos_grupos
(
 cod_curso			char(4)			not null,
 nro_grupo			tinyint			not null,
 nro_alumno			integer			not null,
 confirmado			char(1)			not null,
 constraint PK__alumnos_grupos__END             primary key (cod_curso, nro_alumno),
 constraint FK__alumnos_grupos__grupos__1__END  foreign key (cod_curso, nro_grupo) references grupos,
 constraint FK__alumnos_grupos__alumnos__1__END foreign key (nro_alumno) references alumnos,
 constraint CK__alumnos_grupos__confirmado__END check (confirmado in ('S','N'))
)
go

insert into alumnos_grupos (cod_curso, nro_grupo, nro_alumno, confirmado)
values ('CAP1', 1,  1, 'S'),
       ('CAP1', 1,  2, 'S'),
       ('CAP1', 1,  3, 'S'),
       ('CAP1', 1,  4, 'S'),

       ('CAP1', 2,  5, 'S'),
       ('CAP1', 2,  6, 'S'),

       ('CAP2', 1,  7, 'S'),
       ('CAP2', 1,  8, 'S'),
       ('CAP2', 1,  9, 'N'),
       ('CAP2', 1, 10, 'S'),

       ('CAP2', 2,  1, 'N'),
       ('CAP2', 2,  3, 'S'),
       ('CAP2', 2,  4, 'S'),
       ('CAP2', 2,  6, 'S')
go

create table docentes_grupos
(
 cod_curso			char(4)			not null,
 nro_grupo			tinyint			not null,
 nro_docente		smallint		not null,
 constraint PK__docentes_grupos__END              primary key (cod_curso, nro_grupo, nro_docente),
 constraint FK__docentes_grupos__grupos__1__END   foreign key (cod_curso, nro_grupo) references grupos,
 constraint FK__docentes_grupos__docentes__1__END foreign key (nro_docente) references docentes
)
go

insert into docentes_grupos (cod_curso, nro_grupo, nro_docente)
values ('CAP1', 1,  1),
       ('CAP1', 1,  2),

       ('CAP1', 2,  1),

       ('CAP2', 1,  3),
       ('CAP2', 1,  4),

       ('CAP2', 1,  2)
go

create table horarios_grupos
(
 cod_curso			char(4)			not null,
 nro_grupo			tinyint			not null,
 nro_horario		tinyint			not null,
 dia				tinyint			not null,
 hora_inicio		time			not null,
 hora_fin   		time			not null,
 constraint PK__horarios_grupos__END              primary key (cod_curso, nro_grupo, nro_horario),
 constraint UK__horarios_grupos__1__END			  unique (cod_curso, nro_grupo, dia, hora_inicio),
 constraint FK__horarios_grupos__grupos__1__END   foreign key (cod_curso, nro_grupo) references grupos,
 constraint CK__horarios_grupos__dia__END		  check (dia between 1 and 7),
 constraint CK__horarios_grupos__horario__END	  check (hora_inicio < hora_fin)
)
go

insert into horarios_grupos (cod_curso, nro_grupo, nro_horario, dia, hora_inicio, hora_fin)
values ('CAP1', 1, 1, 2, '08:00', '10:00'),
       ('CAP1', 1, 2, 4, '08:00', '10:00'),

       ('CAP1', 2, 1, 3, '13:00', '15:00'),
       ('CAP1', 2, 2, 5, '13:00', '15:00'),

       ('CAP2', 1, 1, 6, '18:00', '20:00'),
       ('CAP2', 1, 2, 7, '09:00', '11:00'),

       ('CAP2', 2, 1, 5, '10:00', '12:00'),
       ('CAP2', 2, 2, 7, '10:00', '12:00'),

       ('CAP2', 3, 1, 2, '08:00', '09:00'),
       ('CAP2', 3, 2, 4, '15:00', '17:00'),
       ('CAP2', 3, 3, 6, '19:00', '20:00'),

       ('CAP3', 1, 1, 2, '19:00', '21:00'),
       ('CAP3', 1, 2, 3, '20:00', '22:00'),

       ('CAP3', 2, 1, 3, '17:00', '19:00'),
       ('CAP3', 2, 2, 4, '18:00', '19:00'),
       ('CAP3', 2, 3, 5, '18:00', '19:00'),

       ('CAP4', 1, 1, 5, '20:00', '22:00'),
       ('CAP4', 1, 2, 6, '20:00', '22:00'),

       ('CAP4', 2, 1, 2, '20:00', '22:00'),
       ('CAP4', 2, 2, 4, '20:00', '21:00'),
       ('CAP4', 2, 3, 6, '20:00', '21:00'),

       ('CAP4', 3, 1, 2, '08:00', '10:00'),
       ('CAP4', 3, 2, 5, '08:00', '10:00'),

       ('CAP4', 4, 1, 3, '10:00', '12:00'),
       ('CAP4', 4, 2, 6, '10:00', '12:00'),

       ('CAP4', 5, 1, 4, '11:00', '13:00'),
       ('CAP4', 5, 2, 6, '11:00', '13:00')
go

/*
EJERCICIOS:
   1. Se debe implementar una regla de integridad que controle que la cantidad de inscriptos confirmados en cada grupo sea menor o
      igual al cupo del grupo (definido en la columna cupo_grupo de la tabla cursos)
	  Para esto deberá:
	  a. Programar una consulta que devuelva los grupos que tienen más alumnos que el cupo máximo
	  b. Elaborar una tabla de análisis de operaciones que determine los triggers requeridos para controlar esa RI
	  c. Programar dichos triggers

   2. Programar un procedimiento almacenado que reciba como argumentos:
      - Hora mínima de inicio
	  - Cantidad máxima de días a la semana
      y muestre los grupos de cursos que tengan cupo disponible (menos alumnos inscriptos que la cantidad permitida según el cupo), 
	  que no tengan hora de inicio menor a la informada en ninguno de sus horarios y que la cantidad de días por semana que se
	  curse no sea mayor a la informada.
	  
*/

--1
--a

select  a.nro_grupo, a.cod_curso,c.cupo_total, count(*) as cant_alumnos
	from alumnos_grupos a
		join cursos c
		 on a.cod_curso = c.cod_curso
  where a.confirmado = 'S'
  group by a.nro_grupo, a.cod_curso,c.cupo_total
  having(count(*) > c.cupo_total)
  



--b

------------------------------------------------------------------------------------------------------------------------
--	tabla						insert						delete						update
------------------------------------------------------------------------------------------------------------------------
--	alumnos_grupos				controlar					------						controlar
------------------------------------------------------------------------------------------------------------------------
--	cursos						--------					------						no permitir
------------------------------------------------------------------------------------------------------------------------

--c

create or alter trigger tiu_ri_alumnos_grupos
on alumnos_grupos
for insert,update
as
begin
	if exists(select  a.nro_grupo, a.cod_curso,c.cupo_total, count(*) as cant_alumnos
					from alumnos_grupos a
						join cursos c
						 on a.cod_curso = c.cod_curso
				  where a.confirmado = 'S'
				  group by a.nro_grupo, a.cod_curso,c.cupo_total
				  having(count(*) > c.cupo_total))
	begin
		raiserror('La cantidad de inscriptos confirmados en cada grupo debe ser menor o igual al cupo del grupo', 16,1)
		rollback
	end
end

create or alter trigger tu_ri_cursos
on cursos
for update
as
begin
	if update(cupo_total)
	begin
		raiserror('No se puede modificar el cupo de los cursos.', 16, 1)
		rollback
	end
end




/*
   2. Programar un procedimiento almacenado que reciba como argumentos:
      - Hora mínima de inicio
	  - Cantidad máxima de días a la semana
      y muestre los grupos de cursos que tengan cupo disponible (menos alumnos inscriptos que la cantidad permitida según el cupo), 
	  que no tengan hora de inicio menor a la informada en ninguno de sus horarios y que la cantidad de días por semana que se
	  curse no sea mayor a la informada.
*/


create or alter procedure info_grupos_cursos
(
	@hora_min_inicio	time,
	@cant_max_dias_s	smallint
)
as
begin
		select  a.nro_grupo, a.cod_curso,c.cupo_total, count(*) as cant_alumnos
			from alumnos_grupos a
				join cursos c
					 on a.cod_curso = c.cod_curso
		  where (not exists(select *
								from horarios_grupos h
							where a.cod_curso = h.cod_curso
							and a.nro_grupo = h.nro_grupo
							and h.hora_inicio < @hora_min_inicio))
				and 
				(not exists (select h.cod_curso, h.nro_grupo, count(*) as cant_dias
								from horarios_grupos h
							  where a.cod_curso = h.cod_curso
							  and a.nro_grupo = h.nro_grupo
							  group by h.cod_curso, h.nro_grupo
							  having (count(*)> @cant_max_dias_s)))
		  group by a.nro_grupo, a.cod_curso,c.cupo_total
		  having(count(*) < c.cupo_total)
end

execute info_grupos_cursos @hora_min_inicio = '7:00', @cant_max_dias_s = 2

-----------------------------------------------------------------------------------------------------