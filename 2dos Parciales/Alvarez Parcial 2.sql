--------------------------------------------------------------------------------------------------------------
-- INGENIERIA EN INFORMATICA - SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL Nº 3 - TEMA D - 24-06-2021
--------------------------------------------------------------------------------------------------------------

/* -----------------------------------------------------------------------------------------------------------------------------------
   Una entidad financiera decide sistematizar la gestión de cajas de ahorros de sus clientes. 
   Del análisis de requerimientos se obtuvo lo siguiente:

   - La entidad maneja dos tipos de cuentas, y cada una tiene un límite determinado de extracciones que pueden
     realizar sus clientes por mes.
   - Un cliente puede tener más de una cuenta
   - Hay movimientos de crédito (a favor del cliente, por ejemplo un depósito) y hay movimientos de débito
     (en contra del cliente, por ejemplo, un gasto, o una extracción).

   Se implementó una base de datos a través del script siguiente:
*/

drop table mov_cajas_ahorros
drop table tipos_movimientos
drop table cajas_ahorros
drop table tipos_cuentas
drop table clientes
go

create table clientes
(
 nro_cliente		integer			not null,
 apellido			varchar(40)		not null,
 nombre				varchar(40)		not null,
 nro_documento		integer			not null
 primary key (nro_cliente),
 unique (nro_documento)
)
go

create table tipos_cuentas
(
 cod_tipo_cuenta	varchar(3)		not null,
 desc_tipo_cuenta	varchar(30)		not null,
 cant_max_ext_mes	tinyint			not null,
 primary key (cod_tipo_cuenta)
)
go

create table cajas_ahorros
(
 nro_cliente		integer			not null, 
 nro_cuenta			integer			not null, 
 cod_tipo_cuenta	varchar(3)		not null,
 primary key (nro_cuenta),
 foreign key (nro_cliente) references clientes,
 foreign key (cod_tipo_cuenta) references tipos_cuentas
)
go

create table tipos_movimientos
(
 cod_tipo_movimiento	varchar(3)		not null,
 desc_tipo_movimiento	varchar(30)		not null,
 debito_credito			char(1)			not null,
 primary key (cod_tipo_movimiento),
 check (debito_credito in ('D','C'))
)
go

create table mov_cajas_ahorros
(
 nro_cuenta				integer			not null,
 cod_tipo_movimiento	varchar(3)		not null,
 nro_movimiento			integer			not null,
 fecha_movimiento		date			not null,
 importe_movimiento		decimal(9,2)	not null,
 primary key (cod_tipo_movimiento, nro_movimiento),
 foreign key (nro_cuenta) references cajas_ahorros,
 foreign key (cod_tipo_movimiento) references tipos_movimientos
)
go

insert into clientes (nro_cliente, apellido, nombre, nro_documento)
values (1, 'APELLIDO 1', 'NOMBRE 1', 11111111),
       (2, 'APELLIDO 2', 'NOMBRE 2', 22222222),
       (3, 'APELLIDO 3', 'NOMBRE 3', 33333333)
go

insert into tipos_cuentas (cod_tipo_cuenta, desc_tipo_cuenta, cant_max_ext_mes)
values ('COM', 'Común',    3),
       ('ESP', 'Especial', 1)
go

insert into cajas_ahorros (nro_cliente, nro_cuenta, cod_tipo_cuenta)
values (1, 1,'COM'),
       (2, 2,'ESP'),
       (3, 3,'COM'),
       (1, 4,'ESP'),
       (2, 5,'COM')
go

insert into tipos_movimientos (cod_tipo_movimiento, desc_tipo_movimiento, debito_credito)
values ('DEP', 'Depósito',                  'C'),
       ('EXT', 'Extracción',                'D'),
	   ('GTO', 'Gastos administrativos',    'D'),
	   ('ACI', 'Acreditación de intereses', 'C')
go

insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (1, 'DEP', 1, '2021-03-01', 100.00),
       (1, 'EXT', 1, '2021-04-01', 100.00),
       (1, 'GTO', 1, '2021-05-10', 100.00),
       (2, 'DEP', 2, '2021-03-12', 100.00),
       (3, 'DEP', 3, '2021-04-11', 100.00),
       (3, 'ACI', 1, '2021-06-22', 100.00),
       (4, 'DEP', 4, '2021-07-15', 100.00),
       (4, 'EXT', 2, '2021-07-17', 100.00),
       (5, 'DEP', 5, '2021-07-19', 100.00),
       (5, 'ACI', 2, '2021-08-01', 100.00),
       (4, 'DEP', 6, '2021-09-15', 600.00),
       (4, 'ACI', 3, '2021-10-01', 250.00),
       (4, 'EXT', 3, '2021-10-12', 700.00),
       (4, 'GTO', 2, '2021-10-15', 100.00),
       (4, 'ACI', 4, '2021-10-22', 500.00),
       (4, 'DEP', 7, '2021-11-10', 500.00),
       (4, 'DEP', 8, '2021-11-20', 200.00),
       (4, 'EXT', 4, '2021-11-20', 1000.00),
       (4, 'GTO', 3, '2021-11-25', 200.00),
       (4, 'ACI', 5, '2021-11-30', 500.00),
       (4, 'DEP', 9, '2021-12-10', 200.00),
       (4, 'EXT', 5, '2021-12-12', 300.00)
go


/*
RESOLVER LOS SIGUIENTES EJERCICIOS:

1. Se tiene la siguiente regla de integridad: "En cada caja de ahorros, la cantidad de extracciones 
   por mes no puede superar el máximo permitido para el tipo de cuenta.
   Programar los triggers para asegurar la regla de integridad.
   
   Realizar el análisis, diseño e implementación de triggers que aseguren dicha regla, 
   desarrollando los siguientes pasos:

   a. Programar la lista de cajas de ahorros que no cumplen la regla de integridad (5)

   b. Construir una tabla gráfica que muestre las tablas involucradas (en filas), las operaciones
      de actualización sobre las tablas (en columnas) y las acciones a tener en cuenta (en celdas)(10)

   c. Programar los triggers que aseguran dicha regla de integridad, según la tabla del paso anterior.(25)

2. Programar un procedimiento almacenado que reciba como argumentos: 
   - nro. de cliente 
   - año 
   y devuelva como resultado la lista de sus cuentas que cumplan con alguno de los siguientes criterios (60):
   
   a. Tienen un saldo negativo
   b. Tienen más extracciones en algún mes que las permitidas según el tipo de cuenta
   
   Los resultados se deberán mostrar de la siguiente manera:
   ---------------------------------------------------------------------------------------------------------------------------
   nro_cuenta	desc_tipo_cuenta		     saldo	cant_max_ext_mes	mes_año		cant_ext_mes	observaciones
   ---------------------------------------------------------------------------------------------------------------------------
   xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx        xxx			xx/xxxx		    xxx			xxxxxxxxxxxxxxxxxxxxxxxxxx
   xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx        xxx			xx/xxxx		    xxx			xxxxxxxxxxxxxxxxxxxxxxxxxx
   xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx        xxx			xx/xxxx		    xxx			xxxxxxxxxxxxxxxxxxxxxxxxxx
   xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx        xxx			xx/xxxx		    xxx			xxxxxxxxxxxxxxxxxxxxxxxxxx

   Donde observaciones puede ser:
   a. Si el saldo es negativo: El saldo de la cuenta es negativo
   b. Si tiene más extracciones en algún mes que las permitidas: Tiene más extracciones que las permitidas

   Se deben mostrar ordenadas por nro_cuenta.
   
   NOTA: la cuenta aparecerá tantas veces como problemas se detecten. Es decir, si una cuenta tiene 
   saldo negativo y en dos meses tiene más extracciones que las permitidas se mostrarán 3 filas en el 
   resultado.

   En las filas en que se muestra el problema del saldo, las columnas mes_año y cant_ext_mes se mostrarán
   con valores nulos. 
   En todas las filas se debe mostrar el saldo y la cant_max_ext_mes.

   Evaluación:
   - Determinar si el saldo es negativo: 20 puntos
 
   - Determinar si tiene más extracciones: 20 puntos
  
   - Lógica y programación general del procedimiento: 20 puntos
*/


-- Tomas Alvarez
/*
1. Se tiene la siguiente regla de integridad: "En cada caja de ahorros, la cantidad de extracciones 
   por mes no puede superar el máximo permitido para el tipo de cuenta.
   Programar los triggers para asegurar la regla de integridad.
   
   Realizar el análisis, diseño e implementación de triggers que aseguren dicha regla, 
   desarrollando los siguientes pasos:

   a. Programar la lista de cajas de ahorros que no cumplen la regla de integridad (5)

   b. Construir una tabla gráfica que muestre las tablas involucradas (en filas), las operaciones
      de actualización sobre las tablas (en columnas) y las acciones a tener en cuenta (en celdas)(10)

   c. Programar los triggers que aseguran dicha regla de integridad, según la tabla del paso anterior.(25)
*/

--Devuelve cantidad de extracciones por mes segun el cliente y el mes, con un mensaje de Si - No
--Aclaracion, el mensaje no estara en la tabla del trigger

-- ALUMNO: TOMAS IGNACIO ALVAREZ PURRINOS

select ca.* ,mc.fecha_movimiento,count (left(convert(varchar, mc.fecha_movimiento, 112),6)) as extraccion_mensuales,tc.cant_max_ext_mes
from cajas_ahorros ca
	join mov_cajas_ahorros mc
	on ca.nro_cuenta = mc.nro_cuenta
	join tipos_cuentas tc
	on tc.cod_tipo_cuenta = ca.cod_tipo_cuenta
	where mc.cod_tipo_movimiento in ('EXT')
	group by ca.nro_cuenta,ca.nro_cliente,ca.cod_tipo_cuenta,mc.fecha_movimiento,tc.cant_max_ext_mes,MONTH(mc.fecha_movimiento)
	having count(left(convert(varchar, mc.fecha_movimiento, 112),6)) > tc.cant_max_ext_mes
	
-----------------------------------------------------------------------------------------------------------------------------
-- LA AGRUPACIÓN NO DEBE INCLUIR LA FECHA DE MOVIMIENTO
-- LA AGRUPACION DEBE INCLUIR: left(convert(varchar, mc.fecha_movimiento, 112),6)
-- EL COUNT DEBE SER DEL TIPO COUNT(*)
-----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------
-- PUNTOS: 0
-----------------------------------------------------------------------------------------------------------------------------

-- Con el fin de probar el codigo de arriba, agrege un movimiento de extraccion a la cuenta 4

insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (4, 'EXT', 6, '2021-10-12', 700.00)
insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (4, 'EXT', 7, '2021-11-12', 700.00)

/*
-- Este tambien puede ser usado, pero no distingue por meses
select ca.* ,mc.fecha_movimiento,count (MONTH(mc.fecha_movimiento)) as extraccion_mensuales,tc.cant_max_ext_mes
from cajas_ahorros ca
	join mov_cajas_ahorros mc
	on ca.nro_cuenta = mc.nro_cuenta
	join tipos_cuentas tc
	on tc.cod_tipo_cuenta = ca.cod_tipo_cuenta
	where mc.cod_tipo_movimiento in ('EXT')
	group by ca.nro_cuenta,ca.nro_cliente,ca.cod_tipo_cuenta,mc.fecha_movimiento,tc.cant_max_ext_mes,MONTH(mc.fecha_movimiento)
	having count (MONTH(mc.fecha_movimiento)) > tc.cant_max_ext_mes

*/


--Entonces...

-----------------------------------------------------------------------------------------------------------------------
--tablas						insert						delete						update
-----------------------------------------------------------------------------------------------------------------------
--mov_cajas_ahorros					Controlar					----					Rechazar
-----------------------------------------------------------------------------------------------------------------------

-- Al momento de insertar un movimiento, tengo que verificar que no se agregue una extraccion que sobrepase el limite

-- Tambien, al momento de updatear un movimiento, con la perspectiva de que se puede cambiar el tipo de movimiento
-- decidi simplemente rechazar todo cambio en cod_tipo_movimiento

-- La tabla tipos de cuentas se podria controlar que no se puedan cambiar la cantidad de extracciones por mes
-- pero esto limitaria la extension de estas en un futuro

-----------------------------------------------------------------------------------------------------------------------------
-- LA TABLA CAJAS_AHORROS TAMBIEN PUEDE AFECTAR LA REGLA DE INTEGRIDAD PORQUE PODRÍA CAMBIAR DE TIPO
-- LA TABLA TIPOS_CUENTAS DEBE SER CONSIDERARA, AUNQUE SEA PARA RESTRINGIR SU ACTUALIZACIÓN
-----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------
-- PUNTOS: 5
-----------------------------------------------------------------------------------------------------------------------------


create or alter trigger ti_mov_cajas_ahorros
on mov_cajas_ahorros
for insert
as
begin
	if exists(
		select ca.* ,mc.fecha_movimiento,count (left(convert(varchar, mc.fecha_movimiento, 112),6)) as extraccion_mensuales,tc.cant_max_ext_mes
		from cajas_ahorros ca
			join mov_cajas_ahorros mc
			on ca.nro_cuenta = mc.nro_cuenta
			join tipos_cuentas tc
			on tc.cod_tipo_cuenta = ca.cod_tipo_cuenta
			where mc.cod_tipo_movimiento in ('EXT')
			group by ca.nro_cuenta,ca.nro_cliente,ca.cod_tipo_cuenta,mc.fecha_movimiento,tc.cant_max_ext_mes,MONTH(mc.fecha_movimiento)
			having count(left(convert(varchar, mc.fecha_movimiento, 112),6)) > tc.cant_max_ext_mes
	)
	begin
		raiserror('Esta cuenta no puede hacer mas extracciones',16,1)
		rollback
	end
end

-----------------------------------------------------------------------------------------------------------------------------
-- NO SE RESTRINGE A LAS CUENTAS AFECTADAS
-----------------------------------------------------------------------------------------------------------------------------

create or alter trigger tu_mov_cajas_ahorros
on mov_cajas_ahorros
for update
as
begin
	if update(cod_tipo_movimiento)
	begin
		raiserror('No se puede cambiar codigo del tipo de movimiento.', 16, 1)
		rollback
	end
end

-----------------------------------------------------------------------------------------------------------------------------
-- FALTAN TRIGGERS
-----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------
-- PUNTOS: 10
-----------------------------------------------------------------------------------------------------------------------------

/*
2. Programar un procedimiento almacenado que reciba como argumentos: 
   - nro. de cliente 
   - año 
   y devuelva como resultado la lista de sus cuentas que cumplan con alguno de los siguientes criterios (60):
   
   a. Tienen un saldo negativo
   b. Tienen más extracciones en algún mes que las permitidas según el tipo de cuenta
   
   Los resultados se deberán mostrar de la siguiente manera:
   ---------------------------------------------------------------------------------------------------------------------------
   nro_cuenta	desc_tipo_cuenta		     saldo	cant_max_ext_mes	mes_año		cant_ext_mes	observaciones
   ---------------------------------------------------------------------------------------------------------------------------
   xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx        xxx			xx/xxxx		    xxx			xxxxxxxxxxxxxxxxxxxxxxxxxx
   xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx        xxx			xx/xxxx		    xxx			xxxxxxxxxxxxxxxxxxxxxxxxxx
   xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx        xxx			xx/xxxx		    xxx			xxxxxxxxxxxxxxxxxxxxxxxxxx
   xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx        xxx			xx/xxxx		    xxx			xxxxxxxxxxxxxxxxxxxxxxxxxx

   Donde observaciones puede ser:
   a. Si el saldo es negativo: El saldo de la cuenta es negativo
   b. Si tiene más extracciones en algún mes que las permitidas: Tiene más extracciones que las permitidas

   Se deben mostrar ordenadas por nro_cuenta.
   
   NOTA: la cuenta aparecerá tantas veces como problemas se detecten. Es decir, si una cuenta tiene 
   saldo negativo y en dos meses tiene más extracciones que las permitidas se mostrarán 3 filas en el 
   resultado.

   En las filas en que se muestra el problema del saldo, las columnas mes_año y cant_ext_mes se mostrarán
   con valores nulos. 
   En todas las filas se debe mostrar el saldo y la cant_max_ext_mes.

   Evaluación:
   - Determinar si el saldo es negativo: 20 puntos
 
   - Determinar si tiene más extracciones: 20 puntos
  
   - Lógica y programación general del procedimiento: 20 puntos
*/

create or alter procedure devolver_lista_problemas
(
	@nro_cliente integer,
	@anio integer
)
as
begin
	 declare @resultado table
	(
		nro_cuenta			integer,
		desc_tipo_cuenta	varchar(30),
		saldo				decimal(9,2),
		cant_max_ext_mes	tinyint,
		mes_año				varchar(10),
		cant_ext_mes		tinyint,
		observaciones		varchar(100)
	)
	
	insert into @resultado(nro_cuenta,desc_tipo_cuenta,saldo,cant_max_ext_mes,mes_año,cant_ext_mes,observaciones)
	select mc.nro_cuenta,tc.desc_tipo_cuenta,NULL,tc.cant_max_ext_mes,CONCAT(MONTH(mc.fecha_movimiento),'/',YEAR(mc.fecha_movimiento)),count(left(convert(varchar, mc.fecha_movimiento, 112),6)),'Tiene más extracciones que las permitidas'
	from cajas_ahorros ca
		join mov_cajas_ahorros mc
		on ca.nro_cuenta = mc.nro_cuenta
		join tipos_cuentas tc
		on tc.cod_tipo_cuenta = ca.cod_tipo_cuenta
	  where mc.cod_tipo_movimiento in ('EXT')
	  and ca.nro_cliente = @nro_cliente
	  and YEAR(mc.fecha_movimiento)= @anio
		group by mc.nro_cuenta,ca.nro_cliente,ca.cod_tipo_cuenta,mc.fecha_movimiento,tc.cant_max_ext_mes,ca.cod_tipo_cuenta,tc.desc_tipo_cuenta,MONTH(mc.fecha_movimiento)
		having count(left(convert(varchar, mc.fecha_movimiento, 112),6)) > tc.cant_max_ext_mes
	  order by mc.nro_cuenta
	
	insert into @resultado(nro_cuenta,desc_tipo_cuenta,saldo,cant_max_ext_mes,mes_año,cant_ext_mes,observaciones)
	select mc.nro_cuenta,tc.desc_tipo_cuenta,sum(case when mc.cod_tipo_movimiento in ('DEP','ACI') then mc.importe_movimiento else -mc.importe_movimiento end),tc.cant_max_ext_mes,null,null,'El saldo de la cuenta es negativo'
	from mov_cajas_ahorros mc
		join cajas_ahorros ca
		on ca.nro_cuenta = mc.nro_cuenta
		join tipos_cuentas tc
		on tc.cod_tipo_cuenta = ca.cod_tipo_cuenta
	where ca.nro_cliente = @nro_cliente
	and YEAR(mc.fecha_movimiento)= @anio
	group by mc.nro_cuenta,tc.desc_tipo_cuenta,tc.cant_max_ext_mes
	having sum(case when mc.cod_tipo_movimiento in ('DEP','ACI') then mc.importe_movimiento else -mc.importe_movimiento end) < 0
	order by mc.nro_cuenta

	select * from @resultado
	order by nro_cuenta
end



--Solo el cliente 1 devuelve una tabla debido a que es el unico con problemas, en ambas cuentas ( 1 - 4 )
execute devolver_lista_problemas @nro_cliente = 1, @anio = 2021


-- Aclaracion, en la fecha de mi SO el ultimo numero significa el mes.

--Estos son inserts de prueba
insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (4, 'EXT', 6, '2021-10-12', 700.00)
insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (4, 'EXT', 7, '2021-11-12', 700.00)
insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (4, 'EXT', 8, '2021-11-12', 700.00)
insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (4, 'EXT', 9, '2021-11-12', 700.00)


-- ALUMNO: TOMAS IGNACIO ALVAREZ PURRINOS


/*
--Primera parte del codigo de procedure
-- Reutilize el primer codigo, solo que devolvi los valores necesarios

select mc.nro_cuenta,tc.desc_tipo_cuenta,0,tc.cant_max_ext_mes,CONCAT(MONTH(mc.fecha_movimiento),'/',YEAR(mc.fecha_movimiento)),count (left(convert(varchar, mc.fecha_movimiento, 112),6)) as extraccion_mensuales,'Tiene más extracciones que las permitidas'
from cajas_ahorros ca
	join mov_cajas_ahorros mc
	on ca.nro_cuenta = mc.nro_cuenta
	join tipos_cuentas tc
	on tc.cod_tipo_cuenta = ca.cod_tipo_cuenta
  where mc.cod_tipo_movimiento in ('EXT')
  and ca.nro_cliente = 1
  and YEAR(mc.fecha_movimiento)= '2021'
	group by mc.nro_cuenta,ca.nro_cliente,ca.cod_tipo_cuenta,mc.fecha_movimiento,tc.cant_max_ext_mes,ca.cod_tipo_cuenta,tc.desc_tipo_cuenta,MONTH(mc.fecha_movimiento)
	having count(left(convert(varchar, mc.fecha_movimiento, 112),6)) > tc.cant_max_ext_mes



--Segunda parte del codigo de procedure
-- Devuelve nro de cuenta y suma total de los movimientos de cada cuenta si la suma es menor a 0

select mc.nro_cuenta,tc.desc_tipo_cuenta,sum(case when mc.cod_tipo_movimiento in ('DEP','ACI') then mc.importe_movimiento else -mc.importe_movimiento end),tc.cant_max_ext_mes,null,null,'El saldo de la cuenta es negativo'
from mov_cajas_ahorros mc
	join cajas_ahorros ca
	on ca.nro_cuenta = mc.nro_cuenta
	join tipos_cuentas tc
	on tc.cod_tipo_cuenta = ca.cod_tipo_cuenta
	where ca.nro_cliente = 1
	and YEAR(mc.fecha_movimiento)= '2021'
group by mc.nro_cuenta,tc.desc_tipo_cuenta,tc.cant_max_ext_mes
having sum(case when mc.cod_tipo_movimiento in ('DEP','ACI') then mc.importe_movimiento else -mc.importe_movimiento end) < 0
order by mc.nro_cuenta

*/


----------------------------------------------------------------------------
-- LA AGRUPACIÓN PARA ANALIZAR EL LIMITE DE EXTRACCIONES ESTÁ MAL. NO SE PUEDE AGRUPAR POR FECHA_MOVIMIENTO
-- ADEMÁS SE DEBE AGRUPAR POR MES-AÑO Y NO SOLO POR MES
-- ADEMÁS COMO EN EL RESULTADO SE MUESTRA MES-AÑO, ESE SELECT NO VA A FUNCIONAR
-- EL COUNT SERÍA COUNT(*) NO ES NECESARIA LA EXPRESIÓN QUE SE ESTÁ USANDO
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- a. Determinar si el saldo es negativo: 20 PUNTOS
-- b. Determinar si tiene más extracciones: 15 PUNTOS
-- Lógica general: 20 PUNTOS
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- PUNTAJE TOTAL: 70
----------------------------------------------------------------------------
