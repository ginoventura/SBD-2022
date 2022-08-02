
create table sucursales
(nro_sucursal	smallint	not null,
 nom_sucursal	varchar(20)	not null,
 dir_sucursal	varchar(20)	not null,
 constraint PK__sucursales__END primary key (nro_sucursal),
 constraint UK__sucursales__END	unique	(nom_sucursal)
)
go

create table clientes
(nro_sucursal	smallint	not null,
 nro_cliente	smallint	not null,
 nom_cliente	varchar(20)	not null,
 dni_cliente	integer		not null,
 dir_cliente	varchar(20)	null,
 cat_cliente	char(1)		not null,
 constraint PK__clientes__END	primary key (nro_cliente,nro_sucursal),
 constraint UK__clientes__END	unique		(dni_cliente),
 constraint FK__clientes__sucursales__END	foreign key (nro_sucursal) references sucursales,
 constraint CK__clientes__cat_cliente__END	check(cat_cliente in ('A','B','C'))
)
go


create table tipos_cuentas
(tipo_cuenta		varchar(10)		not null,
 cant_max_ext_mes	decimal(8,2)	not null,
 saldo_minimo		decimal(8,2)	not null,
 constraint PK__tipos_cuentas__END	primary key (tipo_cuenta),
 constraint CK__tipos_cuentas__saldo_minimo__END check(saldo_minimo >= 0)
)
go

create table cajas_ahorros
(nro_sucursal	smallint	not null,
 nro_cuenta		smallint	not null,
 estado			varchar(10)	not null,
 tipo_cuenta	varchar(10)	not null,
 constraint PK__cajas_ahorros__END	primary key (nro_cuenta,nro_sucursal),
 constraint FK__cajas_ahorros__tipos_cuentas__END foreign key (tipo_cuenta) references tipos_cuentas,
 constraint CK__cajas_ahorros__estado__END	check(estado in ('CERRADA','ABIERTA'))
)
go

create table clientes_cajas
(nro_sucursal	smallint	not null,
 nro_cuenta		smallint	not null,
 nro_cliente	smallint	not null,
 constraint PK__clientes_cajas__END	primary key (nro_sucursal,nro_cuenta,nro_cliente),
 constraint FK__clientes_cajas__clientes__END foreign key (nro_cliente,nro_sucursal) references clientes,
 constraint FK__clientes_cajas__cajas_ahorros__END foreign key (nro_cuenta,nro_sucursal) references cajas_ahorros
)
go

create table mov_cuentas
(nro_sucursal	smallint		not null,
 nro_cuenta		smallint		not null,
 fecha_mov		date			not null,
 cod_mov		char(3)			not null,
 nro_mov		smallint		not null,
 importe_mov	decimal(8,2)	not null,
 constraint	PK__mov_cuentas__END	primary key (nro_mov,cod_mov,nro_sucursal),
 constraint FK__mov_cuentas__cajas_ahorros foreign key (nro_cuenta,nro_sucursal) references cajas_ahorros,
 constraint CK__mov_cuenta__cod_mov__END	check(cod_mov in ('DEP','EXT','ACI','GTO'))
)
go


insert into sucursales	(nro_sucursal	,nom_sucursal	,dir_sucursal)
values					(1				,'SUCURSAL 1'	,'DIR SUC 1'),
						(2				,'SUCURSAL 2'	,'DIR SUC 2'),
						(3				,'SUCURSAL 3'	,'DIR SUC 3'),
						(4				,'SUCURSAL 4'	,'DIR SUC 4'),
						(5				,'SUCURSAL 5'	,'DIR SUC 5')
go

insert into clientes	(nro_cliente	,nro_sucursal	,nom_cliente	,dni_cliente	,dir_cliente	,cat_cliente)
values					(1				,1				,'CLIENTE 1'	,1				,'DIR CLIENTE 1','A'),
						(2				,1				,'CLIENTE 2'	,2				,'DIR CLIENTE 2','B'),
						(3				,2				,'CLIENTE 3'	,3				,'DIR CLIENTE 3','C'),
						(4				,2				,'CLIENTE 4'	,4				,'DIR CLIENTE 4','A'),
						(5				,3				,'CLIENTE 5'	,5				,'DIR CLIENTE 5','B'),
						(6				,3				,'CLIENTE 6'	,6				,'DIR CLIENTE 6','C'),
						(7				,4				,'CLIENTE 7'	,7				,'DIR CLIENTE 7','A'),
						(8				,4				,'CLIENTE 8'	,8				,'DIR CLIENTE 8','B'),
						(9				,5				,'CLIENTE 9'	,9				,'DIR CLIENTE 9','C')
go

insert into tipos_cuentas	(tipo_cuenta	,saldo_minimo	,cant_max_ext_mes)
values						('CUENTA A'		,10000.00		,50000.00),
							('CUENTA B'		,5000.00		,25000.00),
							('CUENTA C'		,1000.00		,5000.00)
go


insert into cajas_ahorros	(nro_cuenta	,nro_sucursal	,estado		,tipo_cuenta)
values						(1			,1				,'ABIERTA'	,'CUENTA A'),
							(2			,1				,'ABIERTA'	,'CUENTA C'),
							(3			,2				,'ABIERTA'	,'CUENTA B'),
							(4			,3				,'ABIERTA'	,'CUENTA B'),
							(5			,4				,'CERRADA'	,'CUENTA A'),
							(6			,4				,'CERRADA'	,'CUENTA A'),
							(7			,4				,'CERRADA'	,'CUENTA A'),
							(8			,5				,'CERRADA'	,'CUENTA A')
go

insert into clientes_cajas	(nro_cliente	,nro_cuenta	,nro_sucursal)
values						(1				,1			,1),
							(1				,2			,1),
							(2				,2			,1),
							(3				,3			,2),
							(4				,3			,2),
							(5				,4			,3),
							(6				,4			,3),
							(7				,5			,4),
							(8				,6			,4),
							(8				,7			,4),
							(9				,8			,5)
go


insert into mov_cuentas	(nro_mov	,cod_mov	,nro_cuenta	,nro_sucursal		,fecha_mov		,importe_mov)
values					(1			,'DEP'		,1			,1				,'1996-03-02'	,1000.00),
						(1			,'GTO'		,1			,1				,'1997-03-02'	,2500.00),
						(2			,'EXT'		,2			,1				,'2015-03-15'	,3000.00),
						(3			,'DEP'		,3			,2				,'1998-01-01'	,2000.00),
						(4			,'ACI'		,6			,4				,'1998-01-01'	,500.00),
						(2			,'DEP'		,2			,1				,'2014-03-02'	,2500.00),
						(100		,'DEP'		,1			,1				,'1995-04-09'	,5000.00),
						(101		,'EXT'		,6			,4				,'1997-02-01'	,500.00)
						
						(3			,'DEP'		,3			,2				,'2014-03-02'	,2500.00),
						(4			,'DEP'		,3			,2				,'2014-03-02'	,2500.00),
						(5			,'DEP'		,4			,3				,'2014-03-02'	,10000.00),
						(6			,'DEP'		,2			,1				,'2014-03-02'	,10000.00),
						(7			,'EXT'		,3			,2				,'2014-03-02'	,10000.00),
						(8			,'EXT'		,4			,3				,'2014-03-02'	,1000.00),
						(9			,'EXT'		,5			,4				,'2014-03-02'	,1000.00),
						(3			,'ACI'		,8			,5				,'2014-03-02'	,5000.00),
						(4			,'ACI'		,2			,1				,'2014-03-02'	,5000.00),
						(5			,'GTO'		,2			,1				,'2014-03-02'	,5000.00),
						(6			,'GTO'		,7			,4				,'2014-03-02'	,5000.00),
						(7			,'GTO'		,8			,5				,'2014-03-02'	,1000.00)
go

-- a.	Mostrar nom_cliente de aquellos clientes que tienen más de una caja de ahorros en la sucursal cuyo nombre es ‘CENTRO’, con saldo > 0 y 
--		sin movimientos desde el 01/01/1998. (20)
--	NOTA: El saldo se obtiene sumando y restando todos los importes de movimientos de cuentas, 
--	teniendo en cuenta que los movimientos DEP y ACI son positivos y EXT y GTO son negativos.

-- clientes con mas de 1 caja en la sucursal 1 (no tenia ganas de ponerme a modifcar el insert para tener nom sucursal=CENTRO
create view v_clientes_mas_1_caja (nro_cliente,nom_cliente)
as
select c.nro_cliente,c.nom_cliente
	from cajas_ahorros ca
	join clientes_cajas cc
		on ca.nro_cuenta=cc.nro_cuenta
		and ca.nro_sucursal=cc.nro_sucursal
	join clientes c
		on c.nro_cliente=cc.nro_cliente
		and c.nro_sucursal=cc.nro_sucursal
	join sucursales s
		on c.nro_sucursal=s.nro_sucursal
	where s.nom_sucursal='SUCURSAL 1'
	group by c.nro_cliente,c.nom_cliente
	having count(*)>1

-- saldo
create view v_saldos (nro_cuenta, nro_sucursal, saldo)
as
select m.nro_cuenta,m.nro_sucursal,sum(case when m.cod_mov='DEP' or m.cod_mov='ACI' then m.importe_mov else -m.importe_mov end) saldo
	from mov_cuentas m
	group by m.nro_cuenta,m.nro_sucursal

-- sin movimientos a partir del 01/01/1998
create view v_sin_mov_98(nro_sucursal,nro_cliente,nom_cliente,nro_cuenta)
as
select c.nro_sucursal,c.nro_cliente,nom_cliente,nro_cuenta
	from clientes c
		join clientes_cajas cc
	on c.nro_cliente=cc.nro_cliente
	and cc.nro_sucursal=c.nro_sucursal
	where not exists(select *
						from mov_cuentas m
						where m.fecha_mov>='1998-01-01'
							and c.nro_cliente=cc.nro_cliente
							and c.nro_sucursal=m.nro_sucursal
							and m.nro_cuenta=cc.nro_cuenta)
		and exists(select *											-- si le agrego este exists, serian los clientes que no tienen movimientos a partir del 98
					from mov_cuentas m								-- pero si de antes
					where m.fecha_mov<'1998-01-01'
					and c.nro_cliente=cc.nro_cliente
					and c.nro_sucursal=m.nro_sucursal
					and m.nro_cuenta=cc.nro_cuenta)

select c.nom_cliente
	from v_clientes_mas_1_caja c
	join v_sin_mov_98	m
		on c.nro_cliente=m.nro_cliente
	join v_saldos s
		on s.nro_cuenta=m.nro_sucursal
		and s.nro_cuenta=m.nro_cuenta
	where s.saldo>0

-- b.	Mostrar nro_cuenta, tipo_cuenta correspondiente a las cajas de ahorros de la sucursal cuyo nombre es ‘VILLA BELGRANO’ que 
--		tienen un total de gastos (cod_mov = ‘GTO’) mayor al total de intereses (cod_mov = ‘ACI’). (20)

-- cajas de ahorro de la sucursal villa belgrano
select *
	from cajas_ahorros ca
	join sucursales s
		on s.nro_sucursal=ca.nro_sucursal
	where s.nom_sucursal='SUCURSAL 1'


select aux1.nro_cuenta,t.tipo_cuenta
	from (
			select m.nro_cuenta,m.nro_sucursal, sum(case when aux1.importe_mov is null then 0 else m.importe_mov end) as gastos
				from (select * 
						from mov_cuentas m
							where m.cod_mov='GTO')aux1
				right join mov_cuentas m
					on aux1.cod_mov=m.cod_mov
				and aux1.nro_cuenta=m.nro_cuenta
				and aux1.nro_sucursal=m.nro_sucursal
				group by m.nro_cuenta,m.nro_sucursal)aux1
	join
		(select m.nro_cuenta,m.nro_sucursal, sum(case when aux1.importe_mov is null then 0 else m.importe_mov end) as intereses
			from (select * 
					from mov_cuentas m
						where m.cod_mov='ACI')aux1
			right join mov_cuentas m
				on aux1.cod_mov=m.cod_mov
			and aux1.nro_cuenta=m.nro_cuenta
			and aux1.nro_sucursal=m.nro_sucursal
			group by m.nro_cuenta,m.nro_sucursal)aux2
		on aux1.nro_cuenta=aux2.nro_cuenta
		and aux1.nro_sucursal=aux2.nro_sucursal
	join cajas_ahorros ca
		on ca.nro_cuenta=aux2.nro_cuenta
		and ca.nro_sucursal=aux2.nro_sucursal
	join tipos_cuentas t
		on t.tipo_cuenta=ca.tipo_cuenta
	join sucursales s
		on s.nro_sucursal=ca.nro_sucursal
	where aux1.gastos>aux2.intereses
	and s.nom_sucursal='SUCURSAL 1'
go


-- c.	Mostrar nom_sucursal, tipo_cuenta y cantidad de cuentas con saldo = 0, que tenga como titulares por lo menos a algún cliente de categoría ‘A’. (20)

select s.nom_sucursal,c.tipo_cuenta,c.cuentas_con_saldo_0
	from v_suc_con_1_cliente_A s
	join v_cuentas_con_saldo_0 c
		on s.nro_sucursal=c.nro_sucursal


create view v_cuentas_con_saldo_0 (nro_sucursal,tipo_cuenta,cuentas_con_saldo_0)
as
select s.nro_sucursal,ca.tipo_cuenta,sum(case when s.saldo=0 then 1 else 0 end) cuentas_con_saldo_0
	from v_saldos s
	join cajas_ahorros ca
		on s.nro_cuenta=ca.nro_cuenta
		and s.nro_sucursal=ca.nro_sucursal
	group by s.nro_sucursal,ca.tipo_cuenta


-- sucursales con al menos 1 cliente de categoria A
create view v_suc_con_1_cliente_A (nro_sucursal,nom_sucursal,dir_sucursal)
as
select *
	from sucursales s
	where exists (select *
					from cajas_ahorros ca
					where ca.tipo_cuenta='CUENTA A'
					and ca.nro_sucursal=s.nro_sucursal)

go

-- d.	Agregar la columna saldo a la tabla cajas_ahorros y programar un update de dicha columna para actualizar todos saldos de las cuentas. (20)

select *
	from cajas_ahorros

alter table cajas_ahorros
add saldo	decimal(8,2) null

select *
	from cajas_ahorros

update ca
	set saldo=s.saldo
	from cajas_ahorros ca
	join v_saldos s
		on s.nro_cuenta=ca.nro_cuenta
		and s.nro_sucursal=ca.nro_sucursal




