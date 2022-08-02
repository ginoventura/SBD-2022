------------------------------------------------------------------------------------------------------------
-- INGENIERIA INFORMATICA - SISTEMAS DE BASES DE DATOS - PARCIAL RECUPERATORIO N° 3 - SEGUNDA INSTANCIA
------------------------------------------------------------------------------------------------------------
/* 
Se tiene la siguiente base de datos para gestionar la compra de productos a proveedores. 
Hay productos que pueden tener equivalencias entre sí. Un producto puede ser 100% equivalente a otro o en un menor porcentaje.
Cada producto tiene un único proveedor, el cual tiene un precio y una cantidad de días en que el proveedor entrega el producto.
Para realizar una compra debemos registrar una orden de compra asociada a un único proveedor que es el proveedor del producto y
con el detalle de productos solicitados la cantidad pedida y la fecha de entrega de ese producto prometida por el proveedor.
*/

drop table det_ordenes_compra
drop table ordenes_compra
drop table productos_equivalentes
drop table productos
drop table proveedores
go

create table proveedores
(
 nro_proveedor 		integer			not null,
 nom_proveedor 		varchar(40)		not null,
 constraint PK__proveedores__END	primary key (nro_proveedor),
 constraint UK__proveedores__1__END unique (nom_proveedor)
)
go

create table productos
(
 nro_producto 		integer			not null,
 nom_producto 		varchar(40)		not null,
 nro_proveedor		integer			not null,
 precio_producto	decimal(10,2)	not null,
 dias_entrega		tinyint			not null,
 stock				integer			not null,
 constraint PK__productos__END					primary key (nro_producto),
 constraint UK__productos__1__END				unique (nom_producto),
 constraint FK__productos__proveedores__1__END	foreign key (nro_proveedor) references proveedores
)
go

create table productos_equivalentes
(
 nro_producto 		integer			not null,
 nro_producto_equiv	integer			not null,
 porc_equivalencia	tinyint			not null,
 constraint PK__productos_equivalentes__END						primary key (nro_producto, nro_producto_equiv),
 constraint FK__productos_equivalentes__productos__1__END		foreign key (nro_producto) references productos,
 constraint FK__productos_equivalentes__productos__2__END		foreign key (nro_producto_equiv) references productos,
 constraint CK__productos_equivalentes__nivel_equivalencia__END check (porc_equivalencia between 1 and 100)
)
go

create table ordenes_compra
(
 nro_orden_compra 	integer			not null,
 nro_proveedor 		integer			not null,
 fecha_orden_compra date			not null,
 anulada			char(1)			not null		constraint DF__ordenes_compra__anulada__N__END default 'N',
 constraint PK__ordenes_compra__END					primary key (nro_orden_compra),
 constraint FK__ordenes_compra__proveedores__1__END foreign key (nro_proveedor) references proveedores,
 constraint CK__ordenes_compra__anulada__END		check (anulada in ('S','N'))
)
go

create table det_ordenes_compra
(
 nro_orden_compra 	integer			not null,
 nro_producto 		integer			not null,
 fecha_entrega 		date			not null,
 cantidad_pedida 	integer			not null,
 constraint PK__det_ordenes_compra_END						primary key (nro_orden_compra, nro_producto),
 constraint FK__det_ordenes_compra__ordenes_compra__1__END	foreign key (nro_orden_compra) references ordenes_compra,
 constraint FK__det_ordenes_compra__productos__1__END		foreign key (nro_producto) references productos,
 constraint CK__det_ordenes_compra__cantidad_pedida__END	check (cantidad_pedida > 0)
)
go




/*
	1. Regla de integridad: los productos solicitados en cada orden de compra deben ser solicitados al proveedor de esos productos.
	   Realizar el análisis, diseño e implementación de triggers que aseguren dicha regla, desarrollando los siguientes pasos:

	   a. Programar la lista de detalles de órdenes de compra que no cumplen la regla de integridad (10)

	   b. Construir una tabla gráfica que muestre las tablas involucradas (en filas), las operaciones
		  de actualización sobre las tablas (en columnas) y las acciones a tener en cuenta (en celdas)(20)

	   c. Programar los triggers que aseguran dicha regla de integridad, según la tabla del paso anterior.(20)
*/



insert into proveedores
values	(100,'pepe'),
		(200,'juan'),
		(300,'moni'),
		(400,'nico')

insert into productos
values	(1,'lapices',100,7500, 5,1000),
		(2,'gomas',200,10000, 10,2000),
		(3,'cuadernos',300,7500, 2,500),
		(4,'lapices2',400,7500, 2,500),
		(5,'cuadernos2',400,7500, 2,500)

insert into productos_equivalentes
values	(1,4,88),
		(3,5,100)

insert into ordenes_compra
values	(001,100,'01-01-2019','S'),
		(002,200,'01-01-2019','S'),
		(003,300,'02-02-2020','N')

insert into det_ordenes_compra
values	(001,1,'01-06-2019',500),
		(002,2,'01-20-2019',500),
		(003,3,'02-15-2020',500)


--1
--a. Lista de detalles de órdenes de compra que no cumplen la regla de integridad


select oc.nro_orden_compra, oc.nro_proveedor,p.nro_proveedor
	from ordenes_compra oc
		join det_ordenes_compra doc
			on oc.nro_orden_compra = doc.nro_orden_compra
				join productos p
					on doc.nro_producto = p.nro_producto
  where exists(select *
					from productos p
				  where doc.nro_producto = p.nro_producto
				  and oc.nro_proveedor <> p.nro_proveedor)



--b.

--		TABLAS					INSERT					DELETE				UPDATE
----------------------------------------------------------------------------------------------
--		ordenes_compra			controlar				-----				controlar
----------------------------------------------------------------------------------------------
--		det_ordenes_compra		--------				no permitir			no permitir?				
----------------------------------------------------------------------------------------------
--		productos				---------				-----				no permitir
----------------------------------------------------------------------------------------------


--c. Triggers

create or alter trigger tiu_ri_ordenes_compra
on ordenes_compra
for insert,update
as
begin
	if exists(select oc.nro_orden_compra, oc.nro_proveedor,p.nro_proveedor
					from inserted oc
						join det_ordenes_compra doc
							on oc.nro_orden_compra = doc.nro_orden_compra
								join productos p
									on doc.nro_producto = p.nro_producto
				  where exists(select *
									from productos p
								  where doc.nro_producto = p.nro_producto
								  and oc.nro_proveedor <> p.nro_proveedor))
	begin
		raiserror('Los productos solicitados en cada orden de compra deben ser solicitados al proveedor de esos productos',16,1)
		rollback
	end
end
go

create or alter trigger td_ri_det_orden_compra
on det_ordenes_compra
for delete
as
begin
	raiserror('No se pueden eliminar lo detalles de ordenes de compras',16,1)
	rollback
end
go






insert into ordenes_compra
values	(004,400,'01-01-2019','S'),
		(005,400,'02-02-2020','N')
go


insert into det_ordenes_compra
values	(004,2,'01-20-2019',500),
		(005,3,'02-15-2020',500)
go




------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*

2. Programar un procedimiento almacenado que recibe como argumentos: (50)
   - nro_producto
   - cantidad
   - fecha
   y realice lo siguiente:

   - si el stock del producto alcanza para entregar esa cantidad:
     --> devolver un result set con una fila con dos columnas: 
	     - nro_retorno = 1
		 - msj_retorno = 'Ok.'

   - si el stock del producto + stock de todos los productos equivalentes con porcentaje de equivalencia = 100 alcanza para entregar 
     esa cantidad:
     --> devolver un result set con una fila con dos columnas: 
	     - nro_retorno = 2
		 - msj_retorno = 'Ok. Se completa con productos equivalentes.'

   - si el stock del producto + las cantidades pedidas en órdenes de compra de ese producto con fecha de entrega > a la actual y 
     fecha de entrega <= fecha (argumento):
     --> devolver un result set con una fila con dos columnas: 
	     - nro_retorno = 3
		 - msj_retorno = 'Ok. Se completa con compras pendientes.'
   
   - si el stock del producto + stock de todos los productos equivalentes con nivel de equivalencia = 100 + las cantidades pedidas 
     en órdenes de compra de ese producto y de sus equivalentes con nivel de equivalencias = 100 con fecha de entrega > a la actual 
	 y fecha de entrega <= fecha (argumento):
     --> devolver un result set con una fila con dos columnas: 
	     - nro_retorno = 4
		 - msj_retorno = 'Ok. Se completa con productos equivalentes y compras pendientes.'
   
   - en otro caso
     si la fecha actual + cantidad de días de entrega del proveedor para ese producto <= fecha (argumento):
     --> insertar una orden de compra y su detalle, solicitando el producto donde:
         - nro_orden_compra: el próximo
         - nro_proveedor: el del producto
         - fecha_orden_compra: la actual
         - anulada: N
         - nro_producto: el solicitado
         - fecha_entrega: la actual + dias de entrega
         - cantidad_pedida: la cantidad solicitada - stock del producto solicitado
     y
	 --> devolver un result set con una fila con dos columnas: 
	     - nro_retorno = -1
		 - msj_retorno = 'Se registró una orden de compra para completar el pedido.'
     
	 sino:         
     --> devolver un result set con una fila con dos columnas: 
	     - nro_retorno = -2
		 - msj_retorno = 'No se puede satisfacer el pedido.'
*/    
