--Se tiene una base de datos de cuentas corrientes de clientes en la cual se registran los datos de clientes, los comprobantes asociados
--a las transacciones realizadas por ellos y la relación entre dichos comprobantes.

--Los comprobantes registrados son de 4 tipos:
--- FA: Facturas que corresponden a compras realizadas por los clientes y que se consideran débitos en su cuenta corriente.
--- ND: Notas de débito que corresponden a otros débitos realizados a los clientes, como por ejemplo: intereses por mora, gastos de 
--      financiación, etc. Obviamente, estos comprobantes también se consideran débitos en su cuenta corriente.
--- RE: Recibos por pagos realizados por los clientes y que se consideran créditos en su cuenta corriente.
--- NC: Notas de crédito que corresponden a otros créditos realizados a los clientes, como por ejemplo: descuentos, bonificaciones, etc.
--      Obviamente, estos comprobantes también se consideran créditos en su cuenta corriente.

--También se registran las relaciones que existen entre esos comprobantes. Las relaciones válidas entre ellos son las siguientes:
--- Los comprobantes considerados "créditos" (RE y NC) solo se aplican a comprobantes considerados "débitos" (FA y ND).
--- Un comprobante de crédito (RE o NC) se puede aplicar a cero o varios comprobantes de débito (FA o ND).
--- Un comprobante de débito puede tener aplicado cero o varios comprobantes de crédito.
--- Cuando un recibo se aplica a una factura indica que con ese recibo se paga esa factura (total o parcialmente). Idem cuando se aplica
--  a una nota de débito.
--- Cuando una nota de crédito se aplica a una factura indica que con esa nota de crédito se cancela el monto de esa factura 
--  (total o parcialmente). 
--  Idem cuando se aplica a una nota de débito.
--- Un recibo se puede aplicar a cero o más facturas y una factura puede ser pagada a través de uno o más recibos.

--La tabla que almacena los comprobantes tiene una columna "saldo del comprobante" que es redundante.

--Cuando un recibo o nota de crédito se aplica a una factura o nota de débito los saldos de ambos comprobantes involucrados disminuyen 
--en el importe aplicado.
----------------------------------------------------------------------------------------------------------------------

drop table afectacion_comprobantes
drop table cuenta_corriente
drop table clientes
go

create table clientes
(
 nro_cliente 		integer 		not null,
 nom_cliente 		varchar(40) 	not null,
 constraint PK__clientes__END 
            primary key (nro_cliente)
)
go

create table cuenta_corriente
(
 nro_cliente 		integer 		not null,
 tipo_comprobante 	char(2) 		not null,
 nro_comprobante 	integer 		not null,
 fecha_comprobante 	date	 		not null,
 importe_total 		decimal(12,2)	not null,
 saldo 				decimal(12,2)	not null,
 constraint PK__cuenta_corriente_clientes_END 
            primary key (tipo_comprobante, nro_comprobante),
 constraint FK__cuenta_corriente_clientes__clientes__1__END 
            foreign key (nro_cliente) references dbo.clientes,
 constraint CK__cuenta_corriente_clientes__tipo_comprobante__END
            check (tipo_comprobante in ('FA','ND','NC','RE')),
 constraint CK__cuenta_corriente_clientes__importe_total__END
            check (importe_total >= 0.00),
 constraint CK__cuenta_corriente_clientes__saldo__END
            check (saldo >= 0.00),
 constraint CK__cuenta_corriente_clientes__importes__END
            check (saldo <= importe_total)
)
go

create table afectacion_comprobantes
(
 tipo_comprobante 			char(2) 		not null,
 nro_comprobante 			integer 		not null,
 tipo_comprobante_afectado	char(2) 		not null,
 nro_comprobante_afectado	integer 		not null,
 importe_afectado 			decimal(12,2)	not null,
 constraint PK__afectacion_comprobantes__END
		    primary key (tipo_comprobante, nro_comprobante, tipo_comprobante_afectado, nro_comprobante_afectado),
 constraint FK__afectacion_comprobantes__cuenta_corriente_clientes__1__END 
            foreign key (tipo_comprobante, nro_comprobante) references dbo.cuenta_corriente,
 constraint FK__afectacion_comprobantes__cuenta_corriente_clientes__2__END 
            foreign key (tipo_comprobante_afectado, nro_comprobante_afectado) references dbo.cuenta_corriente,
 constraint CK__afectacion_comprobantes__comprobante_que_afecta__END
            check (tipo_comprobante in ('RE','NC')),
 constraint CK__afectacion_comprobantes__comprobante_afectado__END
            check (tipo_comprobante_afectado in ('FA','ND')),
 constraint CK__afectacion_comprobantes__importe_afectado__END
            check (importe_afectado > 0.00)
)
go

insert into dbo.clientes (nro_cliente, nom_cliente)
values (1,'CLIENTE NRO. 1'), 
       (2,'CLIENTE NRO. 2'),
       (3,'CLIENTE NRO. 3')
go

insert into dbo.cuenta_corriente (nro_cliente, tipo_comprobante, nro_comprobante, fecha_comprobante, importe_total, saldo)
values (1, 'FA', 00001, '1998-01-01', 1000.00, 1000.00),
       (1, 'NC', 00001, '1998-01-03',  150.00,  150.00),
       (1, 'ND', 00001, '1998-01-08',  120.00,  120.00),
       (1, 'RE', 00002, '1998-02-01',  850.00,  850.00),
       (1, 'RE', 00007, '1998-02-09', 1065.00, 1065.00),
       (1, 'FA', 00005, '1998-03-01', 1200.00, 1200.00),
       (1, 'FA', 00007, '1998-04-01',  700.00,  700.00),
       (1, 'ND', 00002, '1998-04-02',   30.00,   30.00),
       (1, 'RE', 00008, '1998-05-02',  130.00,  130.00),
       (1, 'NC', 00002, '1998-05-02',  500.00,  500.00)
go

insert into dbo.afectacion_comprobantes (tipo_comprobante, nro_comprobante, tipo_comprobante_afectado, nro_comprobante_afectado, importe_afectado)
values ('RE', 00002, 'FA', 00001, 850.00),
       ('NC', 00001, 'FA', 00001, 150.00),
       ('RE', 00007, 'ND', 00001, 120.00),
       ('RE', 00007, 'FA', 00005, 945.00),
       ('RE', 00008, 'ND', 00002,  30.00)
go

--NOTA: SE HAN INSERTADO LOS COMPROBANTES CON UN SALDO = IMPORTE_TOTAL, POR LO TANTO, LUEGO DE INSERTAR LAS AFECTACIONES ESOS SALDOS NO 
--      SON CONSISTENTES YA QUE DEBIERAN SER LOS SIGUIENTES:

--      FA-00001	  0.00	
--      ND-00001	  0.00
--      FA-00005	255.00	
--      ND-00002	  0.00
--      FA-00007	700.00	
--      RE-00002	  0.00
--      NC-00001	  0.00
--      RE-00007	  0.00
--      RE-00008	100.00	
--      NC-00002	500.00	

--DESARROLLE LOS SIGUIENTES PUNTOS:

--A. Crear triggers que actualicen el saldo del comprobante afectado y del comprobante que afecta cuando se inserta o borra una fila 
--   en la tabla afectacion_comprobantes. Los saldos de dichos comprobantes deben ser disminuidos con el importe afectado.
--   Nota1: No permitir la modificación de las filas en la tabla afectacion_comprobantes
--   Nota2: Implemente los triggers y recuerde dejar la base de datos de manera consistente actualizando los datos inconsistentes

--B. Crear un procedimiento almacenado que reciba como argumento un nro. de cliente y dos fechas, y muestre los movimientos de la 
--   cuenta corriente del cliente entre esas dos fechas con el siguiente formato:

--		  fecha    comprobante			 debe          haber           saldo
--------------------------------------------------------------------------------
--		xx/xx/xxxx saldo inicial                                     xxxxxxx.xx
--		xx/xx/xxxx xx-xxxxxxxxxx                     xxxxxxx.xx      xxxxxxx.xx
--		xx/xx/xxxx xx-xxxxxxxxxx                     xxxxxxx.xx      xxxxxxx.xx
--		xx/xx/xxxx xx-xxxxxxxxxx                     xxxxxxx.xx      xxxxxxx.xx
--		xx/xx/xxxx xx-xxxxxxxxxx      xxxxxxx.xx                     xxxxxxx.xx
--		xx/xx/xxxx xx-xxxxxxxxxx                     xxxxxxx.xx      xxxxxxx.xx
--		xx/xx/xxxx xx-xxxxxxxxxx      xxxxxxx.xx                     xxxxxxx.xx
--		xx/xx/xxxx xx-xxxxxxxxxx      xxxxxxx.xx                     xxxxxxx.xx

--donde la primera fila debe mostrar la fecha correspondiente al día anterior a la fecha menor informada como argumento, 
--como comprobante se mostrará el texto 'saldo inicial' y el saldo corresponderá al saldo del cliente a dicha fecha.
--Para cada movimiento se mostrará tipo y nro. de comprobante, el importe en una columna 'DEBE' si el comprobante es 
--una factura o una nota de débito, o en la columna 'HABER' si el comprobante es una nota de crédito o un recibo.
--Las filas deben estar ordenadas por fecha, tipo y número de comprobante.
--En cada fila se debe mostrar el saldo hasta el momento.

---------------------------------------------------------------------------------------------------------------------------------
select * from clientes
select * from cuenta_corriente
select * from afectacion_comprobantes
go

create or alter procedure get_movimientos_cliente 
	(
	@nro_cliente		integer,
	@fecha_desde		date,
	@fecha_hasta		date
	)
	as
		begin
			declare @fecha_inicial		date,
					@saldo_inicial		decimal(10,2),
					@fecha				date,
					@comprobante		varchar(20),
					@importe			decimal(10,2),
					@saldo				decimal(10,2)


			declare @cuenta_corriente	table (
				fecha					date			not null,
				comprobante				varchar(20)		not null,
				debe					decimal(10,2)	null,
				haber					decimal(10,2)	null,
				saldo					decimal(10,2)	null
			)

		  -- Seleccionamos la fecha inicial menos 1.
			select @fecha_inicial = DATEADD(dd, -1, @fecha_desde)
			select @saldo_inicial = sum(case when cc.tipo_comprobante in ('FA', 'ND') then cc.importe_total else -cc.importe_total end)
				from cuenta_corriente cc
			   where cc.nro_cliente = @nro_cliente
			     and cc.fecha_comprobante <= @fecha_inicial
			
		  -- Primer fila de la tabla, el saldo inicial
			insert into @cuenta_corriente (fecha, comprobante, saldo)
			values(@fecha_inicial, 'Saldo Inicial', @saldo_inicial)

		  -- Resto de las filas 
			insert into @cuenta_corriente (fecha, comprobante, debe, haber)
				select cc.fecha_comprobante,																--fecha
					   cc.tipo_comprobante + '-' + format(cc.nro_comprobante, '000000'),					--comprobante
					   case when cc.tipo_comprobante in ('FA', 'ND') then cc.importe_total else null end,	--debe
				       case when cc.tipo_comprobante in ('NC', 'RE') then cc.importe_total else null end	--haber
				from cuenta_corriente cc
			where cc.nro_cliente = @nro_cliente
			  and cc.fecha_comprobante between @fecha_desde and @fecha_hasta
	
	-- Calcular saldos
	declare cc cursor fast_forward for
		select fecha, comprobante, case when debe is not null then debe else -haber end
		  from @cuenta_corriente 
		  where fecha >= @fecha_desde
		order by fecha, comprobante
	
	set @saldo = @saldo_inicial
	open cc
	fetch cc into @fecha, @comprobante, @importe
		while @@FETCH_STATUS = 0	
		begin 
			set @saldo = @saldo + @importe

			update cc
			   set saldo = @saldo 
			from @cuenta_corriente cc
			where cc.comprobante = @comprobante

			fetch cc into @fecha, @comprobante, @importe
		end
	deallocate cc 

			--Convertimos la fecha a DD/MM/AAAA, ordenamos por fecha y comprobante
			select convert(varchar, fecha, 103) AS fecha, comprobante, debe, haber, saldo
				from @cuenta_corriente cc
			order by cc.fecha, comprobante

		--	select * 
		--		from cuenta_corriente cc
		--	where cc.nro_cliente = @nro_cliente
		--	  and cc.fecha_comprobante between @fecha_desde and @fecha_hasta
		--order by fecha_comprobante
		end
	go
	
execute get_movimientos_cliente @nro_cliente = 1, @fecha_desde = '1998-01-07', @fecha_hasta = '1998-04-02'

select *
	from cuenta_corriente cc
		join afectacion_comprobantes ac
			on cc.tipo_comprobante = ac.tipo_comprobante
			and cc.nro_comprobante = ac.nro_comprobante







--A
-- Programamos  el calculo de la columna redundante

select * 
	from afectacion_comprobantes a
		join cuenta_corriente cc
			on a.tipo_comprobante = cc.tipo_comprobante
			and a.nro_comprobante = cc.nro_comprobante

update cc
	set saldo = saldo - (select sum(a.importe_afectado)
							from inserted a
						  where a.tipo_comprobante = cc.tipo_comprobante
						  and a.nro_comprobante = cc.nro_comprobante))
	from cuenta_corriente cc
  where exists(select * 
					from inserted i
				  where a.tipo_comprobante = cc.tipo_comprobante
					and a.nro_comprobante = cc.nro_comprobante)
----					
select * 
	from afectacion_comprobantes a
		join cuenta_corriente cc
			on a.tipo_comprobante_afectado = cc.tipo_comprobante
			and a.nro_comprobante_afectado = cc.nro_comprobante

-- cuando sea delete cambio inserted por deleted y el - por el + en saldo -<+>
update cc
	set saldo = saldo - (select sum(a.importe_afectado)
							from inserted a
						  where a.tipo_comprobante_afectado  = cc.tipo_comprobante
						  and a.nro_comprobante_afectado  = cc.nro_comprobante))
	from cuenta_corriente cc
  where exists(select * 
					from inserted i
				  where a.tipo_comprobante_afectado  = cc.tipo_comprobante
					and a.nro_comprobante_afectado  = cc.nro_comprobante)



-- Analisis de las operaciones que participan en el calculo de la columna redundate

-------------------------------------------------------------------------------------------------------
-- tabla						insert						delete				update
-------------------------------------------------------------------------------------------------------
-- afectacion_comprobantes		propagar					propagar			no permitir
-------------------------------------------------------------------------------------------------------
-- cuenta_corriente				controlar saldo = importe	--------			controlar consistencia
-------------------------------------------------------------------------------------------------------



create or alter trigger ti_pa_afectacion_comprobantes_1
on afectacion_comprobantes
for insert
as 
begin
	update cc
	set saldo = saldo - (select sum(a.importe_afectado)
							from inserted a
						  where a.tipo_comprobante = cc.tipo_comprobante
						  and a.nro_comprobante = cc.nro_comprobante)
	from cuenta_corriente cc
  where exists(select * 
					from inserted i
				  where i.tipo_comprobante = cc.tipo_comprobante
					and i.nro_comprobante = cc.nro_comprobante)


	update cc
	set saldo = saldo - (select sum(i.importe_afectado)
							from inserted i
						  where i.tipo_comprobante_afectado  = cc.tipo_comprobante
						  and i.nro_comprobante_afectado  = cc.nro_comprobante)
	from cuenta_corriente cc
  where exists(select * 
					from inserted i
				  where i.tipo_comprobante_afectado  = cc.tipo_comprobante
					and i.nro_comprobante_afectado  = cc.nro_comprobante)
end
go


create or alter trigger td_pa_afectacion_comprobantes_1
on afectacion_comprobantes
for delete
as 
begin
	update cc
	set saldo = saldo + (select sum(d.importe_afectado)
							from deleted d
						  where d.tipo_comprobante = cc.tipo_comprobante
						  and d.nro_comprobante = cc.nro_comprobante)
	from cuenta_corriente cc
  where exists(select * 
					from deleted d
				  where d.tipo_comprobante = cc.tipo_comprobante
					and d.nro_comprobante = cc.nro_comprobante)


	update cc
	set saldo = saldo + (select sum(d.importe_afectado)
							from deleted d
						  where d.tipo_comprobante_afectado  = cc.tipo_comprobante
						  and d.nro_comprobante_afectado  = cc.nro_comprobante)
	from cuenta_corriente cc
  where exists(select * 
					from deleted d
				  where d.tipo_comprobante_afectado  = cc.tipo_comprobante
					and d.nro_comprobante_afectado  = cc.nro_comprobante)
end
go


-- Trigger para que no deje actualizar
create trigger tu_c_afectacion_comprobantes
on afectacion_comprobantes
for update
as
begin
	raiserror('No se permite la modificacion de la afectacion de comprobantes',16,1)
	rollback
end
go

--------------------------------------------------------------
--Proceso para que deje la base de datos en estado consistente
create or alter procedure arreglar_consistencia
as
begin
	declare @auxiliar table
	(
		tipo_comprobante			char(2),
		nro_comprobante				integer,
		importe_afectado			decimal(12,2)
	)
	insert into @auxiliar
	select af.tipo_comprobante, af.nro_comprobante, sum(af.importe_afectado) as importe
		from afectacion_comprobantes af
		group by tipo_comprobante, nro_comprobante

	declare @auxiliar_afectado table
	(
		tipo_comprobante_afectado	char(2),
		nro_comprobante_afectado	integer,
		importe_afectado			decimal(12,2)
	)
	insert into @auxiliar_afectado
	select af.tipo_comprobante_afectado, af.nro_comprobante_afectado, sum(af.importe_afectado) as importe
		from afectacion_comprobantes af
		group by af.tipo_comprobante_afectado, af.nro_comprobante_afectado
	
	update cc
		set importe_total = importe_total - aux.importe_afectado
		from cuenta_corriente cc
			join @auxiliar aux
				on cc.nro_comprobante=aux.nro_comprobante
				and cc.tipo_comprobante=aux.tipo_comprobante

	update cc
		set importe_total = importe_total - auxaf.importe_afectado
		from cuenta_corriente cc
			join @auxiliar_afectado	auxaf
				on cc.nro_comprobante=auxaf.nro_comprobante_afectado
				and cc.tipo_comprobante=auxaf.tipo_comprobante_afectado
end
go

execute arreglar_consistencia
