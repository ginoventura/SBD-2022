/* -----------------------------------------------------------------------------------------------------------------------------------

   INGENIERÍA INFORMÁTICA – SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL Nº 2 - 13/05/2019

   Un Instituto de Capacitación decide sistematizar sus actividades académicas. 
   Del análisis de requerimientos se obtuvo lo siguiente:

   - Para cada curso se requiere:
     - Un código de 4 letras que lo identifica
	 - Denominación del curso
	 - Fecha de inicio
	 - Duración en horas (entre 4 y 48)
	 - Cupo total (entre 10 y 100)
	 - Cupo por grupo (entre 10 y 20) (cupo por grupo debe ser menor o igual al cupo total)
	 - Arancel (con decimales > 0.00)

   - Para cada alumno se requiere:
     - Nro. de legajo (único y > 0)
	 - Nro. de documento de identidad (único)
	 - Apellido
	 - Nombre
	 - Domicilio (no obligatorio) 
	 - Teléfonos

   - Para cada docente se requiere:
     - Nro. de legajo (único y > 0)
	 - Nro. de documento de identidad (único)
	 - Apellido
	 - Nombre

   - Otras consideraciones:
     - Un alumno puede inscribirse en varios cursos, pero solo en un grupo por curso
     - Según la cantidad de inscriptos, el curso se puede dividir en más de un grupo
     - Cada grupo puede estar a cargo de uno o más docentes
     - Cada docente puede estar designado en diferentes grupos
     - Cada grupo se identifica con un nro. correlativo por curso y tiene un horario semanal 
	   determinado que puede incluir uno o más días de la semana. Por ejemplo: lunes de 18 a 21 y sábados de 9 a 12
     - El horario del curso se representa a través del día de la semana (entre 2 y 7), hora de inicio y hora de fin 
	   (usar tipo de dato time), donde la hora de inicio debe ser menor a la de fin)
	 - Si se elimina el grupo, se deben eliminar automáticamente los horarios del mismo

   Se diseñó una base de datos cuyo modelo de datos se adjunta.

-----------------------------------------------------------------------------------------------------------------------------------

   SE SOLICITA:

   1. Programar un script para la creación de todas las tablas con todas las reglas de integridad declarativas (clave primaria,
      claves alternativas, claves foráneas y checks) (20)

   2. Agregar la columna cant_alumnos a la tabla grupos y programar una sentencia de actualización de 
      esa columna (20)

   3. Eliminar los grupos que no tienen alumnos inscriptos y docentes designados (15)

   4. Crear una vista que muestre los grupos con información del curso y la cantidad de alumnos inscriptos (nro_curso, nom_curso,
      cupo_total, cupo_grupo, nro_grupo, cant_alumnos) y programar una consulta, usando la vista, de aquellos grupos que tienen 
	  más cantidad de alumnos que el cupo máximo por grupo
	  NOTA: NO se puede usar la columna cant_alumnos creada en el punto 2 (20)
   
   5. Programar una consulta que muestre los cursos y grupos que se dictan SOLO los días miércoles entre las 17 y las 20 horas 
      (aunque ocupen una parte de ese horario) y que tengan más de 3 alumnos inscriptos (25)
*/

drop table horarios_grupos
drop table alumnos_grupos
drop table docentes_grupos
drop table grupos
drop table docentes
drop table alumnos
drop table cursos
go

create table cursos (
	codigo_curso			char(4)			not null,
	nombre_curso			varchar(25)		not null,
	fecha_inicio_curso		date			not null,
	duracion_curso			smallint		not null,
	cupo_total				smallint		not null,
	cupo_grupo				smallint		not null,
	arancel					decimal(10,2)	not null,

	primary key(codigo_curso),
	check(duracion_curso between 4 and 48),
	check(cupo_total between 10 and 100),
	check(cupo_grupo between 10 and 20),
	check(cupo_grupo <= cupo_total),
	check(arancel > 0.00)
)
go

create table alumnos (
	legajo_alumno			int				not null,
	nro_documento			int				not null,
	apellido				varchar(30)		not null,
	nombre					varchar(50)		not null,
	domicilio				varchar(50)		null,
	telefono				varchar(50)		not null,

	primary key(legajo_alumno),
	check(legajo_alumno > 0),
	unique(nro_documento)
)
go

create table docentes (
	legajo_docente			int				not null,
	nro_documento			int				not null,
	apellido_docente		varchar(40)		not null,
	nombre_docente			varchar(40)		not null,

	primary key(legajo_docente),
	unique(nro_documento)
)
go

create table grupos (
	codigo_curso			char(4)			not null,
	numero_grupo			int				not null,

	primary key(codigo_curso, numero_grupo),
	foreign key(codigo_curso) references cursos(codigo_curso)
)
go

create table docentes_grupos (
	codigo_curso			char(4)			not null,
	legajo_docente			int				not null,
	numero_grupo			int				not null,

	primary key(codigo_curso, legajo_docente),
	foreign key(codigo_curso, numero_grupo) references grupos(codigo_curso, numero_grupo),
	foreign key(legajo_docente)	references docentes(legajo_docente)	
)
go

create table alumnos_grupos (
	codigo_curso			char(4)			not null,
	legajo_alumno			int				not null,
	numero_grupo			int				not null,

	primary key(codigo_curso, legajo_alumno),
	foreign key(codigo_curso, numero_grupo) references grupos(codigo_curso, numero_grupo),
	foreign key(legajo_alumno) references alumnos(legajo_alumno)
)
go

create table horarios_grupos (
	codigo_curso			char(4)			not null,
	numero_grupo			int				not null,
	numero_horario			int				not null,
	dia						smallint		not null,
	hora_inicio				time			not null,
	hora_fin				time			not null,

	primary key(codigo_curso, numero_grupo, numero_horario),
	foreign key(codigo_curso, numero_grupo) references grupos(codigo_curso, numero_grupo) on delete cascade,
	check(dia between 2 and 7),
	check(hora_inicio < hora_fin),
	check(hora_fin > hora_inicio)
)
go

insert into dbo.cursos (codigo_curso, nombre_curso, fecha_inicio_curso, duracion_curso, cupo_total, cupo_grupo, arancel)
values ('CAP1', 'CURSO CAPACITACION 1', '2016-02-01', 40,  15,  10, 1800.00),
       ('CAP2', 'CURSO CAPACITACION 2', '2016-03-15', 48,  22,  14, 2200.00),
       ('CAP3', 'CURSO CAPACITACION 3', '2016-04-20', 40,  38,  20, 1900.00),
       ('CAP4', 'CURSO CAPACITACION 4', '2016-05-10', 40,  14,  11, 2000.00)
go

insert into dbo.alumnos (legajo_alumno, nro_documento, apellido, nombre, domicilio, telefono)
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

insert into dbo.docentes (legajo_docente, nro_documento, apellido_docente, nombre_docente)
values (1, 12022879, 'PEREZ',		'ARIEL'),
       (2, 13098787, 'CORNEJO',		'JAVIER'),
       (3, 22087790, 'PELLEGRINO',	'NORA'),
       (4, 24775995, 'DEMARCO',		'GRACIELA')
go

insert into dbo.grupos (codigo_curso, numero_grupo)
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

insert into dbo.alumnos_grupos (codigo_curso, numero_grupo, legajo_alumno)
values ('CAP1', 1,  1),
       ('CAP1', 1,  2),
       ('CAP1', 1,  3),
       ('CAP1', 1,  4),

       ('CAP1', 2,  5),
       ('CAP1', 2,  6),

       ('CAP2', 1,  7),
       ('CAP2', 1,  8),
       ('CAP2', 1,  9),
       ('CAP2', 1, 10),

       ('CAP2', 2,  1),
       ('CAP2', 2,  3),
       ('CAP2', 2,  4),
       ('CAP2', 2,  6),

       ('CAP3', 2,  1),
       ('CAP3', 2,  2),
       ('CAP3', 2,  5),
       ('CAP3', 2,  6),

       ('CAP4', 3,  3),
       ('CAP4', 3,  8),
       ('CAP4', 3, 10)
go

insert into dbo.docentes_grupos (codigo_curso, legajo_docente, numero_grupo)
values ('CAP1', 1,  1),
       ('CAP1', 2,  2),
       ('CAP1', 3,  1),
       ('CAP2', 4,  3),
       ('CAP2', 1,  2),
       ('CAP2', 2,  2)
go

insert into dbo.horarios_grupos (codigo_curso, numero_grupo, numero_horario, dia, hora_inicio, hora_fin)
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

       ('CAP3', 2, 1, 4, '18:00', '22:00'),

       ('CAP4', 1, 1, 5, '20:00', '22:00'),
       ('CAP4', 1, 2, 6, '20:00', '22:00'),

       ('CAP4', 2, 1, 2, '20:00', '22:00'),
       ('CAP4', 2, 2, 4, '20:00', '21:00'),
       ('CAP4', 2, 3, 6, '20:00', '21:00'),

       ('CAP4', 3, 1, 4, '16:00', '18:00'),

       ('CAP4', 4, 1, 3, '21:00', '23:00'),

       ('CAP4', 5, 1, 4, '11:00', '13:00'),
       ('CAP4', 5, 2, 6, '11:00', '13:00')
go

select * from horarios_grupos
select * from alumnos_grupos
select * from docentes_grupos
select * from grupos
select * from docentes 
select * from cursos
select * from alumnos
go

-- 2) Agregar la columna cant_alumnos a la tabla grupos y programar una sentencia de actualización de esa columna.

alter table grupos add cantidad_alumnos	smallint
go

update g
	set cantidad_alumnos = isnull(c.cupo_grupo,0)
--select g.*,c.codigo_curso,c.cupo_grupo
	from grupos g
		join cursos c
			on g.codigo_curso = c.codigo_curso
go

-- 3) Eliminar los grupos que no tienen alumnos inscriptos y docentes designados.


select * 
	from grupos g

-- select * 
	delete g
	from grupos g
			where (not exists (select *
									from alumnos_grupos a
									where g.codigo_curso = a.codigo_curso
									  and g.numero_grupo = a.numero_grupo)
							   and 
				  (not exists (select * 
									from docentes_grupos d
									where g.codigo_curso = d.codigo_curso
									  and g.numero_grupo = d.numero_grupo)))
go

-- 4) Crear una vista que muestre los grupos con información del curso y la cantidad de alumnos inscriptos (nro_curso, nom_curso,
--    cupo_total, cupo_grupo, nro_grupo, cant_alumnos) y programar una consulta, usando la vista, de aquellos grupos que tienen 
--	  más cantidad de alumnos que el cupo máximo por grupo.
--	  NOTA: NO se puede usar la columna cant_alumnos creada en el punto 2.

create or alter view get_info (codigo_curso, nombre_curso, cupo_total, cupo_grupo, cantidad_alumnos)
	as
	select c.codigo_curso, c.nombre_curso, c.cupo_total, c.cupo_grupo,
		   cantidad_alumnos = isnull((select count(*)
									from alumnos_grupos ag
								  where g.codigo_curso = ag.codigo_curso
								  and g.numero_grupo = ag.numero_grupo),0)
		from grupos g
		join cursos c
			on g.codigo_curso = c.codigo_curso
go

select *
	from get_info g
		where g.cantidad_alumnos > g.cupo_total

-- 5) Programar una consulta que muestre los cursos y grupos que se dictan SOLO los días miércoles entre las 17 y las 
-- 20 horas (aunque ocupen una parte de ese horario) y que tengan más de 3 alumnos inscriptos.

select *
	from grupos g
		join horarios_grupos hg
			on g.codigo_curso = hg.codigo_curso
			and g.numero_grupo = hg.numero_grupo
				join alumnos_grupos a
					on g.codigo_curso = a.codigo_curso
					and g.numero_grupo = a.numero_grupo
		where not exists (select *	
							from horarios_grupos hg1
							where g.codigo_curso = hg1.codigo_curso
							  and g.numero_grupo = hg1.numero_grupo
							  and hg1.dia != 4)
  group by g.codigo_curso, g.numero_grupo, g.cantidad_alumnos
  having count(*)>3
