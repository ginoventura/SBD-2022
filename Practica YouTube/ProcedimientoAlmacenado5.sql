--Un profesor guarda en una tabla llamada "alumnos" el nombre de los alumnos y su nota.
--1- Elimine la tabla si existe y créela:
 if object_id('alumnos') is not null
  drop table alumnos;

 create table alumnos(
  documento char(8),
  nombre varchar(40),
  nota decimal(4,2),
  primary key(documento)
 );

 insert into alumnos values ('22222222','Pedro Lopez',5);
 insert into alumnos values ('23333333','Ana Lopez',4);
 insert into alumnos values ('24444444','Maria Juarez',8);
 insert into alumnos values ('25555555','Juan Garcia',5.6);
 insert into alumnos values ('26666666','Karina Torres',2);
 insert into alumnos values ('27777777','Nora Torres',7.5);
 insert into alumnos values ('28888888','Mariano Herrero',3.5);

--3- Elimine la tabla "aprobados" si existe y créela con los mismos campos de la tabla "alumnos":
 if object_id('aprobados') is not null
  drop table aprobados;

 create table aprobados(
  documento char(8),
  nombre varchar(40),
  nota decimal(4,2)
 );

--4- Elimine la tabla "desaprobados" si existe y créela con los siguientes campos:
 if object_id('desaprobados') is not null
  drop table desaprobados;

 create table desaprobados(
  documento char(8),
  nombre varchar(40),
  nota decimal(4,2)
 );

--5- Elimine el procedimiento llamado "pa_aprobados", si existe:
 if object_id('pa_aprobados') is not null
  drop procedure pa_aprobados;

--6- Cree el procedimiento para que seleccione todos los datos de los alumnos cuya 
--nota es igual o superior a 4.
create procedure pa_aprobados 
	as 
	select * 
	from alumnos 
	where nota >= 4
	order by nota
go

--7- Ingrese en la tabla "aprobados" el resultado devuelto por el procedimiento 
--almacenado "pa_aprobados".
select * from aprobados
insert into aprobados exec pa_aprobados
select * from aprobados

--9- Elimine el procedimiento llamado "pa_desaprobados", si existe:
 if object_id('pa_desaprobados') is not null
  drop procedure pa_desaprobados;

--10- Cree el procedimiento para que seleccione el documento y nombre de los alumnos 
--cuya nota es menor a 4.
create procedure pa_desaprobados
	as 
	select * 
	from alumnos
	where nota < 4
	order by nota
go

select * from desaprobados
insert into desaprobados exec pa_desaprobados
select * from desaprobados