drop table examenes
drop table materias
drop table matriculas
drop table alumnos
drop table carreras
go

create table carreras
(
 cod_carrera			smallint		not null primary key,
 nom_carrera			varchar(40)		not null unique,
 nota_aprob_examen_final tinyint		not null check ( nota_aprob_examen_final > 0 ) default 4
)
go

create table materias
(
 cod_carrera		smallint	not null references carreras,
 cod_materia		varchar(10)	not null,
 nom_materia		varchar(40)	not null,
 cuat_materia		tinyint		not null check ( cuat_materia > 0 ),
 optativa			char(1)		not null check ( optativa in ('S','N')),
 primary key (cod_carrera, cod_materia)
)
go

create table alumnos
(
 nro_alumno			integer		 not null primary key,
 nom_alumno			varchar(40)  not null,
 tipo_doc_alumno	varchar(3)   not null default 'DNI',
 nro_doc_alumno		integer		 not null unique
)
go

create table matriculas
(
 nro_alumno			integer		not null references alumnos,
 cod_carrera		smallint	not null references carreras,
 ano_ingreso		smallint	not null,
 primary key (nro_alumno, cod_carrera)
)
go

create table examenes
(
 nro_alumno			integer			not null,
 cod_carrera		smallint		not null,
 cod_materia		varchar(10)		not null,
 fecha_examen		smalldatetime	not null,
 nro_libro			smallint		not null,
 nro_acta			tinyint			not null,
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
values (1,4,'MATERIA 1-4',3,'S')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,5,'MATERIA 1-5',3,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,6,'MATERIA 1-6',4,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,7,'MATERIA 1-7',4,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,8,'MATERIA 1-8',4,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,9,'MATERIA 1-9',5,'N')
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,10,'MATERIA 1-10',5,'N')

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
values (2,1,1998)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (3,1,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (4,1,1997)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (5,1,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (6,2,2001)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (7,2,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (8,2,2000)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (9,2,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (10,2,1995)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (1,3,1997)
insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (6,3,2000)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,1,'10 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,2,'11 jun 1996 0:00',1,2,9)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,3,'12 jun 1997 0:00',1,3,8)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,4,'13 jun 1997 0:00',1,4,7)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,5,'14 jun 1999 0:00',1,5,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,2,'11 jun 1998 0:00',1,1,9)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,3,'12 jun 1998 0:00',1,2,8)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,4,'13 jun 1999 0:00',1,3,7)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,5,'14 jun 2000 0:00',1,4,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,1,'11 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,3,'12 jun 1997 0:00',1,2,9)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,4,'13 jun 1998 0:00',1,3,8)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,5,'14 jun 1998 0:00',1,4,7)
go
 
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,2,'11 jun 1997 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,3,'12 jun 1997 0:00',1,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,4,'13 jun 1998 0:00',1,3,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,5,'14 jun 1999 0:00',1,4,9)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,1,'11 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,2,'12 jun 1999 0:00',1,2,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,2,'13 jun 1999 0:00',1,3,1)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,2,'14 jun 1999 0:00',1,4,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,3,'15 jun 2000 0:00',1,5,6)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,4,'16 jun 2001 0:00',1,6,6)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,5,'17 jun 2001 0:00',1,7,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,2,1,'10 jun 2001 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,2,2,'11 jun 2001 0:00',1,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,2,3,'12 jun 2001 0:00',1,3,10)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,1,'11 jun 1996 0:00',1,1,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,3,'12 jun 1997 0:00',1,2,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,4,'13 jun 1998 0:00',1,3,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,5,'14 jun 1998 0:00',1,4,5)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,1,'11 jun 2000 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,3,'12 jun 2000 0:00',1,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,4,'13 jun 2001 0:00',1,3,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,5,'14 jun 2001 0:00',1,4,10)
go
 
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,1,'11 jun 1996 0:00',1,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,3,'12 jun 1997 0:00',1,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,4,'13 jun 1997 0:00',1,3,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,5,'14 jun 1998 0:00',1,4,10)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,1,'11 jun 1996 0:00',1,1,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,2,'12 jun 1996 0:00',1,2,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,2,'13 jun 1997 0:00',1,3,1)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,3,'15 jun 1998 0:00',1,5,8)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,4,'16 jun 1998 0:00',1,6,6)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,5,'17 jun 1999 0:00',1,7,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,1,'10 jun 1997 0:00',10,1,null)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,2,'11 jun 1997 0:00',10,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,1,'12 jun 1997 0:00',11,1,4)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,2,'14 jun 1996 0:00',11,2,5)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,3,'12 jun 1998 0:00',11,3,6)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,4,'10 jun 1998 0:00',11,4,7)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,5,'10 jun 2000 0:00',11,5,8)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,1,'10 jun 2000 0:00',21,1,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,2,'11 jun 2000 0:00',21,2,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,3,'12 jun 2001 0:00',21,3,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,4,'12 jun 2001 0:00',1,4,10)
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,5,'12 jun 2001 0:00',1,5,10)
go

/* 
EJERCICIOS:

1. Cantidad de materias aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'
2. Cantidad de materias no aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'
3. Mostrar nro_alumno y nom_alumno de aquellos alumnos que no han rendido exámenes finales en 
   ninguna carrera desde el 1/1/99.
4. Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos que ingresaron
   en 1995 y tienen promedio >= 7 y han rendido más de 20 exámenes finales (no considerar los ausentes)
5. Mostrar nro_alumno y nom_alumno de aquellos alumnos de la carrera 1 que ingresaron en 1995 
   y tienen aprobadas todas las materias obligatorias de dicha carrera hasta el tercer 
   cuatrimestre inclusive.
*/

-- 1. Cantidad de materias aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'

select count(distinct e.cod_materia)
  from dbo.examenes e
       join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera
	   join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
 where e.nota_examen >= c.nota_aprob_examen_final
   and c.nom_carrera = 'CARRERA 3'
   and a.nom_alumno  = 'ALUMNO 1'

-- 2. Cantidad de materias no aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'

select count(*) - (select count(distinct e.cod_materia)
                     from dbo.examenes e
                          join dbo.carreras c
	                        on e.cod_carrera = c.cod_carrera
	                      join dbo.alumnos a
	                        on e.nro_alumno = a.nro_alumno
                    where e.nota_examen >= c.nota_aprob_examen_final
                      and c.nom_carrera = 'CARRERA 3'
                      and a.nom_alumno  = 'ALUMNO 1')
  from dbo.materias m
       join dbo.carreras c 
	     on m.cod_carrera = c.cod_carrera
		and c.nom_carrera = 'CARRERA 3'

select count(distinct e.cod_materia)
  from dbo.examenes e
       join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera
	   join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
 where e.nota_examen >= c.nota_aprob_examen_final
   and c.nom_carrera = 'CARRERA 3'
   and a.nom_alumno  = 'ALUMNO 1'

select *
  from dbo.materias m
       join dbo.carreras c 
	     on m.cod_carrera = c.cod_carrera
		and c.nom_carrera = 'CARRERA 3'

select count(*) - (select count(distinct e.cod_materia)
                     from dbo.examenes e
	                      join dbo.alumnos a
	                        on e.nro_alumno = a.nro_alumno
                    where e.nota_examen >= c.nota_aprob_examen_final
                      and a.nom_alumno  = 'ALUMNO 1'
					  and c.cod_carrera = e.cod_carrera)
  from dbo.materias m
       join dbo.carreras c 
	     on m.cod_carrera = c.cod_carrera
		and c.nom_carrera = 'CARRERA 3'
 group by c.cod_carrera, c.nota_aprob_examen_final

select count(*), max(c.nota_aprob_examen_final),  c.cod_carrera
  from dbo.materias m
       join dbo.carreras c 
	     on m.cod_carrera = c.cod_carrera
		and c.nom_carrera = 'CARRERA 3'
 group by c.cod_carrera

-- 4. Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos que ingresaron
--    en 1995 y tienen promedio >= 7 y han rendido más de 20 exámenes finales (no considerar los ausentes)

select m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera, avg(e.nota_examen), count(e.nota_examen)
  from dbo.matriculas m
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
       join dbo.examenes e
	     on m.nro_alumno = e.nro_alumno
		and m.cod_carrera = e.cod_carrera
 where m.ano_ingreso = 1995
 group by m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera
having avg(e.nota_examen) >= 7
   and count(e.nota_examen) > 4

select m.nro_alumno, max(a.nom_alumno), m.cod_carrera, max(c.nom_carrera), avg(e.nota_examen), count(e.nota_examen)
  from dbo.matriculas m
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
       join dbo.examenes e
	     on m.nro_alumno = e.nro_alumno
		and m.cod_carrera = e.cod_carrera
 where m.ano_ingreso = 1995
 group by m.nro_alumno, m.cod_carrera
having avg(e.nota_examen) >= 7
   and count(e.nota_examen) > 4


-- 5. Mostrar nro_alumno y nom_alumno de aquellos alumnos de la carrera 1 que ingresaron en 1995 
--    y tienen aprobadas todas las materias obligatorias de dicha carrera hasta el tercer 
--    cuatrimestre inclusive.

select *
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
 where m.ano_ingreso = 1995
   and c.nom_carrera = 'CARRERA 1'
   and not exists (select *
                     from dbo.materias ma
					where c.cod_carrera    = ma.cod_carrera
					  and ma.optativa      = 'N'
					  and ma.cuat_materia <= 3
					  and not exists (select *
					                    from dbo.examenes e
									   where ma.cod_carrera = e.cod_carrera
									     and ma.cod_materia = e.cod_materia
										 and m.nro_alumno   = e.nro_alumno
										 and e.nota_examen >= c.nota_aprob_examen_final))

todas las materias tienen un examen aprobado por alumno
no hay materias que no tengan un examen aprobado por alumno

select *
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
 where m.ano_ingreso = 1995
   and c.nom_carrera = 'CARRERA 1'
   and (select count(*)
          from dbo.materias ma
	 	 where c.cod_carrera    = ma.cod_carrera
		   and ma.optativa      = 'N'
		   and ma.cuat_materia <= 3) = (select count(distinct e.cod_materia)
					                      from dbo.examenes e
										       join dbo.materias ma1
											     on ma1.cod_carrera   = e.cod_carrera
  									            and ma1.cod_materia   = e.cod_materia
										 where m.nro_alumno      = e.nro_alumno
	 	                                   and ma1.cod_carrera   = c.cod_carrera
		                                   and ma1.optativa      = 'N'
		                                   and ma1.cuat_materia <= 3	
										   and e.nota_examen    >= c.nota_aprob_examen_final)

-- Obtener los egresados
select *
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
 where (select count(*)
          from dbo.materias ma
	 	 where c.cod_carrera    = ma.cod_carrera
		   and ma.optativa      = 'N') = (select count(distinct e.cod_materia)
					                        from dbo.examenes e
										         join dbo.materias ma1
											       on ma1.cod_carrera   = e.cod_carrera
  									              and ma1.cod_materia   = e.cod_materia
										   where m.nro_alumno      = e.nro_alumno
	 	                                     and ma1.cod_carrera   = c.cod_carrera
		                                     and ma1.optativa      = 'N'
										     and e.nota_examen    >= c.nota_aprob_examen_final)

select *
from materias 
where cod_carrera = 2

select *
 from examenes
 where nro_alumno between 7 and 10
 and cod_carrera = 2
 order by nro_alumno, cod_materia

-- vistas
create or alter view dbo.v_egresados (nro_alumno, cod_carrera)
as
select m.nro_alumno, m.cod_carrera
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
 where (select count(*)
          from dbo.materias ma
	 	 where c.cod_carrera    = ma.cod_carrera
		   and ma.optativa      = 'N') = (select count(distinct e.cod_materia)
					                        from dbo.examenes e
										         join dbo.materias ma1
											       on ma1.cod_carrera   = e.cod_carrera
  									              and ma1.cod_materia   = e.cod_materia
										   where m.nro_alumno      = e.nro_alumno
	 	                                     and ma1.cod_carrera   = c.cod_carrera
		                                     and ma1.optativa      = 'N'
										     and e.nota_examen    >= c.nota_aprob_examen_final)

select *
  from dbo.v_egresados e
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera

select *
  from (select m.nro_alumno, m.cod_carrera
          from dbo.matriculas m
               join dbo.carreras c
	             on m.cod_carrera = c.cod_carrera
         where (select count(*)
                  from dbo.materias ma
	 	         where c.cod_carrera    = ma.cod_carrera
		           and ma.optativa      = 'N') = (select count(distinct e.cod_materia)
					                                from dbo.examenes e
							        	 		         join dbo.materias ma1
										      	           on ma1.cod_carrera   = e.cod_carrera
  									                      and ma1.cod_materia   = e.cod_materia
										           where m.nro_alumno      = e.nro_alumno
	 	                                             and ma1.cod_carrera   = c.cod_carrera
		                                             and ma1.optativa      = 'N'
										             and e.nota_examen    >= c.nota_aprob_examen_final)) e
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera

-- funciones
   -- escalares
   -- tabulares
create or alter function dbo.fn_egresados 
(
 @cod_carrera	smallint = null -- null: todas las carreras
)
returns table
as
return (select m.nro_alumno, m.cod_carrera
          from dbo.matriculas m
               join dbo.carreras c
	             on m.cod_carrera = c.cod_carrera
         where (
		        m.cod_carrera = @cod_carrera
				or
				@cod_carrera is null
			   )
		   and (select count(*)
                  from dbo.materias ma
	 	         where c.cod_carrera    = ma.cod_carrera
		           and ma.optativa      = 'N') = (select count(distinct e.cod_materia)
					                                from dbo.examenes e
							       	  	 	             join dbo.materias ma1
											               on ma1.cod_carrera   = e.cod_carrera
  									                      and ma1.cod_materia   = e.cod_materia
										           where m.nro_alumno      = e.nro_alumno
	 	                                             and ma1.cod_carrera   = c.cod_carrera
		                                             and ma1.optativa      = 'N'
										             and e.nota_examen    >= c.nota_aprob_examen_final))

select *
  from dbo.fn_egresados(3) e
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera

select *
  from dbo.fn_egresados(null) e
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera

select *
  from dbo.fn_egresados(default) e
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera

create or alter function dbo.fn_egresados_v2
(
 @cod_carrera	smallint = null -- null: todas las carreras
)
returns @egresados table
        (
		 nro_alumno		integer,
		 cod_carrera	smallint
		)
as
begin

   insert into @egresados (nro_alumno, cod_carrera)
   select m.nro_alumno, m.cod_carrera
     from dbo.matriculas m
          join dbo.carreras c
	        on m.cod_carrera = c.cod_carrera
    where (
	       m.cod_carrera = @cod_carrera
	       or
		   @cod_carrera is null
		  )
      and (select count(*)
             from dbo.materias ma
	        where c.cod_carrera    = ma.cod_carrera
	          and ma.optativa      = 'N') = (select count(distinct e.cod_materia)
				                               from dbo.examenes e
							       	  	 	        join dbo.materias ma1
											          on ma1.cod_carrera   = e.cod_carrera
  									                 and ma1.cod_materia   = e.cod_materia
										      where m.nro_alumno      = e.nro_alumno
	 	                                        and ma1.cod_carrera   = c.cod_carrera
		                                        and ma1.optativa      = 'N'
										        and e.nota_examen    >= c.nota_aprob_examen_final)

   return
end

select *
  from dbo.fn_egresados_v2(default) e
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera

-- vistas actualizables
create or alter view dbo.v_matriculas (nro_alumno, cod_carrera, ano_ingreso, numero_alumno, tipo_doc_alumno, nro_doc_alumno, nom_alumno)
as
select m.nro_alumno, m.cod_carrera, m.ano_ingreso, a.nro_alumno, a.tipo_doc_alumno, a.nro_doc_alumno, a.nom_alumno
  from dbo.matriculas m
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno


select * from dbo.v_matriculas

-- insert
insert into dbo.v_matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (3, 3, 1990)
insert into dbo.v_matriculas (numero_alumno, tipo_doc_alumno, nro_doc_alumno, nom_alumno)
values (11, 'DNI', 11111111, 'ALUMNO 11')

-- update
update m
   set ano_ingreso = 1991
--select *  
  from dbo.v_matriculas m
 where m.nro_alumno = 1
   and m.cod_carrera = 1

select * from matriculas
select * from alumnos


create or alter function dbo.fn_es_egresado
(
 @nro_alumno	integer,
 @cod_carrera	smallint
)
returns char(1)
as
begin
   declare @egresado	char(1)
   
   if (select count(*)
         from dbo.materias ma
	    where ma.cod_carrera = @cod_carrera
	      and ma.optativa    = 'N') = (select count(distinct e.cod_materia)
					                     from dbo.examenes e
									 	      join dbo.carreras c 
										   	    on e.cod_carrera = c.cod_carrera
							       	  	 	  join dbo.materias ma1
											    on ma1.cod_carrera   = e.cod_carrera
  									           and ma1.cod_materia   = e.cod_materia
									    where e.nro_alumno      = @nro_alumno
	 	                                  and ma1.cod_carrera   = @cod_carrera
		                                  and ma1.optativa      = 'N'
									      and e.nota_examen    >= c.nota_aprob_examen_final)
      begin   
   	     select @egresado = 'S'
      end
   else
      begin
	     set @egresado = 'N'
	  end

   return @egresado
end
go

select m.nro_alumno, m.cod_carrera, dbo.fn_es_egresado (m.nro_alumno, m.cod_carrera) egresado
  from dbo.matriculas m
 where dbo.fn_es_egresado (m.nro_alumno, m.cod_carrera) = 'S'

alter table dbo.matriculas
add egresado as dbo.fn_es_egresado (nro_alumno, cod_carrera)

select *
from matriculas
where egresado = 'S'

select nro_alumno, cod_carrera, ano_ingreso
from matriculas

create or alter view dbo.v_matriculas (nro_alumno, cod_carrera, ano_ingreso, egresado)
as
select m.nro_alumno, m.cod_carrera, m.ano_ingreso, dbo.fn_es_egresado (m.nro_alumno, m.cod_carrera)
  from dbo.matriculas m

select *
from dbo.v_matriculas


