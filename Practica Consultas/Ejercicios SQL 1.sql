drop table emp
drop table cargos
drop table deptos
go

create table deptos
(nro_depto 		tinyint		not null,
 nom_depto		varchar(20)	not null,
 constraint PK__deptos__END primary key (nro_depto)
)
go

create table cargos
(nro_cargo 		tinyint		not null,
 nom_cargo		varchar(20)	not null,
 constraint PK__cargos__END primary key (nro_cargo)
)
go

create table emp
(nro_emp		integer			not null,
 nom_emp		varchar(20)		not null,
 cargo			tinyint			not null,
 salario		decimal(8,2)	not null,
 fecha_ingreso	date			not null,
 nro_depto		tinyint			not null,
 director		integer			null,
 constraint PK__emp__END primary key (nro_emp),
 constraint FK__emp__cargos__1__END foreign key (cargo)     references cargos,
 constraint FK__emp__deptos__1__END foreign key (nro_depto) references deptos,
 constraint FK__emp__emp__1__END    foreign key (director)  references emp
)
go

insert into deptos (nro_depto, nom_depto)
values (10, 'CONTABILIDAD'),
       (20, 'COMPRAS'),
       (30, 'VENTAS'),
       (40, 'PRODUCCION')
go

insert into cargos (nro_cargo, nom_cargo)
values (1, 'PRESIDENTE'),
       (2, 'DIRECTOR'),
       (3, 'ADMINISTRATIVO'),
       (4, 'VENDEDOR')
go

insert into emp (nro_emp, nom_emp, cargo, salario, fecha_ingreso, nro_depto, director)
values (1, 'PEREZ',				1, 3500.00, '2000-01-01', 10, null),
       (2, 'RODRIGUEZ',			2, 2500.00, '1999-01-01', 10, 1),
       (3, 'LOPEZ',				2, 2500.00, '2000-01-01', 20, 1),
       (4, 'DOMINGUEZ',			2, 2500.00, '1999-07-01', 30, 1),
       (5, 'GONZALEZ',			3, 1500.00, '2000-07-01', 10, 2),
       (6, 'MONTERO GONZALEZ',	4, 1200.00, '2000-05-01', 10, 2),
       (7, 'SANCHEZ',			3, 1500.00, '2000-08-01', 20, 3),
       (8, 'JIMENEZ',			3, 1500.00, '1999-12-01', 20, 3),
       (9, 'MARIANI',			4, 1500.00, '2000-02-01', 30, 4),
       (10, 'GIULIANI',			4, 1000.00, '2000-03-01', 30, 4)
go

/*
EJERCICIOS:

1.	(nom_emp, nro_depto) de todos los empleados
2.	(todos los datos) de los empleados con salario entre 1500 y 2000
3.	(nro_emp, nom_emp, salario) de los empleados con cargo 'VENDEDOR' o 'ADMINISTRATIVO'
4.	(nom_emp, nom_depto) de todos los empleados
5.	(nom_emp) de los empleados del departamento 'CONTABILIDAD'
6.	(nom_depto) de los departamentos que tengan empleados
7.	(nom_depto) de los departamentos que tengan empleados con cargo 'VENDEDOR'
8.	(nom_depto) de los departamentos que no tengan empleados con cargo 'VENDEDOR'
9.	(nro_emp) de los empleados que trabajan en el mismo departamento que el empleado 'JIMENEZ'
10.	(nro_emp) de los empleados más antiguos que el 'PRESIDENTE'
11.	(nom_depto) de los departamentos que tienen empleados en todos los cargos
12.	(nro_emp, nom_emp, salario_anual) de los empleados con cargo 'VENDEDOR'. (salario_anual = salario*12)
13.	Cantidad de empleados por departamento (nom_depto, cantidad)
14.	Máximo, mínimo y promedio de salarios por departamento (nom_depto, máximo, mínimo, promedio)
15.	Máximo, mínimo y promedio de salarios (máximo, mínimo, promedio)
16.	(nom_depto) de los departamentos que tengan más de 3 empleados
17.	(nro_emp,nro_depto) de los empleados con menor salario en cada departamento
18.	(nro_emp,nro_depto) de los empleados con salario mayor al promedio del departamento
19.	(nro_emp) de los empleados con menor salario que el mayor salario del departamento nro. 30
*/

select * from emp
select * from cargos
select * from deptos

-- RESPUESTAS EJERCICIOS

-- 1) (nom_emp, nro_depto) de todos los empleados
select e.nom_emp, e.nro_depto
	from emp e
go

-- 2) (todos los datos) de los empleados con salario entre 1500 y 2000
select * from 
	emp e
	where e.salario between 1500 and 2000
go

--3) (nro_emp, nom_emp, salario) de los empleados con cargo 'VENDEDOR' o 'ADMINISTRATIVO'
select e.nro_emp, e.nom_emp, e.salario, c.nom_cargo
	from emp e
		join cargos c
		on e.cargo = c.nro_cargo
	where c.nom_cargo = 'VENDEDOR' or 
		  c.nom_cargo = 'ADMINISTRATIVO'
go

-- 4) (nom_emp, nom_depto) de todos los empleados
select e.nom_emp, d.nom_depto 
	from emp e
		join deptos d
			on e.nro_depto = d.nro_depto
go

-- 5) (nom_emp) de los empleados del departamento 'CONTABILIDAD'
select e.nom_emp, d.nom_depto
	from emp e
	join deptos d
		on e.nro_depto = d.nro_depto
	where d.nom_depto = 'CONTABILIDAD'
go

-----------------------------------------------------------
select * from emp
select * from cargos
select * from deptos
go
-----------------------------------------------------------

-- 6) (nom_depto) de los departamentos que tengan empleados
select *												-- Muestra tal dato
	from deptos d										-- de la tabla departamentos	
	where exists(select *								-- para los cuales existe alguna fila
					from emp e							-- resultado de esta subconsulta
					where d.nro_depto = e.nro_depto)	-- si esta consulta devuelve alguna fila, el depto es seleccionado

-- 7) (nom_depto) de los departamentos que tengan empleados con cargo 'VENDEDOR'
select distinct d.nom_depto, d.nro_depto
	from emp e
		join deptos d
			on e.nro_depto = d.nro_depto
		join cargos c
			on e.cargo = c.nro_cargo
		where nom_cargo = 'VENDEDOR'
go

-- 8) (nom_depto) de los departamentos que no tengan empleados con cargo 'VENDEDOR'
select *	
	from deptos d
	where exists (select *			-- departamentos para los cuales existen empleados
					from emp e
				  where d.nro_depto = e.nro_depto)
	and NOT exists (select *		-- y que no tengan vendedores
					 from emp e	
						join cargos c
							on e.cargo = c.nro_cargo
				  where d.nro_depto = e.nro_depto
							and c.nom_cargo = 'VENDEDOR')
go

-- 9) (nro_emp) de los empleados que trabajan en el mismo departamento que el empleado 'JIMENEZ'
select e1.nro_emp							-- muestra tal dato	
	from emp e1, emp e2						-- de las tablas emp1, emp2
where e1.nro_depto = e2.nro_depto			-- donde el depto de e1 sea igual al depto e2
	and e1.nom_emp <> 'JIMENEZ'				-- y el e1.nom_emp sea distinto a jimenez
	and e2.nom_emp = 'JIMENEZ'				-- y el e2.nom_emp sea igual a jimenez
go

-- 10) (nro_emp) de los empleados más antiguos que el 'PRESIDENTE'
select e.nro_emp
	from emp e
	where e.fecha_ingreso < (select e.fecha_ingreso
			from emp e
				join cargos c
					on e.cargo = c.nro_cargo 
			where c.nom_cargo = 'PRESIDENTE')
go

-- 11) (nom_depto) de los departamentos que tienen empleados en todos los cargos
SELECT d.nom_depto
          FROM deptos d
       WHERE NOT EXISTS (SELECT *
                            FROM emp e1
                                WHERE NOT EXISTS (SELECT *
													FROM emp e2 
													WHERE e2.nro_depto = d.nro_depto
													AND e2.cargo = e1.cargo))
go

-- 12) (nro_emp, nom_emp, salario_anual) de los empleados con cargo 'VENDEDOR'. (salario_anual = salario*12)
select e.nro_emp, e.nom_emp, salario as salario_mensual, (e.salario*12) as salario_anual from 
	emp e
		join cargos c
			on e.cargo = c.nro_cargo
	where c.nom_cargo = 'VENDEDOR'
go

-- 13) Cantidad de empleados por departamento (nom_depto, cantidad)
select d.nom_depto, count(d.nom_depto) as cantidad_empleados
	from emp e
		join deptos d
		on e.nro_depto = d.nro_depto
	group by(d.nom_depto)
go

-- 14) Máximo, mínimo y promedio de salarios por departamento (nom_depto, máximo, mínimo, promedio)
select d.nom_depto, MAX(e.salario) as salario_maximo, MIN(e.salario) as salario_minimo, AVG(e.salario) as salario_promedio 
	from emp e
		join deptos d
		on e.nro_depto = d.nro_depto
	group by(d.nom_depto)
go

-- 15) Máximo, mínimo y promedio de salarios (máximo, mínimo, promedio)
select MAX(e.salario) as salario_maximo, MIN(e.salario) as salario_minimo, AVG(e.salario) as salario_promedio
	from emp e
go

-- 16) (nom_depto) de los departamentos que tengan más de 3 empleados
select d.nom_depto, count(d.nom_depto) as cantidad_empleados
	from emp e
		join deptos d
		on e.nro_depto = d.nro_depto
	group by(d.nom_depto)
	having count(*) > 3
go

-- 17) (nro_emp,nro_depto) de los empleados con menor salario en cada departamento
select d.nro_depto, d.nom_depto, min(e.salario) as salario_minimo
	from emp e
		join deptos d
			on e.nro_depto = d.nro_depto
	group by d.nro_depto, d.nom_depto
go

-- 18) (nro_emp,nro_depto) de los empleados con salario mayor al promedio del departamento
select e1.nro_emp, e1.nro_depto, e1.nom_emp, e1.salario
	from emp e1
	where e1.salario > (select avg(e2.salario) as salario_prom_depto
							from emp e2
						where e2.nro_depto = e1.nro_depto)
go

-- 19) (nro_emp) de los empleados con menor salario que el mayor salario del departamento nro. 30
select e1.nro_emp, e1.salario 
	from emp e1
	where e1.salario < (select max(e2.salario)
						from emp e2 
						where e2.nro_depto = 30)
go


