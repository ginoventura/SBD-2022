drop table examenes
drop table materias
drop table matriculas
drop table alumnos
drop table carreras
go

create table carreras
(cod_carrera		 smallint	not null primary key,
 nom_carrera		 varchar(40)	not null unique,
 nota_aprob_examen_final tinyint	not null check ( nota_aprob_examen_final > 0 ) default 4
)
go

create table materias
(cod_carrera		smallint	not null references carreras,
 cod_materia		varchar(10)	not null,
 nom_materia		varchar(40)	not null,
 cuat_materia		tinyint		not null check ( cuat_materia > 0 ),
 optativa		char(1)		not null check ( optativa in ('S','N')),
 primary key (cod_carrera, cod_materia)
)
go

create table alumnos
(nro_alumno		integer		 not null primary key,
 nom_alumno		varchar(40) 	 not null,
 tipo_doc_alumno	varchar(3)       not null default 'DNI',
 nro_doc_alumno		integer		 not null unique
)
go

create table matriculas
(nro_alumno		integer		not null references alumnos,
 cod_carrera		smallint	not null references carreras,
 ano_ingreso		smallint	not null,
 primary key (nro_alumno, cod_carrera)
)
go

create table examenes
(nro_alumno		integer		not null,
 cod_carrera		smallint	not null,
 cod_materia		varchar(10)	not null,
 fecha_examen		smalldatetime	not null,
 nro_libro		smallint	not null,
 nro_acta		tinyint		not null,
 nota_examen		decimal(4,2)	null,
 primary key (nro_libro, nro_acta, nro_alumno),
 unique (nro_alumno, cod_carrera, cod_materia, fecha_examen),
 foreign key (nro_alumno, cod_carrera) references matriculas,
 foreign key (cod_carrera, cod_materia) references materias
)
go

insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (1,'ALUMNO 1',111)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (2,'ALUMNO 2',222)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (3,'ALUMNO 3',333)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (4,'ALUMNO 4',444)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (5,'ALUMNO 5',555)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (6,'ALUMNO 6',666)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (7,'ALUMNO 7',777)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (8,'ALUMNO 8',888)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (9,'ALUMNO 9',999)
insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values (10,'ALUMNO 10',101010)
go

insert into carreras (cod_carrera, nom_carrera, nota_aprob_examen_final)
values (1,'CARRERA 1',4)
insert into carreras (cod_carrera, nom_carrera, nota_aprob_examen_final)
values (2,'CARRERA 2',4)
insert into carreras (cod_carrera, nom_carrera, nota_aprob_examen_final)
values (3,'CARRERA 3',6)
go

insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,1,'MATERIA 1-1',1,'S')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,2,'MATERIA 1-2',2,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,3,'MATERIA 1-3',3,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,4,'MATERIA 1-4',4,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,5,'MATERIA 1-5',5,'N')

insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (2,1,'MATERIA 2-1',1,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (2,2,'MATERIA 2-2',2,'S')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (2,3,'MATERIA 2-3',3,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (2,4,'MATERIA 2-4',4,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (2,5,'MATERIA 2-5',5,'N')

insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (3,1,'MATERIA 3-1',1,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (3,2,'MATERIA 3-2',2,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (3,3,'MATERIA 3-3',3,'S')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (3,4,'MATERIA 3-4',4,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (3,5,'MATERIA 3-5',5,'N')
go

insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (1,1,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (2,1,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (3,1,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (4,1,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (5,1,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (6,2,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (7,2,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (8,2,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (9,2,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (10,2,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (1,3,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (6,3,1995)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,1,'10 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,2,'11 jun 1996 0:00',1,2,9)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,3,'12 jun 1996 0:00',1,3,8)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,4,'13 jun 1996 0:00',1,4,7)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,5,'14 jun 1996 0:00',1,5,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,2,'11 jun 1996 0:00',1,1,9)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,3,'12 jun 1996 0:00',1,2,8)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,4,'13 jun 1996 0:00',1,3,7)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,5,'14 jun 1996 0:00',1,4,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,1,'11 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,3,'12 jun 1996 0:00',1,2,9)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,4,'13 jun 1996 0:00',1,3,8)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,5,'14 jun 1996 0:00',1,4,7)
go
 
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,2,'11 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,3,'12 jun 1996 0:00',1,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,4,'13 jun 1996 0:00',1,3,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,5,'14 jun 1996 0:00',1,4,9)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,1,'11 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,2,'12 jun 1996 0:00',1,2,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,2,'13 jun 1996 0:00',1,3,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,2,'14 jun 1996 0:00',1,4,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,3,'15 jun 1996 0:00',1,5,6)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,4,'16 jun 1996 0:00',1,6,6)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,5,'17 jun 1996 0:00',1,7,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,2,1,'10 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,2,2,'11 jun 1996 0:00',1,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,2,3,'12 jun 1996 0:00',1,3,10)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,1,'11 jun 1996 0:00',1,1,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,3,'12 jun 1996 0:00',1,2,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,4,'13 jun 1996 0:00',1,3,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,5,'14 jun 1996 0:00',1,4,5)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,1,'11 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,3,'12 jun 1996 0:00',1,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,4,'13 jun 1996 0:00',1,3,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,5,'14 jun 1996 0:00',1,4,10)
go
 
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,1,'11 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,3,'12 jun 1996 0:00',1,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,4,'13 jun 1996 0:00',1,3,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,5,'14 jun 1996 0:00',1,4,10)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,1,'11 jun 1996 0:00',1,1,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,2,'8 jun 1996 0:00',3,2,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,2,'9 jun 1996 0:00',4,2,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,2,'12 jun 1996 0:00',1,2,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,2,'18 jun 1996 0:00',1,3,1)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,3,'15 jun 1996 0:00',1,5,8)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,4,'16 jun 1996 0:00',1,6,6)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,5,'17 jun 1996 0:00',1,7,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,1,'13 jun 1996 0:00',3,1,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,2,'14 jun 1996 0:00',3,2,10)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,1,'10 jun 1996 0:00',2,1,4)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,2,'11 jun 1996 0:00',2,2,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,3,'12 jun 1996 0:00',2,3,6)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,4,'10 jun 1996 0:00',2,4,7)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,5,'10 jun 1996 0:00',2,5,8)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,1,'10 jun 1996 0:00',2,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,2,'11 jun 1996 0:00',2,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,3,'12 jun 1996 0:00',2,3,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,4,'12 jun 1996 0:00',1,4,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,5,'12 jun 1996 0:00',1,5,10)
go

/*
EJERCICIOS:

1. Mostrar cantidad de ausentes por alumno-carrera
2. Mostrar cantidad de ausentes y promedio por alumno_carrera
3. Mostrar cantidad de ausentes por alumno-carrera para aquellos que no tengan aplazos
4. Mostrar los egresados (nro_alumno, nom_alumno, cod_carrera, nom_carrera, promedio)
5. Crear vista "egresados" y mostrar los egresados usando la vista (nro_alumno, nom_alumno, cod_carrera, nom_carrera, promedio)
6. Programar los pasos que crean necesarios para obtener un orden de mérito por carrera 
   de los alumnos egresados hasta el tercer puesto teniendo en cuenta que a igual promedio 
   igual orden de merito.
   Los pasos pueden incluir: crear nuevas tablas, modificar tablas, agregar columnas, 
   insertar filas, eliminar filas, actualizar columnas, consultar, etc.
*/

