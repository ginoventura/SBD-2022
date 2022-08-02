drop table det_ordenes_compra
drop table ordenes_compra
drop table proveedores_productos
drop table proveedores
drop table productos
go

create table productos
(
 nro_producto 		integer,
 nom_producto 		varchar(40),
 stock				integer
 primary key (nro_producto)
)
go

create table proveedores
(
 nro_proveedor 		integer primary key,
 nom_proveedor 		varchar(40)
)
go

create table proveedores_productos
(
 nro_proveedor 		integer references proveedores,
 nro_producto		integer references productos,
 precio_producto	decimal(10,2),
 dias_entrega		tinyint,
 categoria			char(1),
 primary key (nro_proveedor, nro_producto),
 unique (nro_producto, categoria)
)
go

create table ordenes_compra
(
 nro_orden_compra 	integer primary key,
 nro_proveedor 		integer references proveedores,
 fecha_orden_compra datetime,
 anulada			char(1) default 'N' check (anulada in ('S','N'))
)
go

create table det_ordenes_compra
(
 nro_orden_compra 	integer references ordenes_compra,
 nro_producto 		integer references productos,
 fecha_entrega 		datetime,
 cantidad_entrega 	integer,
 primary key (nro_orden_compra, nro_producto, fecha_entrega)
)
go

/*
Se debe programar un procedimiento que reciba como argumentos el nro. de producto a comprar 
la cantidad y la fecha en la que se necesita recibir el producto. 
El procedimiento debe buscar los proveedores del producto y elegir uno entre todos ellos al 
cual solicitar el producto.

Los criterios de selección son: 

1. Aquellos proveedores que lo puedan entregar a tiempo
2. Si hay más de uno, elegir el de menor precio
3. Si hay más de uno, elegir el de mayor categoría (las categorías van de la A (la mayor) 
   hasta la Z (la menor)). 

Si no existe ningún proveedor que cumple con el primer requisito, entonces el procedimiento
devuelve un mensaje de error.

Si se encuentra el proveedor, entonces se inserta una orden de compra con su detalle para
dicho proveedor. El nro. de orden de compra será el siguiente al último registrado. La fecha 
de la orden de compra será la actual. La fecha de entrega será la fecha actual + la cantidad
de días de entrega del proveedor. La cantidad será la solicitada.
*/

insert into productos 
values (1, 'Producto 1', 100)
insert into productos 
values (2, 'Producto 2', 100)
insert into productos 
values (3, 'Producto 3', 100)
insert into productos 
values (4, 'Producto 4', 100)
insert into productos 
values (5, 'Producto 5', 100)
go

insert into proveedores
values (1, 'Proveedor 1')
insert into proveedores
values (2, 'Proveedor 2')
insert into proveedores
values (3, 'Proveedor 3')
insert into proveedores
values (4, 'Proveedor 4')
insert into proveedores
values (5, 'Proveedor 5')
insert into proveedores
values (6, 'Proveedor 6')
go

-- Proveedor 1 por menor precio
insert into proveedores_productos
values (1, 1, 50.00, 10, 'C')
insert into proveedores_productos
values (2, 1, 60.00, 10, 'A')
insert into proveedores_productos
values (3, 1, 50.00, 20, 'B')
insert into proveedores_productos
values (4, 1, 50.00, 15, 'D')
go

-- Proveedor 2 por menor categoria
insert into proveedores_productos
values (1, 2, 50.00, 8, 'C')
insert into proveedores_productos
values (2, 2, 50.00, 9, 'A')
go

-- Proveedor 4 por ser unico proveedor
insert into proveedores_productos
values (4, 3, 50.00, 10, 'C')
go

-- Proveedor 4 porque es el unico que puede entregarlo en la fecha solicitada
insert into proveedores_productos
values (1, 4, 50.00, 17, 'C')
insert into proveedores_productos
values (2, 4, 60.00, 18, 'A')
insert into proveedores_productos
values (3, 4, 50.00, 15, 'B')
insert into proveedores_productos
values (4, 4, 90.00, 7, 'D')
go

-- ningun proveedor puede entregarlo en la fecha solicitada --> ERROR
insert into proveedores_productos
values (3, 5, 50.00, 12, 'C')
insert into proveedores_productos
values (4, 5, 60.00, 20, 'A')
insert into proveedores_productos
values (5, 5, 50.00, 30, 'B')
insert into proveedores_productos
values (6, 5, 50.00, 15, 'D')
go

-- realizar pruebas con estos argumentos
execute generar_orden_compra @nro_producto = 1, @cantidad = 300, @fecha = '20 dec 2001 0:00'
go
execute generar_orden_compra @nro_producto = 2, @cantidad = 300, @fecha = '20 dec 2001 0:00'
go
execute generar_orden_compra @nro_producto = 3, @cantidad = 300, @fecha = '20 dec 2001 0:00'
go
execute generar_orden_compra @nro_producto = 4, @cantidad = 300, @fecha = '20 dec 2001 0:00'
go
execute generar_orden_compra @nro_producto = 5, @cantidad = 300, @fecha = '20 dec 2001 0:00'
go

alter procedure generar_orden_compra
(
 @nro_producto	integer,
 @cantidad		integer,
 @fecha_maxima	date
)
as
begin
   set nocount on

   declare @nro_orden_compra	integer

   declare @proveedores table
   (
    nro_proveedor		integer,
	dias_entrega		tinyint, 
	precio				decimal(10,2),
	categoria			char(1)
   )	
	 
   -- seleccion por fecha de entrega
   insert into @proveedores (nro_proveedor, dias_entrega, precio, categoria)
   select pp.nro_proveedor, pp.dias_entrega, pp.precio_producto, pp.categoria
     from proveedores_productos pp
	where pp.nro_producto = @nro_producto
--	  and convert(date, dateadd(dd, pp.dias_entrega, getdate())) <= @fecha_maxima
	  and datediff(dd, getdate(), @fecha_maxima) >= pp.dias_entrega

   if not exists (select *
                    from @proveedores)
      begin
	     raiserror('No hay proveedores que puedan entregar el producto a tiempo', 16, 1)
		 return
	  end
	  
   -- seleccion por precio
   delete p
--   select *
     from @proveedores p
    where p.precio > (select min(p1.precio)
	                    from @proveedores p1)

--   select top 1 p.nro_proveedor, p.precio, p.categoria
--     from @proveedores p
--    order by categoria asc

   -- seleccion por categoria
   delete p
--   select *
     from @proveedores p
    where p.categoria > (select min(p1.categoria)
	                    from @proveedores p1)



   select @nro_orden_compra = isnull(max(nro_orden_compra),0) + 1
     from ordenes_compra 

--	Anadimos en las tablas la nueva compra
   insert into ordenes_compra (nro_orden_compra, nro_proveedor, fecha_orden_compra, anulada)
   select @nro_orden_compra, p.nro_proveedor, getdate(), 'N'
     from @proveedores p

   insert into det_ordenes_compra (nro_orden_compra, nro_producto, fecha_entrega, cantidad_entrega)
   select @nro_orden_compra, @nro_producto, dateadd(dd, p.dias_entrega, getdate()), @cantidad
     from @proveedores p

   set nocount off
   return
end
go

execute generar_orden_compra 4, 1000, '2017-05-31'
-- execute generar_orden_compra 1, 1000, '2017-05-31'
-- execute generar_orden_compra 1, 1000, '2017-05-22'
-- execute generar_orden_compra 1, 1000, '2017-05-17'
-- execute generar_orden_compra 1, 1000, '2017-05-02'

select *
  from ordenes_compra o
       join det_ordenes_compra d
	     on o.nro_orden_compra = d.nro_orden_compra

create procedure generar_orden_compra_v1
(
 @nro_producto	integer,
 @cantidad		integer,
 @fecha_maxima	date
)
as
begin
   set nocount on

   declare @nro_orden_compra	integer

   declare @proveedores table
   (
    nro_proveedor		integer,
	dias_entrega		tinyint, 
	precio				decimal(10,2),
	categoria			char(1)
   )	
	 
   -- seleccion por fecha de entrega
   insert into @proveedores (nro_proveedor, dias_entrega, precio, categoria)
   select top 1 
          pp.nro_proveedor, pp.dias_entrega, pp.precio_producto, pp.categoria
     from proveedores_productos pp
	where pp.nro_producto = @nro_producto
	  and datediff(dd, getdate(), @fecha_maxima) >= pp.dias_entrega
      and pp.precio_producto = (select min(pp1.precio_producto)
                                  from proveedores_productos pp1
	                             where pp1.nro_producto = @nro_producto
	                               and datediff(dd, getdate(), @fecha_maxima) >= pp1.dias_entrega)
    order by pp.categoria asc

   if not exists (select *
                    from @proveedores)
      begin
	     raiserror('No hay proveedores que puedan entregar el producto a tiempo', 16, 1)
		 return
	  end
	  
   select @nro_orden_compra = isnull(max(nro_orden_compra),0) + 1
     from ordenes_compra 

   insert into ordenes_compra (nro_orden_compra, nro_proveedor, fecha_orden_compra, anulada)
   select @nro_orden_compra, p.nro_proveedor, getdate(), 'N'
     from @proveedores p

   insert into det_ordenes_compra (nro_orden_compra, nro_producto, fecha_entrega, cantidad_entrega)
   select @nro_orden_compra, @nro_producto, dateadd(dd, p.dias_entrega, getdate()), @cantidad
     from @proveedores p

   set nocount off
   return
end
go

-- execute generar_orden_compra 4, 1000, '2017-05-31'
-- execute generar_orden_compra 1, 1000, '2017-05-31'
-- execute generar_orden_compra 1, 1000, '2017-05-22'
-- execute generar_orden_compra 1, 1000, '2017-05-17'
-- execute generar_orden_compra 1, 1000, '2017-05-02'

select *
  from ordenes_compra o
       join det_ordenes_compra d
	     on o.nro_orden_compra = d.nro_orden_compra
