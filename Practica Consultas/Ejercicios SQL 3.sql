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
 optativa			char(1)		not null check ( optativa in ('S','N')),
 trabajo_final		bit			not null default 0,
 cant_materias		tinyint		not null default 0
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

select * from examenes
select * from materias
select * from matriculas
select * from alumnos
select * from carreras

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

-- 1) Cantidad de materias aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'

select a.nro_alumno, a.nom_alumno, c.cod_carrera, c.nom_carrera, count(distinct e.cod_materia) as cant_mat_aprobadas
	from alumnos a
		join matriculas m
			on a.nro_alumno = m.nro_alumno
		join carreras c
			on m.cod_carrera = c.cod_carrera
		join materias ma
			on c.cod_carrera = ma.cod_carrera
		join examenes e
			on ma.cod_materia = e.cod_materia
	where e.nota_examen >= c.nota_aprob_examen_final
	  and nom_alumno = 'ALUMNO 1'
	  and nom_carrera = 'CARRERA 3'
	group by a.nro_alumno, a.nom_alumno, c.cod_carrera, c.nom_carrera



select a.nro_alumno, c.cod_carrera, count(distinct e.cod_materia) as cantidad_mat_aprobadas
	from alumnos a
		join examenes e
			on a.nro_alumno = e.nro_alumno
		join carreras c
			on e.cod_carrera = c.cod_carrera
	where e.nota_examen >= c.nota_aprob_examen_final 
	  and a.nro_alumno = 1
	  and c.cod_carrera = 3
	group by a.nro_alumno, c.cod_carrera
go

-- 2) Cantidad de materias no aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'
select COUNT(*) - (select count(distinct e.cod_materia)
					from alumnos a
						join examenes e
							on a.nro_alumno = e.nro_alumno
						join carreras c
							on e.cod_carrera = c.cod_carrera
					where e.nota_examen >= c.nota_aprob_examen_final 
					  and a.nro_alumno = 1
					  and c.cod_carrera = 3) 
					from materias m 
						join carreras c
							on m.cod_carrera = c.cod_carrera
					where c.nom_carrera = 'CARRERA 3'
go

-- 5) Mostrar nro_alumno y nom_alumno de aquellos alumnos de la carrera 1 que ingresaron en 1995 
--   y tienen aprobadas todas las materias obligatorias de dicha carrera hasta el tercer 
--   cuatrimestre inclusive.

select * 
	from matriculas m
		join carreras c
			on m.cod_carrera = c.cod_carrera
	where m.ano_ingreso = 1995
	  and c.nom_carrera = 'CARRERA 1' 
	  and not exists (select * 
						from materias ma
							where c.cod_carrera = ma.cod_carrera
							  and ma.optativa = 'N'
							  and ma.cuat_materia <= 3
							  and not exists (select * 
												from examenes e
													where ma.cod_carrera = e.cod_carrera
													  and ma.cod_carrera = e.cod_materia
													  and m.nro_alumno = e.nro_alumno
													  and e.nota_examen >= c.nota_aprob_examen_final))

---------------------------------------------------------------------------------------------------------------------------------
-- VISTA PARA OBTENER LOS EGRESADOS:
create or alter view vista_egresados(nro_alumno, cod_carrera)
as 
select m.nro_alumno, m.cod_carrera
	from matriculas m 
		join carreras c
		  on m.cod_carrera = c.cod_carrera
	where (select count(*)
				from materias ma 
					where c.cod_carrera = ma.cod_carrera
					  and ma.optativa = 'N') = (select count(distinct e.cod_materia)
													from examenes e
														join materias ma1
														  on ma1.cod_carrera = e.cod_carrera
														 and ma1.cod_materia = e.cod_materia
													where m.nro_alumno = e.nro_alumno
													  and ma1.cod_carrera = c.cod_carrera
													  and ma1.optativa = 'N'
													  and e.nota_examen >= c.nota_aprob_examen_final)

select * from vista_egresados
---------------------------------------------------------------------------------------------------------------------------------
-- FUNCIONES ESCALARES: devuelve un escalar
-- FUNCIONES TABULARES: devuelve una tabla

-- FUNCION TABULAR PARA DEVOLVER LOS EGRESADOS:
create or alter function funcion_egresados 
( 
	-- Argumentos:
)
	as
		return (select m.nro_alumno, m.cod_carrera
					from matriculas m 
						join carreras c
						  on m.cod_carrera = c.cod_carrera
					where (select count(*)
								from materias ma 
									where c.cod_carrera = ma.cod_carrera
									  and ma.optativa = 'N') = (select count(distinct e.cod_materia)
																	from examenes e
																		join materias ma1
																		  on ma1.cod_carrera = e.cod_carrera
																		 and ma1.cod_materia = e.cod_materia
																	where m.nro_alumno = e.nro_alumno
																	  and ma1.cod_carrera = c.cod_carrera
																	  and ma1.optativa = 'N'
																	  and e.nota_examen >= c.nota_aprob_examen_final))




---------------------------------------------------------------------------------------------------------------------------------
alter table carreras add
	nota_minima		tinyint		not null constraint DF__carreras__nota_minima__0__END default 0,
	nota_maxima		tinyint		not null constraint DF__carreras__nota_maxima__10__END default 10
go

alter table carreras add
	constraint CK__carreras__rango_notas__END check (nota_minima < nota_maxima)
go

alter table carreras drop constraint CK__carreras__nota_a__49C3F6B7
go

alter table carreras add
	constraint CK__carreras__nota_aprob_examen_final__END check	(nota_aprob_examen_final between nota_minima+1 and nota_maxima-1)
go

select * from carreras

-- REGLA DE INTEGRIDAD: las notas de examenes deben estar dentro del rango definido
-- para cada carrera
-----------------------------------------------------------------------------------
-- 1. Determinar filas que no cumplen con la regla de integridad
-----------------------------------------------------------------------------------
select * 
	from examenes e
		join carreras c
		on e.cod_carrera = c.cod_carrera
	where e.nota_examen not between c.nota_maxima and c.nota_minima
go

-----------------------------------------------------------------------------------
-- 2. Determinar que triggers tengo que programar
-- Que operaciones sobre que tablas influyen en la regla de integridad.
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- TABLA			INSERT			DELETE			UPDATE
-----------------------------------------------------------------------------------
-- Carreras			 NO				 NO				SI(nota_minima o nota_maxima)
-----------------------------------------------------------------------------------
-- Examenes			 SI				 NO				SI(nota_examen)
-----------------------------------------------------------------------------------

-- Insert en carreras: si inserto una carrera, todavia no tengo examenes que tengan 
-- nota en la carrera.
-- Delete en carreras: si no hay carreras, no hay examenes.
-- Update en carreras: solo cuando reducimos el rango de la nota, debemos controlarlo
-----------------------------------------------------------------------------------
-- Insert en examenes: si inserto un examen, la nota debe estar dentro del rango.
-- Delete en examenes: no deja de cumplir una regla de control algo que no existe.
-- Update en examenes: si se actualiza la nota del examen, debemos evaluar si la nueva
-- nota pertenece al rango.

-----------------------------------------------------------------------------------
-- 3. Programar los triggers.
-----------------------------------------------------------------------------------
create trigger tri_insertar_examenes
on examenes
	for insert, update
	as
	begin
		if exists (select * 
					 from inserted e
						join carreras c
							on e.cod_carrera = c.cod_carrera
			where e.nota_examen not between c.nota_maxima and c.nota_minima)
	begin
		raiserror('La nota no esta en el rango esperado', 16,1)
		rollback
		return
	end
end
go

-----------------------------------------------------------------------------------
-- 4. Programar la adecuacion de los datos a la nueva regla de integridad.
-----------------------------------------------------------------------------------
update e 
	set nota_examen = case when e.nota_examen < c.nota_minima then c.nota_minima
						   when e.nota_examen > c.nota_maxima then c.nota_maxima
				      end 
	from examenes e 
		join carreras c
		  on e.cod_carrera = c.cod_carrera
	where e.nota_examen not between c.nota_minima and c.nota_maxima
go

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- REGLA DE INTEGRIDAD: Cada carrera debe tener una y solo una materia que es un 
-- trabajo final
-----------------------------------------------------------------------------------
-- 1. Determinar filas que no cumplen con la regla de integridad
-- (Carreras que no tengan trabajo final) 
-----------------------------------------------------------------------------------

select distinct m1.cod_carrera
	from materias m1		
	where not exists (select * from 
						materias m2
						where m1.cod_carrera = m2.cod_carrera
						  and m2.trabajo_final = 1) 
go

-----------------------------------------------------------------------------------
-- 2. Determinar que triggers tengo que programar
-- Que operaciones sobre que tablas influyen en la regla de integridad.
-----------------------------------------------------------------------------------
-- TABLA			INSERT			DELETE			UPDATE
-----------------------------------------------------------------------------------
-- Materias			  SI			  SI			 SI
-----------------------------------------------------------------------------------
-- Insert en materias: si inserto una materia, si en la carrera ya hay un trabajo 
-- final, no se deberia poder insertar otro trabajo final.

-- Delete en materias: si elimino una materia, y es trabajo final, no se deberia 
-- poder eliminar por que todas las carreras deben tener el trabajo final.

-- Update en carreras: debemos controlar si es un trabajo final y se quiere pasar 
-- como no trabajo, en la carrera debe haber siempre uno.
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- 3. Programar los triggers.
-----------------------------------------------------------------------------------
create trigger tri_in_materias
	on materias
		for insert
	as
	begin
		IF EXISTS (select distinct m1.cod_carrera
						from materias m1		
					where not exists (select * from 
						materias m2
					where m1.cod_carrera = m2.cod_carrera
						  and m2.trabajo_final = 1))
		begin
			raiserror('No pueden haber dos materias como trabajo final', 16,1)
			rollback
			return
		end
	end
go

create trigger tri_up_materias
	on materias
		for update
	as
		begin
			if @@ROWCOUNT > 1
				begin
					raiserror('No se pueden actualizar mas de una fila a la vez', 16, 1)
					rollback
					return
				end
			if update(trabajo_final)
				begin
					raiserror('La carrera no puede tener mas de un trabajo final', 16,1)
					rollback
					return
				end
		end
go

create trigger tri_del_materias
	on materias
		for delete
	as
	begin
		IF EXISTS (select distinct m1.cod_carrera
						from materias m1
						where not exists (select * from 
											deleted d
												join materias m2
													on d.cod_carrera = m2.cod_carrera
													and d.trabajo_final = 1
									 where m1.cod_carrera = m2.cod_carrera
										and m2.trabajo_final = 1))
		begin
			raiserror('No pueden haber dos materias como trabajo final', 16,1)
			rollback
			return
		end
	end
go

------------------------------------------------------------------------------------
-- DATO REDUNDANTE: cant_materias
------------------------------------------------------------------------------------
-- 1. Determinar el valor que tiene la columna redundante.
------------------------------------------------------------------------------------
select c.cod_carrera, c.nom_carrera, count(*) as cantidad_materias
	from carreras c
		join materias m
		  on c.cod_carrera = m.cod_carrera
	group by c.cod_carrera, c.nom_carrera
go

-----------------------------------------------------------------------------------
-- 2. Determinar que triggers tengo que programar
-----------------------------------------------------------------------------------
--  TABLA				INSERT			DELETE			UPDATE
-----------------------------------------------------------------------------------
-- Carreras				 SI				 NO				 NO
-----------------------------------------------------------------------------------
-- Materias				 SI				 SI				 SI
-----------------------------------------------------------------------------------
-- Insert en carreras: si inserto una carrera, debemos asegurar que la cantidad es 0
-- Delete en carreras: si se borra una carrera, no tengo mas materias
-- Update en carreras: si actualizo una carrera no importa el numero de materias
-----------------------------------------------------------------------------------
-- Insert en materias: si agrego una materia, debo actualizar la cantidad de materias
-- de la carrera donde se agrego.
-- Delete en materias: si elimino una materia, debo actualizar la cantidad de materias
-- de la carrera donde se elimino.
-- Update en materias: si se actualiza una materia, no modifica la cantidad de materias
-- de una carrera pero si se modifica el codigo_carrera.
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- 3. Programar los triggers 
-----------------------------------------------------------------------------------
create trigger tri_ins_materias
on materias 
	for insert 
		as
	begin
		update c
			set m.cantidad_materias = m.cantidad_materias + (select count(*)
													from inserted i1
												 where c.cod_carrera = i1.cod_carrera)
			from carreras c
			where exists(select * from inserted i
							where c.cod_carrera = i.cod_carrera)
	end
go

create trigger tri_del_materias
on materias 
	for delete
		as
	begin
		update c
			set m.cantidad_materias = m.cantidad_materias + (select count(*)
													from deleted d1
												 where c.cod_carrera = d1.cod_carrera)
			from carreras c
			where exists(select * from deleted d 
							where c.cod_carrera = d.cod_carrera)
	end
go

