-- Dadas las siguientes tablas:

create table categorias
(
 cod_categoria		varchar(3) 		not null primary key,
 nom_categoria		varchar(30)		not null unique,
 precio				decimal(6,2)	not null check (precio > 0),
 cant_dias_alq		tinyint			not null check (cant_dias_alq > 0) default 1
)
go

insert into categorias
values ('A', 'CATEGORIA A', 5.00, 1)
insert into categorias
values ('B', 'CATEGORIA B', 4.00, 2)
insert into categorias
values ('C', 'CATEGORIA C', 3.00, 3)
insert into categorias
values ('D', 'CATEGORIA D', 2.00, 4)
go

create table nacionalidades
(
 nacionalidad		varchar(30)	not null primary key
)
go

insert into nacionalidades
values ('ARGENTINA')
insert into nacionalidades
values ('ESPAÑOLA')
insert into nacionalidades
values ('ITALIANA')
go

create table peliculas
(
 nro_pelicula		integer			not null primary key,
 titulo				varchar(100)	not null,
 nacionalidad		varchar(30)		not null references nacionalidades,
 cod_categoria		varchar(3)		not null references categorias,
 resumen			varchar(4000)	null
)
go

insert into peliculas
values (1, 'PELICULA 1', 'ARGENTINA', 'A', NULL)
insert into peliculas
values (2, 'PELICULA 2', 'ARGENTINA', 'A', NULL)
insert into peliculas
values (3, 'PELICULA 3', 'ESPAÑOLA', 'B', NULL)
insert into peliculas
values (4, 'PELICULA 4', 'ITALIANA', 'B', NULL)
insert into peliculas
values (5, 'PELICULA 5', 'ITALIANA', 'C', NULL)
go

create table medios
(
 cod_medio		varchar(3)	not null primary key,
 nom_medio		varchar(30)	not null unique
)
go

insert into medios
values ('DVD', 'DVD')
insert into medios
values ('VHS', 'VHS')
go

create table copias
(
 nro_pelicula	integer		not null references peliculas,
 nro_copia		smallint	not null,
 estado			char(1)		not null check (estado in ('B','M','R')) default 'B',
 cod_medio		varchar(3)	not null references medios,
 primary key (nro_pelicula, nro_copia)
)
go

insert into copias
values (1, 1, 'B', 'DVD')
insert into copias
values (1, 2, 'B', 'DVD')
insert into copias
values (2, 1, 'B', 'VHS')
insert into copias
values (2, 2, 'B', 'DVD')
insert into copias
values (2, 3, 'B', 'DVD')
insert into copias
values (3, 1, 'R', 'VHS')
insert into copias
values (4, 1, 'R', 'VHS')
insert into copias
values (5, 1, 'R', 'VHS')
go

create table socios
(
 nro_socio		integer			not null primary key,
 apellido		varchar(40)		not null,
 nombre			varchar(40)		not null,
 tipo_documento	varchar(3)		not null,
 nro_documento	integer			not null,
 direccion		varchar(100)	not null,
 telefonos		varchar(100)	not null,
 unique (tipo_documento, nro_documento)
)
go

insert into socios
values (1, 'APELLIDO SOCIO 1', 'NOMBRE SOCIO 1', 'DNI', 12345678, 'A','1')
insert into socios
values (2, 'APELLIDO SOCIO 2', 'NOMBRE SOCIO 2', 'DNI', 23456789, 'A','1')
insert into socios
values (3, 'APELLIDO SOCIO 3', 'NOMBRE SOCIO 3', 'DNI', 34567890, 'A','1')
insert into socios
values (4, 'APELLIDO SOCIO 4', 'NOMBRE SOCIO 4', 'DNI', 45678901, 'A','1')
insert into socios
values (5, 'APELLIDO SOCIO 5', 'NOMBRE SOCIO 5', 'DNI', 56789012, 'A','1')
go


create table abonos
(
 nro_abono		integer			not null primary key,
 nro_socio		integer			not null references socios,
 fecha_compra	smalldatetime	not null,
 importe		decimal(6,2)	not null,
 fecha_vto		smalldatetime	not null
)
go

insert into abonos
values (1, 1, '01 mar 2007 0:00', 10.00, '25 may 2007 0:00')
insert into abonos
values (2, 1, '01 jun 2007 0:00', 10.00, '30 sep 2007 0:00')
insert into abonos
values (3, 2, '01 may 2007 0:00', 12.00, '31 jul 2007 0:00')
insert into abonos
values (4, 2, '01 jul 2007 0:00', 12.00, '31 oct 2007 0:00')
insert into abonos
values (5, 3, '01 mar 2007 0:00', 13.00, '25 dec 2007 0:00')
insert into abonos
values (6, 4, '01 mar 2007 0:00', 14.00, '31 dec 2007 0:00')
go

create table detalle_abonos
(
 nro_abono		integer		not null references abonos,
 cod_categoria	varchar(3)	not null references categorias,
 cant_copias	tinyint		not null check (cant_copias > 0),
 primary key (nro_abono, cod_categoria)
)
go

insert into detalle_abonos
values (1, 'A', 10)
insert into detalle_abonos
values (1, 'B', 5)
insert into detalle_abonos
values (2, 'A', 20)
insert into detalle_abonos
values (2, 'C', 10)
insert into detalle_abonos
values (3, 'A', 30)
insert into detalle_abonos
values (3, 'B', 15)
insert into detalle_abonos
values (4, 'B', 40)
insert into detalle_abonos
values (4, 'C', 20)
insert into detalle_abonos
values (5, 'B', 50)
insert into detalle_abonos
values (5, 'C', 25)
insert into detalle_abonos
values (6, 'C', 60)
go

create table alquileres
(
 nro_alquiler	integer			not null primary key,
 nro_socio		integer			not null references socios,
 fecha_alquiler	smalldatetime	not null,
 nro_pelicula	integer			not null,
 nro_copia		smallint		not null,
 nro_abono		integer			not null,
 cod_categoria	varchar(3)		not null,
 fecha_a_dev	smalldatetime	not null,
 fecha_dev		smalldatetime	null,
 foreign key (nro_pelicula, nro_copia)  references copias,
 foreign key (nro_abono, cod_categoria) references detalle_abonos
)
go

insert into alquileres
values (1, 1, '01 may 2007 0:00', 1, 1, 1, 'A', '02 may 2007 0:00', null)
insert into alquileres
values (2, 1, '01 jun 2007 0:00', 1, 1, 1, 'A', '02 jun 2007 0:00', null)
insert into alquileres
values (3, 1, '01 jul 2007 0:00', 1, 1, 2, 'A', '02 jul 2007 0:00', null)
insert into alquileres
values (4, 1, '01 jul 2007 0:00', 1, 1, 2, 'C', '02 jul 2007 0:00', null)
insert into alquileres
values (5, 2, '01 may 2007 0:00', 1, 1, 3, 'A', '02 may 2007 0:00', null)
insert into alquileres
values (6, 2, '01 may 2007 0:00', 1, 1, 3, 'A', '02 may 2007 0:00', null)
insert into alquileres
values (7, 3, '01 may 2007 0:00', 1, 1, 5, 'B', '02 may 2007 0:00', null)
insert into alquileres
values (8, 3, '01 may 2007 0:00', 1, 1, 5, 'C', '02 may 2007 0:00', null)
insert into alquileres
values (9, 3, '01 may 2007 0:00', 1, 1, 5, 'C', '02 may 2007 0:00', null)
insert into alquileres
values (10, 3, '01 may 2007 0:00', 1, 1, 5, 'C', '02 may 2007 0:00', null)
go

/* CONSIGNA:

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

1. La base de datos tiene las siguientes reglas de integridad que no fueron implementadas:

   a. El código de categoría en el alquiler debe ser el mismo que el código de categoría de la 
      película alquilada
      
   b. La cantidad de copias alquiladas asociadas a un abono no puede superar el total autorizado
      por el abono en la categoría correspondiente

   Definir los triggers que se deben programar para implementar estas dos reglas de integridad y 
   programar dos de ellos (de cualquiera de las reglas).
   
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

a. El código de categoría en el alquiler debe ser el mismo que el código de categoría de la 
   película alquilada

   select *
     from alquileres a
          join peliculas p
            on a.nro_pelicula = p.nro_pelicula
    where a.cod_categoria <> p.cod_categoria

   TABLA DE ANÁLISIS EN EXCEL.

   Triggers:
   
   create trigger ti_ria_alquileres
   on alquileres
   for insert
   as
   begin
      if exists (select *
                   from inserted a
                        join peliculas p
                          on a.nro_pelicula = p.nro_pelicula
                  where a.cod_categoria <> p.cod_categoria)
         begin
            raiserror('La categoría de la película registrada en el alquiler no corresponde a la categoría de la película', 16, 1)
            rollback
         end                  
   end
   go
   
   create trigger tu_ria_alquileres
   on alquileres
   for update
   as
   begin
      if update(nro_pelicula)
         begin
            raiserror('No puede modificar la película registrada en el alquiler', 16, 1)
            rollback
         end                  

      if update(cod_categoria)
         begin
            raiserror('No puede modificar la categoría registrada en el alquiler', 16, 1)
            rollback
         end                  
   end
   go

   create trigger tu_ria_peliculas_alternativa_1
   on peliculas
   for update
   as
   begin
      if update(cod_categoria)
         begin
            raiserror('No puede modificar la categoría de la película', 16, 1)
            rollback
         end                  
   end
   go

   -- la alernativa 2 no requiere trigger

   create trigger tu_ria_peliculas_alternativa_3
   on peliculas
   for update
   as
   begin
      -- no permitir modificar la clave primaria de películas para poder hacer la propagación de cambio de categoría
      if update(nro_pelicula)
         begin
            raiserror('No puede modificar el identificador de la película', 16, 1)
            rollback
         end                  
      
      update a
         set cod_categoria = i.cod_categoria
        from alquileres a
             join inserted i
               on a.nro_pelicula = i.nro_pelicula
             join deleted d
               on a.nro_pelicula = i.nro_pelicula
       where i.cod_categoria <> d.cod_categoria 
         
   end
   go

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

b. La cantidad de copias alquiladas asociadas a un abono no puede superar el total autorizado
   por el abono en la categoría correspondiente
   
   alternativa 1:
   
   select a.nro_abono, a.cod_categoria
     from alquileres a
    group by a.nro_abono, a.cod_categoria
   having count(*) > (select da.cant_copias
                        from detalle_abonos da
                       where a.nro_abono     = da.nro_abono
                         and a.cod_categoria = da.cod_categoria)

   alternativa 2:   

   select a.nro_abono, a.cod_categoria, da.cant_copias, count(*) cant_copias_alquiladas
     from alquileres a
          join detalle_abonos da
            on a.nro_abono     = da.nro_abono
           and a.cod_categoria = da.cod_categoria
    group by a.nro_abono, a.cod_categoria, da.cant_copias
   having count(*) > da.cant_copias

   TABLA DE ANÁLISIS EN EXCEL.
   
   Triggers:
   
   create trigger ti_rib_alquileres
   on alquileres
   for insert
   as
   begin
      -- con inserted se restringe a todos los alquileres asociados a un abono-categoria
      -- a los cuales se han hecho referencias en las filas insertadas 
      -- No se usa el join porque puede haber más de una fila en inserted con el mismo abono-categoria
      -- (OJO!, ANALIZAR BIEN EL CASO Y LA SOLUCIÓN)
      if exists (select a.nro_abono, a.cod_categoria
                   from alquileres a
                  where exists (select *
                                  from inserted i
                                 where a.nro_abono     = i.nro_abono
                                   and a.cod_categoria = i.cod_categoria)
                  group by a.nro_abono, a.cod_categoria
                 having count(*) > (select da.cant_copias
                                      from detalle_abonos da
                                     where a.nro_abono     = da.nro_abono
                                       and a.cod_categoria = da.cod_categoria))
         begin
            raiserror('Se intentan registrar más alquileres que los autorizados para alguna categoría en algún abono', 16, 1)
            rollback
         end                  
                                       
   end
   go
       
   create trigger tu_rib_alquileres
   on alquileres
   for update
   as
   begin
      -- no permitir modificar la clave primaria de alquileres para poder controlar el cambio de categoría o abono
      if update(nro_alquiler)
         begin
            raiserror('No puede modificar el identificador del alquiler', 16, 1)
            rollback
         end                  

      -- Con inserted se restringe a todos los alquileres asociados a un abono-categoria
      -- a los cuales se han hecho referencias en las filas modificadas
      -- No se usa el join porque puede haber más de una fila en inserted con el mismo abono-categoria
      -- El join entre inserted y deleted es por su PK (nro_alquiler) determinando si ha cambiado el abono o la categoría 
      -- No interesan los registros tal como estaban antes, ya que las categorías y abonos referenciados ahora tienen menos
      -- cantidad de alquileres
      -- (OJO!, ANALIZAR BIEN EL CASO Y LA SOLUCIÓN)
      if exists (select a.nro_abono, a.cod_categoria
                   from alquileres a
                  where exists (select *
                                  from inserted i
                                       join deleted d
                                         on i.nro_alquiler = d.nro_alquiler
                                 where a.nro_abono     = i.nro_abono
                                   and a.cod_categoria = i.cod_categoria
                                   and (
                                        i.nro_abono     <> d.nro_abono
                                        or
                                        i.cod_categoria <> d.cod_categoria
                                       ))
                  group by a.nro_abono, a.cod_categoria
                 having count(*) > (select da.cant_copias
                                      from detalle_abonos da
                                     where a.nro_abono     = da.nro_abono
                                       and a.cod_categoria = da.cod_categoria))
         begin
            raiserror('Se intentan registrar más alquileres que los autorizados para alguna categoría en algún abono', 16, 1)
            rollback
         end                  
                                       
   end
   go

   create trigger tu_rib_detalle_abonos
   on detalle_abonos
   for update
   as
   begin
      if update(nro_abono) or update(cod_categoria)
         begin
            raiserror('No se puede modificar el identificador del abono ni la categoría', 16, 1)
            rollback
         end                  
                                       
      -- Con inserted se restringe a todos los alquileres asociados a un abono-categoria
      -- a los cuales se han hecho referencias en las filas modificadas
      -- No se usa el join porque puede haber más de una fila en inserted con el mismo abono-categoria
      -- El join entre inserted y deleted es por su PK (nro_abono, cod_categoria) determinando si ha bajado la cantidad de copias autorizadas 
      -- No interesan los registros tal como estaban antes, ya que las categorías y abonos referenciados cumplían con la regla de integridad
      -- (OJO!, ANALIZAR BIEN EL CASO Y LA SOLUCIÓN)
      if exists (select a.nro_abono, a.cod_categoria
                   from alquileres a
                  where exists (select *
                                  from inserted i
                                       join deleted d
                                         on i.nro_abono     = d.nro_abono
                                        and i.cod_categoria = d.cod_categoria
                                 where a.nro_abono     = i.nro_abono
                                   and a.cod_categoria = i.cod_categoria
                                   and i.cant_copias < d.cant_copias)
                  group by a.nro_abono, a.cod_categoria
                 having count(*) > (select da.cant_copias
                                      from detalle_abonos da
                                     where a.nro_abono     = da.nro_abono
                                       and a.cod_categoria = da.cod_categoria))
         begin
            raiserror('La nueva cantidad autorizada supera la cantidad de alquileres asociados a ese abono-categoría', 16, 1)
            rollback
         end                  
   end
   go

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

2. Crear una vista v_utilizacion_abonos con las siguientes columnas:

   	- nro_socio
    - nro_abono
    - cod_categoria
    - cant_copias
    - cant_copias_alquiladas (cantidad de copias alquiladas hasta la fecha del día por el socio con ese
                              abono en esa categoría)

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

   create view v_utilizacion_abonos (nro_socio, nro_abono, cod_categoria, cant_copias, cant_copias_alquiladas)
   as
   select ab.nro_socio, da.nro_abono, da.cod_categoria, da.cant_copias, count(a.nro_alquiler)
     from abonos ab
          join detalle_abonos da
            on ab.nro_abono = da.nro_abono
          left join alquileres a
            on da.nro_abono     = a.nro_abono
           and da.cod_categoria = a.cod_categoria
    group by ab.nro_socio, da.nro_abono, da.cod_categoria, da.cant_copias           
   go

select * from v_utilizacion_abonos

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

3. Programar la siguiente consulta en SQL utilizando la vista creada en el punto a:

   Para el socio nro. 1057, mostrar una lista de categorías y para cada una de ellas, 
   la cantidad de copias que el socio aún tiene disponibles para retirar a la fecha de hoy. 
   Los datos a mostrar son: cod_categoria, nom_categoria, cant_copias_disponibles.

   NOTA: El socio puede tener más de un abono vigente (fecha de vencimiento >= fecha del día).

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

   select u.cod_categoria, c.nom_categoria, sum(u.cant_copias - u.cant_copias_alquiladas) cant_copias_disponibles
     from v_utilizacion_abonos u
          join abonos ab
            on u.nro_abono = ab.nro_abono
           and ab.fecha_vto >= getdate()
          join categorias c
            on u.cod_categoria = c.cod_categoria
    where u.nro_socio = 1057
    group by u.cod_categoria, c.nom_categoria
            
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

4. Programar un procedimiento almacenado que reciba como argumento el año y devuelva una estadística de 
   alquileres por categoría:

   Cód.	Categoría						Cant. Alq.	Porcentaje
   -----------------------------------------------------------
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		

   donde la cantidad es la cantidad de copias alquiladas de películas de la categoría.
   La lista debe aparecer ordenada por porcentaje descendente y debe incluir a todas las categorías 
   inclusive las que no tienen copias alquiladas. 

   NOTA: La suma de los porcentajes es 100%

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

   -- VER EL USO DEL CONVERT (convierte tipo de datos) Y DE ROUND (NO ERA NECESARIO USARLOS, ES SOLO PARA MOSTRAR COMO HACERLO)
   -- VER LA LÓGICA PARA EL CASO EN QUE DURANTE EL AÑO NO HAYA ALQUILERES, YA QUE EN ESE CASO EL CÁLCULO DEL PORCENTAJE DARÍA ERROR POR DIVISIÓN POR CERO

   -- ALTERNATIVA 1 (TOTALMENTE RELACIONAL - SOLO SENTENCIAS SQL (SELECT))
   create procedure get_estadistica_alquileres_1
   (
    @año	smallint
   )
   as
   begin
      select cod_categoria   = c.cod_categoria, 
             nom_categoria   = c.nom_categoria, 
             cant_alquileres = count(a.nro_alquiler), 
             porcentaje      = convert(decimal(5,2), 
                                       case when (select count(*)
                                                    from alquileres a1
                                                   where year(a1.fecha_alquiler) = @año) > 0 then round(count(a.nro_alquiler) * 100.00 / (select count(*)
                                                                                                                                            from alquileres a1
                                                                                                                                           where year(a1.fecha_alquiler) = @año),2)
                                            else 0.00
                                       end
                                       )
        from categorias c
             left join alquileres a
               on c.cod_categoria = a.cod_categoria
              and year(a.fecha_alquiler) = @año
       group by c.cod_categoria, c.nom_categoria
       order by count(a.nro_alquiler) desc
   end
   go
   
   execute get_estadistica_alquileres_1 2007
   
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

   -- ALTERNATIVA 2 (USANDO SQL EXTENDIDO - VARIABLES - TABLAS TEMPORALES O VARIABLES TABLA)
   create procedure get_estadistica_alquileres_2
   (
    @año	smallint
   )
   as
   begin
      declare @total_alquileres	smallint
      
      create table #alquileres_categoria
      (
       cod_categoria		varchar(3)		not null,
       nom_categoria		varchar(30)		not null,
       cant_alquileres		smallint		not null,
       porcentaje			decimal(5,2)	null
      )
      
      insert into #alquileres_categoria (cod_categoria, nom_categoria, cant_alquileres)
      select cod_categoria   = c.cod_categoria, 
             nom_categoria   = c.nom_categoria, 
             cant_alquileres = count(a.nro_alquiler)
        from categorias c
             left join alquileres a
               on c.cod_categoria = a.cod_categoria
              and year(a.fecha_alquiler) = @año
       group by c.cod_categoria, c.nom_categoria

       select @total_alquileres = count(*)
         from alquileres a
        where year(a.fecha_alquiler) = @año

       update t
          set porcentaje = case when @total_alquileres > 0 then round(cant_alquileres * 100.00 / @total_alquileres,2)
                                else 0.00
                           end
         from #alquileres_categoria t
       
       select t.cod_categoria, t.nom_categoria, t.cant_alquileres, t.porcentaje
         from #alquileres_categoria t
       order by t.porcentaje desc
   end
   go
   
   execute get_estadistica_alquileres_2 2007

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
*/