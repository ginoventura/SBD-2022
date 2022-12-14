/* -----------------------------------------------------------------------------------------------------------------------------------
   INGENIER?A INFORM?TICA ? SISTEMAS DE BASES DE DATOS - EVALUACI?N PARCIAL RECUPERATORIA N? 2 - 03/07/2020

   Un Instituto de Capacitaci?n decide sistematizar sus actividades acad?micas. 
   Del an?lisis de requerimientos se obtuvo lo siguiente:

   - Cada curso se identifica por un c?digo de 4 letras, y se requiere como informaci?n su nombre, fecha de inicio, duraci?n en horas, cupo total, cupo por grupo y arancel.
   - Cada alumno se describe por un legajo (?nico), nro. de documento (?nico), apellido, nombre, domicilio y tel?fonos.
   - Un alumno puede inscribirse en varios cursos, pero solo en un grupo por curso.
   - Seg?n la cantidad de inscriptos el curso se puede dividir en m?s de un grupo.
   - Cada grupo puede estar a cargo de uno o m?s docentes
   - Los docentes se definen a trav?s de un n?mero de legajo (?nico),  apellido, nombre y nro. de documento (?nico).
   - Cada docente puede estar designado en diferentes grupos
   - Cada grupo tiene un horario semanal determinado que puede incluir uno o m?s d?as de la semana. Por ejemplo: lunes de 18 a 21 y s?bados de 9 a 12.
   - El horario del curso se representa a trav?s del d?a de la semana, hora de inicio y hora de fin. 

   Se dise?? una base de datos cuyo modelo de datos se adjunta.
   Se implement? a trav?s del script siguiente:
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
 fecha_fin			date			not null,
 duracion			smallint		not null,
 cupo_total			smallint		not null, 
 cupo_grupo			tinyint			not null,
 arancel 			decimal(7,2)	not	null, 
 constraint PK__cursos__END           primary key (cod_curso),
 constraint CK__cursos__fechas__END   check (fecha_fin >= fecha_inicio),
 constraint CK__cursos__duracion__END check (duracion > 0),
 constraint CK__cursos__cupos__END    check (cupo_total > 0 and cupo_grupo > 0 and cupo_total >= cupo_grupo),
 constraint CK__cursos__arancel__END  check (arancel > 0.00)
)
go

insert into cursos (cod_curso, nom_curso, fecha_inicio, fecha_fin, duracion, cupo_total, cupo_grupo, arancel)
values ('CAP1', 'CURSO CAPACITACION 1', '2020-04-01', '2020-04-30', 40,  10,  5, 1800.00),
       ('CAP2', 'CURSO CAPACITACION 2', '2020-04-15', '2020-05-30', 60,  12,  4, 2200.00),
       ('CAP3', 'CURSO CAPACITACION 3', '2020-05-20', '2020-06-10', 40,   8,  4, 1900.00),
       ('CAP4', 'CURSO CAPACITACION 4', '2020-06-10', '2020-07-05', 40,  14,  7, 2000.00)
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
values ( 1, 12133879, 'TORRES',			'ALBERTO',		'SAN MARTIN 145 - C?RDOBA',			'351-3455566'),
       ( 2, 14655787, 'BARROSO',		'CARLOS',		'INDEPENDENCIA 889 - C?RDOBA',		'351-4345667'),
       ( 3, 13556790, 'SARMIENTO',		'DORIS',		'AV. BELGRANO 1123 - BUENOS AIRES', '11-43455678'),
       ( 4, 20323333, 'PAREDES',		'ALEJANDRA',	'OBISPO TREJO 112 - SANTA FE',		'342-4567754'),
       ( 5, 21345677, 'REYNOSO',		'DARIO',		'DEAN FUNES 5533 - ROSARIO',		'341-4647789'),
       ( 6, 12546466, 'MONTERO',		'HECTOR',		'AV. RIVADAVIA 451 - C?RDOBA',		'351-4322346'),
       ( 7, 34444321, 'LUDUE?A',		'MARINA',		'MITRE 123 - MENDOZA',				'391-4154667'),
       ( 8, 25678334, 'GUERRERO',		'PAOLA',		'AV. GENERAL PAZ 6777 - SAN JUAN',	'392-3436667'),
       ( 9, 11347899, 'FERRERO',		'FRANCO',       'VELEZ SARSFIELD 1223 - C?RDOBA',	'351-2252366'),
       (10, 10298969, 'GUTIERREZ',		'BEATRIZ',      'AV. ILLIA 456 - C?RDOBA',			'351-5578899')
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
 constraint PK__alumnos_grupos__END             primary key (cod_curso, nro_alumno),
 constraint FK__alumnos_grupos__grupos__1__END  foreign key (cod_curso, nro_grupo) references grupos,
 constraint FK__alumnos_grupos__alumnos__1__END foreign key (nro_alumno) references alumnos
)
go

insert into alumnos_grupos (cod_curso, nro_grupo, nro_alumno)
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
       ('CAP1', 2,  1),

       ('CAP2', 1,  3),
       ('CAP2', 2,  4),

       ('CAP3', 1,  2),
       ('CAP3', 2,  2)
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
Ha surgido un nuevo requerimiento en el sistema de cursos de capacitaci?n: "Cada grupo tendr? un ?nico docente". 

a. Debe elaborar un script para cambiar la base de datos con las operaciones necesarias para dar soporte al nuevo requerimiento,
   incluyendo la migraci?n de los datos actuales a la nueva estructura. 
   Esto puede implicar: eliminar, modificar o crear tablas o columnas.
   NOTA: NO MODIFIQUE EL SCRIPT ORIGINAL!. Debe programar un nuevo script para cambiar la base de datos. Tenga en cuenta que el 
   orden de las operaciones puede ser cr?tico. Por ejemplo, no se puede eliminar una columna si tiene una regla de integridad. 
   Primero deber? eliminar la regla de integridad.
   Suponga que los grupos registrados al momento en la base de datos tienen un ?nico docente asignado y que, por lo tanto, 
   datos pueden ser migrados sin problemas.
   NOTA1: La migraci?n no debe basarse en operaciones fijas (que usan constantes con los datos actuales), sino que debe estar 
   programada para ejecutarse ante cualquier contenido de las tablas. (50)

c. Utilizando la base de datos original (SIN los cambios implementados), programar una consulta que muestre los alumnos inscriptos
   en grupos de cursos, que a?n no tienen docente designado y tampoco los horarios definidos.
   Datos a mostrar: (nro_alumno, apellido, nombre, nro_curso, nom_curso, nro_grupo) (50)
*/


--a

alter table grupos
add nro_docente	smallint	null
go

alter table grupos
add foreign key(nro_docente) references docentes
go


update g	
	set g.nro_docente = dg.nro_docente
	--select  *
		from grupos g
			join docentes_grupos dg
				on g.nro_grupo = dg.nro_grupo
				and g.cod_curso = dg.cod_curso


alter table docentes_grupos
drop constraint FK__docentes_grupos__docentes__1__END
go

alter table docentes_grupos
drop constraint FK__docentes_grupos__grupos__1__END
go

alter table docentes_grupos
drop constraint PK__docentes_grupos__END
go

drop table docentes_grupos
go

-- NO ES NECESARIO ELIMINAR LAS RESTRICCIONES DE LA TABLA DOCENTES_GRUPOS ANTES DE ELIMINAR LA TABLA 
-- PUNTOS: 40



--b
/*
c. Utilizando la base de datos original (SIN los cambios implementados), programar una consulta que muestre los alumnos inscriptos
   en grupos de cursos, que a?n no tienen docente designado y tampoco los horarios definidos.
   Datos a mostrar: (nro_alumno, apellido, nombre, nro_curso, nom_curso, nro_grupo) (50)

*/


select a.nro_alumno, a.apellido, a.nombre, ag.cod_curso, c.nom_curso, ag.nro_grupo
	from alumnos a
		join alumnos_grupos ag
			on a.nro_alumno = ag.nro_alumno
				join cursos c
					on ag.cod_curso = c.cod_curso
 where (not exists (select *
						from docentes_grupos dg
					  where ag.cod_curso = dg.cod_curso
					  and ag.nro_grupo = dg.nro_grupo)
			and 
		(not exists (select * 
						from horarios_grupos hg
					  where ag.cod_curso = hg.cod_curso
					  and ag.nro_grupo = hg.nro_grupo)))
						
-- PUNTOS: 50

-- PUNTAJE TOTAL: 90

