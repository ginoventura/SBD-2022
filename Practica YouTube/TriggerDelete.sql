--Un comercio que vende artículos de informática almacena los datos de sus artículos en una tabla 
--denominada "articulos".
--1- Elimine la tabla si existe:
 if object_id('articulos') is not null
  drop table articulos;

 create table articulos(
  codigo int identity,
  tipo varchar(30),
  descripcion varchar(40),
  precio decimal(8,2),
  stock int,
  constraint PK_articulos primary key (codigo)
 );

 insert into articulos values ('impresora','Epson Stylus C45',400,100);
 insert into articulos values ('impresora','Epson Stylus C85',500,200);
 insert into articulos values ('impresora','Epson Stylus Color 600',400,0);
 insert into articulos values ('monitor','Samsung 14',900,0);
 insert into articulos values ('monitor','Samsung 17',1200,0);
 insert into articulos values ('monitor','xxx 15',1500,0);
 insert into articulos values ('monitor','xxx 17',1600,0);
 insert into articulos values ('monitor','zzz 15',1300,0);

--4- Cree un disparador para controlar que no se elimine un artículo si hay stock. 
--El disparador se activará cada vez que se ejecuta un "delete" sobre "articulos", 
--controlando el stock, si se está eliminando un artículo cuyo stock sea mayor a 0, el 
--disparador debe retornar un mensaje de error y deshacer la transacción.
create trigger DIS_articulos_borrar
  on articulos
  for delete
  as 
   if exists(select *from deleted where stock>0)--si algun registro borrado tiene stock
   begin
    raiserror('No puede eliminar artículos que tienen stock',16,1)
    rollback transaction
   end
   else
   begin
     declare @cantidad int
     select @cantidad=count(*) from deleted
     select 'Se eliminaron ' +rtrim(cast(@cantidad as char(10)))+ ' registros'
   end;

delete from articulos where codigo=4;

delete from articulos where codigo=2;

delete from articulos where descripcion like '%xx%';

delete from articulos where codigo<=3;

--5) Cree un trigger para evitar que se elimine más de 1 artículo.
--Note que hay 2 disparadores para el mismo suceso (delete) sobre la misma tabla.

 create trigger DIS_articulos_borrar2
  on articulos
  for delete
  as
   declare @cantidad int
   select @cantidad=count(*) from deleted
   if @cantidad>1
   begin
    raiserror('No puede eliminar más de 1 artículo',16,1)
    rollback transaction
   end;

--6) Solicite la eliminación de 1 artículo para el cual no haya stock.
--Ambos disparadores "DIS_articulos_borrar" y "DIS_articulos_borrar2" se activan y permiten la 
--transacción.
delete from articulos where codigo=3;

--7) Solicite la eliminación de 1 artículo que tenga stock.
--El disparadores "DIS_articulos_borrar" se activa y no permite la transacción. El disparador 
--"DIS_articulos_borrar2" no llega a activarse.
delete from articulos where codigo=2

--8) Solicite la eliminación de 2 artículos para los cuales no haya stock.
--El disparador "DIS_articulos_borrar" se activa y permite la transacción pero el disparador 
--"DIS_articulos_borrar2" no permite la transacción.
delete from articulos where tipo='monitor';

--9) Solicite la eliminación de 2 artículos para los que haya stock.
--El disparador "DIS_articulos_borrar" se activa y no permite la transacción. El disparador 
--"DIS_articulos_borrar2" no llega a activarse.
delete from articulos where tipo='impresora';