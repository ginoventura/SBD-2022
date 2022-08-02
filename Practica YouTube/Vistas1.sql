--Un club dicta cursos de distintos deportes. Almacena la información en varias tablas.
--El director no quiere que los empleados de administración conozcan la estructura de las tablas ni 
--algunos datos de los profesores y socios, por ello se crean vistas a las cuales tendrán acceso.
--1- Elimine las tablas y créelas nuevamente:
 if object_id('inscriptos') is not null  
  drop table inscriptos;
 if object_id('socios') is not null  
  drop table socios;
 if object_id('profesores') is not null  
  drop table profesores; 
 if object_id('cursos') is not null  
  drop table cursos;

 create table socios(
  documento char(8) not null,
  nombre varchar(40),
  domicilio varchar(30),
  constraint PK_socios_documento
   primary key (documento)
 );

 create table profesores(
  documento char(8) not null,
  nombre varchar(40),
  domicilio varchar(30),
  constraint PK_profesores_documento
   primary key (documento)
 );

 create table cursos(
  numero tinyint identity,
  deporte varchar(20),
  dia varchar(15),
   constraint CK_inscriptos_dia check (dia in('lunes','martes','miercoles','jueves','viernes','sabado')),
  documentoprofesor char(8),
  constraint PK_cursos_numero
   primary key (numero),
 );

 create table inscriptos(
  documentosocio char(8) not null,
  numero tinyint not null,
  matricula char(1),
  constraint CK_inscriptos_matricula check (matricula in('s','n')),
  constraint PK_inscriptos_documento_numero
   primary key (documentosocio,numero)
 );

--2- Ingrese algunos registros para todas las tablas:
 insert into socios values('30000000','Fabian Fuentes','Caseros 987');
 insert into socios values('31111111','Gaston Garcia','Guemes 65');
 insert into socios values('32222222','Hector Huerta','Sucre 534');
 insert into socios values('33333333','Ines Irala','Bulnes 345');

 insert into profesores values('22222222','Ana Acosta','Avellaneda 231');
 insert into profesores values('23333333','Carlos Caseres','Colon 245');
 insert into profesores values('24444444','Daniel Duarte','Sarmiento 987');
 insert into profesores values('25555555','Esteban Lopez','Sucre 1204');

 insert into cursos values('tenis','lunes','22222222');
 insert into cursos values('tenis','martes','22222222');
 insert into cursos values('natacion','miercoles','22222222');
 insert into cursos values('natacion','jueves','23333333');
 insert into cursos values('natacion','viernes','23333333');
 insert into cursos values('futbol','sabado','24444444');
 insert into cursos values('futbol','lunes','24444444');
 insert into cursos values('basquet','martes','24444444');

 insert into inscriptos values('30000000',1,'s');
 insert into inscriptos values('30000000',3,'n');
 insert into inscriptos values('30000000',6,null);
 insert into inscriptos values('31111111',1,'s');
 insert into inscriptos values('31111111',4,'s');
 insert into inscriptos values('32222222',8,'s');

 select * from socios
 select * from profesores
 select * from cursos
 select * from inscriptos

-- Eliminar la vista vista_club si existe
if OBJECT_ID('vista_club') is not null
	drop view vista_club

--Crear una vista en la que aparezca el nombre y documento del socio, el deporte,
--el dia y el nombre del profesor
create view vista_club 
	as
		select s.nombre as socio, s.documento as documentosocio, c.deporte, c.dia, p.nombre as profesor, matricula
			from socios s
		join inscriptos i
			on s.documento = i.documentosocio
		join cursos c
			on i.numero = c.numero
		join profesores p 
			on c.documentoprofesor = p.documento
go

--Vemos la informacion de la vista
select * from vista_club
select * from socios
select * from cursos
select * from inscriptos
select * from profesores
	
--Realice una consulta a la vista donde muestre la cantidad de socios inscriptos
--en cada deporte ordenados por cantidad
select deporte, count(*) as cantidadinscriptos
	from vista_club
	group by deporte
	order by cantidadinscriptos

--Muestre consultando la vista los cursos (deporte y dia) para los cuales no hay
--inscriptos.

select deporte, dia from vista_club
	where matricula is null

--Muestre los nombres de los socios que no se han inscripto en ningun curso consultando
--la vista
select distinct socio, documentosocio from vista_club
	where deporte is not null 
		  and matricula is null 
go

--Muestre consultando la vista los profesores que no tienen asignado ningun deporte
--aun
select distinct p.documento, p.nombre from profesores p
	left join cursos c
	on p.documento = c.documentoprofesor
	where c.deporte is NULL

--Muestre consultando la vista el nombre y documento de los socios que deben matriculas
select * from vista_club
	where matricula = 'n'

--Muestre consultando la vista, el nombre y los dias en que asisten los profesores
--a dictar clases al club
select profesor, dia from vista_club
	order by dia
	
--Muestre los socios compañeros en tenis los lunes
select socio as compañeros_tenis from vista_club 
	where deporte = 'tenis'
		  and dia = 'lunes'
go

--Elimine la vista_inscriptos si existe y creela para mostrar la cantidad de inscriptos
--por curso, incluyendo el numero curso, nombre del deporte y dia
 select * from socios
 select * from cursos
 select * from inscriptos

if OBJECT_ID('vista_inscriptos') is not null
	drop view vista_inscriptos

create view vista_inscriptos 
	as
	select c.deporte, c.dia, (select count(*) from inscriptos i
							  where i.numero = c.numero) as cantidad
			from cursos c
go
select * from vista_inscriptos