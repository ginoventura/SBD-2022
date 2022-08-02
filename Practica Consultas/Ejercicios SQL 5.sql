drop table dbo.emp
drop table dbo.cargos
drop table dbo.deptos
go

create table dbo.deptos
(
 nro_depto 		tinyint		not null,
 nom_depto		varchar(20)	not null,
 constraint PK__dbo_deptos__END primary key (nro_depto)
)
go

create table dbo.cargos
(
 nro_cargo 		integer		not null,
 nom_cargo		varchar(20)	not null,
 constraint PK__dbo_cargos__END primary key (nro_cargo)
)
go

create table dbo.emp
(
 nro_emp		integer			not null,
 nom_emp		varchar(20)		not null,
 cargo			integer			not null,
 salario		decimal(8,2)	not null,
 porc_comision	decimal(4,2)	null,
 fecha_ingreso	date			not null,
 nro_depto		tinyint			not null,
 director		integer			null,
 constraint PK__dbo_emp__END						  primary key (nro_emp),
 constraint FK__dbo_emp__dbo_cargos__1__END           foreign key (cargo)     references dbo.cargos
                                                      on delete cascade
													  on update cascade,
 constraint FK__dbo_emp__dbo_deptos__1__END           foreign key (nro_depto) references dbo.deptos,
 constraint FK__dbo_emp__dbo_emp__1__END              foreign key (director)  references dbo.emp,
 constraint CK__dbo_emp__salario__END                 check (salario > 0.00),
 constraint CK__dbo_emp__comision_vendedor__END       check (cargo  = 4 and porc_comision is not null or
                                                             cargo != 4 and porc_comision is null)
)
go

insert into dbo.deptos (nro_depto, nom_depto)
values (10, 'CONTABILIDAD'),
       (20, 'COMPRAS'),
       (30, 'VENTAS'),
       (40, 'PRODUCCION')
go

insert into dbo.cargos (nro_cargo, nom_cargo)
values (1, 'PRESIDENTE')
insert into dbo.cargos (nro_cargo, nom_cargo)
values (2, 'DIRECTOR')
insert into dbo.cargos (nro_cargo, nom_cargo)
values (3, 'ADMINISTRATIVO')
insert into dbo.cargos (nro_cargo, nom_cargo)
values (4, 'VENDEDOR')
insert into dbo.cargos (nro_cargo, nom_cargo)
values (5, 'ADMINISTRATIVO SR')
go

insert into dbo.emp (nro_emp, nom_emp, cargo, salario, porc_comision, fecha_ingreso, nro_depto, director)
values ( 1, 'PEREZ',            1, 3500.00, NULL, '2000-01-01', 10, null),
       ( 2, 'RODRIGUEZ',        2, 2500.00, NULL, '1999-01-01', 10, 1),
       ( 3, 'LOPEZ',            2, 2500.00, NULL, '2000-01-01', 20, 1),
       ( 4, 'DOMINGUEZ',        2, 2500.00, NULL, '1999-07-01', 30, 1),
       ( 5, 'GONZALEZ',         3, 1500.00, NULL, '2000-07-01', 10, 2),
       ( 6, 'MONTERO GONZALEZ', 4, 1200.00, 1.50, '2000-05-01', 10, 2),
       ( 7, 'SANCHEZ',          3, 1500.00, NULL, '2000-08-01', 20, 3),
       ( 8, 'JIMENEZ',          3, 1500.00, NULL, '1999-12-01', 20, 3),
       ( 9, 'MARIANI',          4, 1500.00, 3.00, '2000-02-01', 30, 4),
       (10, 'GIULIANI',         4, 1000.00, 2.15, '2000-03-01', 30, 4)
go

select * from emp
select * from deptos
select * from cargos
go