/* 
-----------------------------------------------------------------------------------------------------------------------------------

   INGENIERÍA INFORMÁTICA – SISTEMAS DE BASES DE DATOS - EJERCICIO SQL

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
	 - Si se modifica la clave primaria del grupo se debe cambiar automáticamente la clave foránea en los horarios del mismo
   Se diseñó una base de datos cuyo modelo de datos se adjunta.

-----------------------------------------------------------------------------------------------------------------------------------

   SE SOLICITA:

   1. Programar un script para la creación de todas las tablas con todas las reglas de integridad declarativas (clave primaria,
      claves alternativas, claves foráneas y checks)

   2. Programar un script con inserción de datos en las tablas creadas

   3. Agregar la columna cant_alumnos a la tabla grupos y programar una sentencia de actualización de 
      esa columna

   4. Eliminar los grupos que no tienen alumnos inscriptos y docentes designados

   5. Programar una consulta que muestre los grupos que tienen más cantidad de alumnos que el cupo máximo por grupo
   
   6. Programar una consulta que muestre los cursos y grupos que se dictan SOLO los días miércoles entre las 17 y las 20 horas 
      (aunque ocupen una parte de ese horario) y que tengan más de 3 alumnos inscriptos

-----------------------------------------------------------------------------------------------------------------------------------
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
	cod_curso			char(4)			not null,
	nom_curso			varchar(30)		not null,
	fecha_inicio		date			not null,
	duracion			smallint		not null,
	cupo_total			smallint		not null,
	cupo_grupo			smallint		not null,
	arancel				decimal(10,2)	not null,

	primary key (cod_curso),
	check (duracion between 4 and 48),
	check (cupo_total between 10 and 100),
	check (cupo_grupo between 10 and 20),
	check (cupo_grupo <= cupo_total),
	check (arancel > 0.00)
)
go

create table alumnos (
	nro_alumno			integer			not null,
	nro_documento		integer			not null,
	apellido_alumno		varchar(30)		not null,
	nom_alumno			varchar(30)		not null,
	domicilio			varchar(50)		null,
	telefono			varchar(20)		not null,

	primary key(nro_alumno),
	check(nro_alumno > 0),
	unique(nro_documento)
)
go

create table docentes (
	nro_docente			integer			not null,
	nro_documento		integer			not null,
	apellido_doc		varchar(30)		not null,
	nom_docente			varchar(30)		not null,

	primary key(nro_docente),
	check(nro_docente > 0),
	unique(nro_documento)
)
go

create table grupos (
	cod_curso			char(4)			not null,
	nro_grupo			integer			not null,

	primary key(cod_curso, nro_grupo),
	foreign key(cod_curso) references cursos(cod_curso)
)
go

create table alumnos_grupos (
	cod_curso			char(4)			not null,
	nro_grupo			integer			not null,
	nro_alumno			integer			not null,

	primary key(cod_curso, nro_grupo, nro_alumno),
	foreign key(cod_curso, nro_grupo) references grupos(cod_curso, nro_grupo),
	foreign key(nro_alumno) references alumnos(nro_alumno)
)
go

create table docentes_grupos (
	cod_curso			char(4)			not null,
	nro_grupo			integer			not null,
	nro_docente			integer			not null,

	primary key(cod_curso, nro_grupo, nro_docente), 
	foreign key(cod_curso, nro_grupo) references grupos(cod_curso, nro_grupo),
	foreign key(nro_docente) references docentes(nro_docente)
)
go

create table horarios_grupos (
	cod_curso			char(4)			not null,
	nro_grupo			integer			not null,
	nro_horario			integer			not null,
	dia					tinyint 		not null,
	hora_inicio			time			not null,
	hora_fin			time			not null,

	primary key(cod_curso, nro_grupo, nro_horario),
	foreign key(cod_curso, nro_grupo) references grupos(cod_curso, nro_grupo),
	check (dia between 1 and 7),
	check(hora_inicio < hora_fin),
	check(hora_fin > hora_inicio)
)
go

drop table dbo.horarios_grupos
drop table dbo.docentes_grupos
drop table dbo.alumnos_grupos
drop table dbo.grupos
drop table dbo.alumnos
drop table dbo.docentes
drop table dbo.cursos
go

create table dbo.cursos 
(
 cod_curso			char(4)			not null,
 nom_curso			varchar(40)		not null,
 fecha_inicio		date			not null,
 fecha_fin			date			not null,
 duracion			tinyint			not null,
 cupo_total			tinyint			not null, 
 cupo_grupo			tinyint			not null,
 arancel 			decimal(7,2)	not	null, 
 constraint PK__cursos__END				primary key (cod_curso),
 constraint CK__cursos__fechas__END		check (fecha_fin >= fecha_inicio),
 constraint CK__cursos__duracion__END	check (duracion between 4 and 48),
 constraint CK__cursos__cupo_total__END check (cupo_total between 10 and 100),
 constraint CK__cursos__cupo_grupo__END check (cupo_grupo between 10 and 20),
 constraint CK__cursos__cupos__END		check (cupo_total >= cupo_grupo),
 constraint CK__cursos__arancel__END	check (arancel > 0.00)
)
go

insert into dbo.cursos (cod_curso, nom_curso, fecha_inicio, fecha_fin, duracion, cupo_total, cupo_grupo, arancel)
values ('CAP1', 'CURSO CAPACITACION 1', '2020-04-01', '2020-04-30', 40,  10, 10, 1800.00),
       ('CAP2', 'CURSO CAPACITACION 2', '2020-04-15', '2020-05-30', 48,  12, 11, 2200.00),
       ('CAP3', 'CURSO CAPACITACION 3', '2020-05-20', '2020-06-10', 40,  10, 10, 1900.00),
       ('CAP4', 'CURSO CAPACITACION 4', '2020-06-10', '2020-07-05', 40,  14, 12, 2000.00)
go
 
create table dbo.docentes
(
 nro_docente		smallint		not null,
 nro_documento		integer			not null,
 apellido			varchar(40)		not null,
 nombre				varchar(40)		not null, 
 constraint PK__docentes__END    primary key (nro_docente),
 constraint UK__docentes__1__END unique(nro_documento)
)
go

insert into dbo.docentes (nro_docente, nro_documento, apellido, nombre)
values (1, 12022879, 'PEREZ',		'ARIEL'),
       (2, 13098787, 'CORNEJO',		'JAVIER'),
       (3, 22087790, 'PELLEGRINO',	'NORA'),
       (4, 24775995, 'DEMARCO',		'GRACIELA')
go

create table dbo.alumnos
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

insert into dbo.alumnos (nro_alumno, nro_documento, apellido, nombre, domicilio, telefonos)
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

create table dbo.grupos
(
 cod_curso			char(4)			not null,
 nro_grupo			tinyint			not null,
 constraint PK__grupos__END            primary key (cod_curso, nro_grupo),
 constraint FK__grupos__cursos__1__END foreign key (cod_curso) references dbo.cursos,
 constraint CK__grupos__nro_grupo__END check (nro_grupo > 0)
)
go

insert into dbo.grupos (cod_curso, nro_grupo)
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

create table dbo.alumnos_grupos
(
 cod_curso			char(4)			not null,
 nro_grupo			tinyint			not null,
 nro_alumno			integer			not null,
 constraint PK__alumnos_grupos__END             primary key (cod_curso, nro_alumno),
 constraint FK__alumnos_grupos__grupos__1__END  foreign key (cod_curso, nro_grupo) references dbo.grupos,
 constraint FK__alumnos_grupos__alumnos__1__END foreign key (nro_alumno) references dbo.alumnos
)
go

insert into dbo.alumnos_grupos (cod_curso, nro_grupo, nro_alumno)
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
       ('CAP2', 2,  6)
go

create table dbo.docentes_grupos
(
 cod_curso			char(4)			not null,
 nro_grupo			tinyint			not null,
 nro_docente		smallint		not null,
 constraint PK__docentes_grupos__END              primary key (cod_curso, nro_grupo, nro_docente),
 constraint FK__docentes_grupos__grupos__1__END   foreign key (cod_curso, nro_grupo) references dbo.grupos,
 constraint FK__docentes_grupos__docentes__1__END foreign key (nro_docente) references dbo.docentes
)
go

insert into dbo.docentes_grupos (cod_curso, nro_grupo, nro_docente)
values ('CAP1', 1,  1),
       ('CAP1', 2,  1),

       ('CAP2', 1,  3),
       ('CAP2', 2,  4),

       ('CAP3', 1,  2),
       ('CAP3', 2,  2)
go

create table dbo.horarios_grupos
(
 cod_curso			char(4)			not null,
 nro_grupo			tinyint			not null,
 nro_horario		tinyint			not null,
 dia				tinyint			not null,
 hora_inicio		time			not null,
 hora_fin   		time			not null,
 constraint PK__horarios_grupos__END              primary key (cod_curso, nro_grupo, nro_horario),
 constraint UK__horarios_grupos__1__END			  unique (cod_curso, nro_grupo, dia, hora_inicio),
 constraint FK__horarios_grupos__grupos__1__END   
            foreign key (cod_curso, nro_grupo) 
            references dbo.grupos
			on delete cascade
			on update cascade,
 constraint CK__horarios_grupos__dia__END		  check (dia between 1 and 7),
 constraint CK__horarios_grupos__horario__END	  check (hora_inicio < hora_fin)
)
go

insert into dbo.horarios_grupos (cod_curso, nro_grupo, nro_horario, dia, hora_inicio, hora_fin)
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

--   3. Agregar la columna cant_alumnos a la tabla grupos y programar una sentencia de actualización de esa columna

select *
from dbo.grupos

select *
from dbo.alumnos_grupos

alter table dbo.grupos
add cant_alumnos tinyint	not null default 0
go

select g.cod_curso, g.nro_grupo, count(ag.nro_alumno)
  from dbo.grupos g
       left join dbo.alumnos_grupos ag
	     on g.cod_curso = ag.cod_curso
		and g.nro_grupo = ag.nro_grupo
 group by g.cod_curso, g.nro_grupo

select g.cod_curso, 
       g.nro_grupo, 
	   (select count(*)
          from dbo.alumnos_grupos ag
	     where g.cod_curso = ag.cod_curso
		   and g.nro_grupo = ag.nro_grupo) cant_alumnos
  from dbo.grupos g

update g
   set cant_alumnos = (select count(*)
                         from dbo.alumnos_grupos ag
	                    where g.cod_curso = ag.cod_curso
		                  and g.nro_grupo = ag.nro_grupo)
--select *
  from dbo.grupos g
 where g.cant_alumnos != (select count(*)
                            from dbo.alumnos_grupos ag
	                       where g.cod_curso = ag.cod_curso
		                     and g.nro_grupo = ag.nro_grupo)


-- 4. Eliminar los grupos que no tienen alumnos inscriptos y docentes designados

select *
--delete g
  from dbo.grupos g
 where not exists (select *
                     from dbo.alumnos_grupos ag
					where g.cod_curso = ag.cod_curso
					  and g.nro_grupo = ag.nro_grupo)
   and not exists (select *
                     from dbo.docentes_grupos dg
					where g.cod_curso = dg.cod_curso
					  and g.nro_grupo = dg.nro_grupo)

select *
--delete g
  from dbo.grupos g
/*
       join dbo.horarios_grupos hg
	     on g.cod_curso = hg.cod_curso
		and g.nro_grupo = hg.nro_grupo
*/
where not exists (select *
                     from dbo.alumnos_grupos ag
					where g.cod_curso = ag.cod_curso
					  and g.nro_grupo = ag.nro_grupo)
   and not exists (select *
                     from dbo.docentes_grupos dg
					where g.cod_curso = dg.cod_curso
					  and g.nro_grupo = dg.nro_grupo)

-- 5. Programar una consulta que muestre los grupos que tienen más cantidad de alumnos que el cupo máximo por grupo

select g.cod_curso, g.nro_grupo, c.cupo_grupo, count(ag.nro_alumno)
  from dbo.grupos g
       join dbo.cursos c
	     on g.cod_curso = c.cod_curso
       left join dbo.alumnos_grupos ag
	     on g.cod_curso = ag.cod_curso
		and g.nro_grupo = ag.nro_grupo
 group by g.cod_curso, g.nro_grupo, c.cupo_grupo
having c.cupo_grupo > count(ag.nro_alumno)

select g.cod_curso, 
       g.nro_grupo, 
	   c.cupo_grupo, 
	   (select count(*)
          from dbo.alumnos_grupos ag
	     where g.cod_curso = ag.cod_curso
		   and g.nro_grupo = ag.nro_grupo)
  from dbo.grupos g
       join dbo.cursos c
	     on g.cod_curso = c.cod_curso
 where c.cupo_grupo > (select count(*)
                         from dbo.alumnos_grupos ag
	                    where g.cod_curso = ag.cod_curso
		                  and g.nro_grupo = ag.nro_grupo)






