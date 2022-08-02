INGENIERÍA INFORMÁTICA – SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL N° 3 - 04/06/2019

Se tiene una base de datos de cuentas corrientes de clientes en la cual se registran los datos de clientes, los comprobantes asociados
a las transacciones realizadas por ellos y la relación entre dichos comprobantes.

Los comprobantes registrados son de 4 tipos:
- FA: Facturas que corresponden a compras realizadas por los clientes y que se consideran débitos en su cuenta corriente.
- ND: Notas de débito que corresponden a otros débitos realizados a los clientes, como por ejemplo: intereses por mora, gastos de 
      financiación, etc. Obviamente, estos comprobantes también se consideran débitos en su cuenta corriente.
- RE: Recibos por pagos realizados por los clientes y que se consideran créditos en su cuenta corriente.
- NC: Notas de crédito que corresponden a otros créditos realizados a los clientes, como por ejemplo: descuentos, bonificaciones, etc.
      Obviamente, estos comprobantes también se consideran créditos en su cuenta corriente.

También se registran las relaciones que existen entre esos comprobantes. Las relaciones válidas entre ellos son las siguientes:
- Los comprobantes considerados "créditos" (RE y NC) solo se aplican a comprobantes considerados "débitos" (FA y ND).
- Un comprobante de crédito (RE o NC) se puede aplicar a cero o varios comprobantes de débito (FA o ND).
- Un comprobante de débito puede tener aplicado cero o varios comprobantes de crédito.
- Cuando un recibo se aplica a una factura indica que con ese recibo se paga esa factura (total o parcialmente). Idem cuando se aplica
  a una nota de débito.
- Cuando una nota de crédito se aplica a una factura indica que con esa nota de crédito se cancela el monto de esa factura 
  (total o parcialmente). 
  Idem cuando se aplica a una nota de débito.
- Un recibo se puede aplicar a cero o más facturas y una factura puede ser pagada a través de uno o más recibos.

La tabla que almacena los comprobantes tiene una columna "saldo del comprobante" que es redundante.

Cuando un recibo o nota de crédito se aplica a una factura o nota de débito los saldos de ambos comprobantes involucrados disminuyen 
en el importe aplicado.

----------------------------------------------------------------------------------------------------------------------

drop table dbo.afectacion_comprobantes
drop table dbo.cuenta_corriente
drop table dbo.clientes
go

create table dbo.clientes
(
 nro_cliente 		integer 		not null,
 nom_cliente 		varchar(40) 	not null,
 constraint PK__clientes__END 
            primary key (nro_cliente)
)
go

create table dbo.cuenta_corriente
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

create table dbo.afectacion_comprobantes
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

insert into dbo.clientes	(nro_cliente, nom_cliente)
values						(1			,'CLIENTE NRO. 1'), 
							(2			,'CLIENTE NRO. 2'),
							(3			,'CLIENTE NRO. 3')
go

insert into dbo.cuenta_corriente	(nro_cliente, tipo_comprobante	, nro_comprobante	, fecha_comprobante	, importe_total	, saldo)
values								(1			, 'FA'				, 00001				, '1998-01-01'		, 1000.00		, 1000.00),
									(1			, 'NC'				, 00001				, '1998-01-03'		,  150.00		,  150.00),
									(1			, 'ND'				, 00001				, '1998-01-08'		,  120.00		,  120.00),
									(1			, 'RE'				, 00002				, '1998-02-01'		,  850.00		,  850.00),
									(1			, 'RE'				, 00007				, '1998-02-09'		, 1065.00		, 1065.00),
									(1			, 'FA'				, 00005				, '1998-03-01'		, 1200.00		, 1200.00),
									(1			, 'FA'				, 00007				, '1998-04-01'		,  700.00		,  700.00),
									(1			, 'ND'				, 00002				, '1998-04-02'		,   30.00		,   30.00),
									(1			, 'RE'				, 00008				, '1998-05-02'		,  130.00		,  130.00),
									(1			, 'NC'				, 00002				, '1998-05-02'		,  500.00		,  500.00)
go

insert into dbo.afectacion_comprobantes (tipo_comprobante, nro_comprobante, tipo_comprobante_afectado, nro_comprobante_afectado, importe_afectado)
values									('RE', 00002, 'FA', 00001, 850.00),
										('NC', 00001, 'FA', 00001, 150.00),
										('RE', 00007, 'ND', 00001, 120.00),
										('RE', 00007, 'FA', 00005, 945.00),
										('RE', 00008, 'ND', 00002,  30.00)
go

delete af
	from afectacion_comprobantes af

NOTA: SE HAN INSERTADO LOS COMPROBANTES CON UN SALDO = IMPORTE_TOTAL, POR LO TANTO, LUEGO DE INSERTAR LAS AFECTACIONES ESOS SALDOS NO 
      SON CONSISTENTES YA QUE DEBIERAN SER LOS SIGUIENTES:

      FA-00001	  0.00	
      ND-00001	  0.00
      FA-00005	255.00	
      ND-00002	  0.00
      FA-00007	700.00	
      RE-00002	  0.00
      NC-00001	  0.00
      RE-00007	  0.00
      RE-00008	100.00	
      NC-00002	500.00	

DESARROLLE LOS SIGUIENTES PUNTOS:

A. Crear triggers que actualicen el saldo del comprobante afectado y del comprobante que afecta cuando se inserta o borra una fila 
   en la tabla afectacion_comprobantes. Los saldos de dichos comprobantes deben ser disminuidos con el importe afectado.
   Nota: No permitir la modificación de las filas en la tabla afectacion_comprobantes (40 PUNTOS)
go


-- Trigger para insercion de afectaciones comprobantes
create trigger ti_p_afectacion_comprobantes
on afectacion_comprobantes
for insert
as
begin
	declare @tipo_comprobante char(2)
	declare @tipo_comprobante_afectado char(2)
	declare @nro_comprobante  integer
	declare @nro_comprobante_afectado integer
	declare @importe_afectado	decimal(12,2)

	declare i cursor for
		select i.tipo_comprobante, i.nro_comprobante, i.tipo_comprobante_afectado, i.nro_comprobante_afectado, i.importe_afectado
			from inserted i
		order by i.nro_comprobante asc

	open i 
	fetch i into @tipo_comprobante, @nro_comprobante,  @tipo_comprobante_afectado, @nro_comprobante_afectado, @importe_afectado
	while @@FETCH_STATUS = 0
	begin
			update cc
			set saldo = cc.saldo - @importe_afectado
			from cuenta_corriente cc
			where cc.nro_comprobante = @nro_comprobante
			 and  cc.tipo_comprobante= @tipo_comprobante

			update cc
			set saldo = cc.saldo - @importe_afectado
			from cuenta_corriente cc
			where cc.nro_comprobante = @nro_comprobante_afectado
			and   cc.tipo_comprobante = @tipo_comprobante_afectado

		fetch i into @tipo_comprobante, @nro_comprobante,  @tipo_comprobante_afectado, @nro_comprobante_afectado, @importe_afectado
	end
	deallocate i
end
go

-- Trigger para delete de afectaciones comprobantes
create trigger td_p_afectacion_comprobantes
on afectacion_comprobantes
for delete
as
begin
	declare @tipo_comprobante char(2)
	declare @tipo_comprobante_afectado char(2)
	declare @nro_comprobante  integer
	declare @nro_comprobante_afectado integer
	declare @importe_afectado	decimal(12,2)

	declare d cursor for
		select d.tipo_comprobante, d.nro_comprobante, d.tipo_comprobante_afectado, d.nro_comprobante_afectado, d.importe_afectado
			from deleted d
		order by d.nro_comprobante asc

	open d 
	fetch d into @tipo_comprobante, @nro_comprobante,  @tipo_comprobante_afectado, @nro_comprobante_afectado, @importe_afectado
	while @@FETCH_STATUS = 0
	begin
			update cc
			set saldo = cc.saldo + @importe_afectado
			from cuenta_corriente cc
			where cc.nro_comprobante = @nro_comprobante
			 and  cc.tipo_comprobante= @tipo_comprobante

			update cc
			set saldo = cc.saldo + @importe_afectado
			from cuenta_corriente cc
			where cc.nro_comprobante = @nro_comprobante_afectado
			and   cc.tipo_comprobante = @tipo_comprobante_afectado

		fetch d into @tipo_comprobante, @nro_comprobante,  @tipo_comprobante_afectado, @nro_comprobante_afectado, @importe_afectado
	end
	deallocate d
end
go

-- Trigger para que no deje actualizar
create trigger tu_c_afectacion_comprobantes
on afectacion_comprobantes
for update
as
begin
	if (update(tipo_comprobante) or update (nro_comprobante)
		or update (tipo_comprobante_afectado) or update (nro_comprobante_afectado)
		or update (importe_afectado))
	begin
		raiserror('No se permite la modificacion de la afectacion de comprobantes',16,1)
		rollback
		return
	end
end
go

-- B. Programar y ejecutar un proceso (pueden ser varios pasos) que deje la base de datos en estado consistente (20 PUNTOS)

alter procedure arreglar_consistencia
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
		set saldo = saldo - aux.importe_afectado
		from cuenta_corriente cc
		join @auxiliar aux
			on cc.nro_comprobante=aux.nro_comprobante
			and cc.tipo_comprobante=aux.tipo_comprobante

	update cc
		set saldo = saldo - auxaf.importe_afectado
		from cuenta_corriente cc
		join @auxiliar_afectado	auxaf
			on cc.nro_comprobante=auxaf.nro_comprobante_afectado
			and cc.tipo_comprobante=auxaf.tipo_comprobante_afectado
end
go

-- para arreglar consistencia antes de que se ejecuten los triggers
execute arreglar_consistencia


NOTA: Puede probar los triggers con estas inserciones:

insert into cuenta_corriente (nro_cliente, tipo_comprobante, nro_comprobante, fecha_comprobante, importe_total, saldo)
values (2, 'FA', 00002, '1998-01-07', 1000.00, 1000.00),
       (2, 'ND', 00006, '1998-03-07',  600.00,  600.00),
       (2, 'RE', 00009, '1998-04-01', 1400.00, 1400.00),
       (2, 'NC', 00003, '1998-01-07',  150.00,  150.00)
go


insert into afectacion_comprobantes (tipo_comprobante, nro_comprobante, tipo_comprobante_afectado, nro_comprobante_afectado, importe_afectado)
values ('RE', 00009, 'FA', 00002, 1000.00),
       ('RE', 00009, 'ND', 00006,  400.00)
go

LOS SALDOS PARA CADA COMPROBANTE DEBEN QUEDAR:

FA-00002	  0.00
ND-00006	200.00
RE-00009	  0.00
NC-00003	150.00

select *
	from cuenta_corriente

C. Crear un procedimiento almacenado que reciba como argumento un nro. de cliente y dos fechas, y muestre los movimientos de la 
   cuenta corriente del cliente entre esas dos fechas con el siguiente formato: (40 PUNTOS)

  fecha    comprobante              debe          haber           saldo
------------------------------------------------------------------------
xx/xx/xxxx saldo inicial                                     xxxxxxx.xx
xx/xx/xxxx xx-xxxxxxxxxx                     xxxxxxx.xx      xxxxxxx.xx
xx/xx/xxxx xx-xxxxxxxxxx                     xxxxxxx.xx      xxxxxxx.xx
xx/xx/xxxx xx-xxxxxxxxxx                     xxxxxxx.xx      xxxxxxx.xx
xx/xx/xxxx xx-xxxxxxxxxx      xxxxxxx.xx                     xxxxxxx.xx
xx/xx/xxxx xx-xxxxxxxxxx                     xxxxxxx.xx      xxxxxxx.xx
xx/xx/xxxx xx-xxxxxxxxxx      xxxxxxx.xx                     xxxxxxx.xx
xx/xx/xxxx xx-xxxxxxxxxx      xxxxxxx.xx                     xxxxxxx.xx

donde la primera fila debe mostrar la fecha correspondiente al día anterior a la fecha menor informada como argumento, 
como comprobante se mostrará el texto 'saldo inicial' y el saldo corresponderá al saldo del cliente a dicha fecha.
Para cada movimiento se mostrará tipo y nro. de comprobante, el importe en una columna 'DEBE' si el comprobante es 
una factura o una nota de débito, o en la columna 'HABER' si el comprobante es una nota de crédito o un recibo.
Las filas deben estar ordenadas por fecha, tipo y número de comprobante.
En cada fila se debe mostrar el saldo hasta el momento.


alter procedure get_movimientos
(
	@nro_cliente	integer,
	@fecha1			date,
	@fecha2			date
)
as
begin
	declare @primer_fecha date
	select @primer_fecha = dateadd(day,-1,@fecha1)

	declare @saldo_inicial decimal(12,2)

	declare @calcular_saldo_inicial table
	(
		debe	decimal(12,2),
		haber	decimal(12,2)
	)
	insert into @calcular_saldo_inicial
	select * 
	from
		(select sum(cc.importe_total) debe
		from cuenta_corriente cc
			where cc.nro_cliente=1
			and   cc.tipo_comprobante in ('FA','ND')
			and   cc.fecha_comprobante < @fecha1) aux1
		cross join
		(select sum(cc.importe_total) haber
		 from cuenta_corriente cc
			where cc.nro_cliente=1
			and   cc.tipo_comprobante in ('RE','NC')
			and   cc.fecha_comprobante < @fecha1) aux2

	declare @fecha date
	declare @tipo_de_comprobante char(2)
	declare @nro_comprobante  integer
	declare @importe	decimal(12,2)
	declare @debe decimal(12,2)
	declare @haber decimal(12,2)
	declare @saldo decimal(12,2)

	select @saldo_inicial = c.debe-c.haber
							 from @calcular_saldo_inicial c

	declare @resultado table
	(
		fecha			date			not null,
		comprobante		varchar(50)		not null,
		debe			decimal(12,2)	null,
		haber			decimal(12,2)	null,
		saldo			decimal(12,2)	not null
	)

	insert into @resultado
	values		(@primer_fecha, 'saldo inicial'	, null,	null, case when @saldo_inicial is null then 0 else @saldo_inicial end)

	set @saldo = case when @saldo_inicial is null then 0
											      else @saldo_inicial
												  end
	declare cc cursor
		for select cc.fecha_comprobante, cc.tipo_comprobante, cc.nro_comprobante, cc.importe_total
			from cuenta_corriente cc
			where cc.nro_cliente=@nro_cliente
			and   cc.fecha_comprobante >= @fecha1
		  order by cc.fecha_comprobante asc
	open cc
	fetch cc into @fecha, @tipo_de_comprobante,@nro_comprobante,@importe
	
	while @@FETCH_STATUS = 0 and @fecha <= @fecha2
	begin
		if (@tipo_de_comprobante in('FA','ND'))
		begin
			set @saldo = @saldo + @importe
			insert into @resultado (fecha	,comprobante								,debe	,haber		,saldo)
			values			       (@fecha	,concat(@tipo_de_comprobante,'-',@nro_comprobante) ,@importe,null	,@saldo)
		end
		
		if (@tipo_de_comprobante in('RE','NC'))
		begin
			set @saldo = @saldo - @importe
			insert into @resultado (fecha	,comprobante								,debe		,haber		,saldo)
			values			       (@fecha	,concat(@tipo_de_comprobante,'-',@nro_comprobante) ,null	,@importe		,@saldo)
		end
	fetch cc into @fecha, @tipo_de_comprobante,@nro_comprobante,@importe
	end
	deallocate cc

	select *
		from @resultado
end
go


execute get_movimientos 1,'1998-02-01','1998-04-30'
execute get_movimientos 1,'1998-01-01','1998-04-30'

 
---------------------------------------------------------------------------------------------------------------------------------

EJEMPLO 1:

nro_cliente = 1
fecha_desde = 01/02/1998
fecha_hasta = 30/04/1998

  fecha    comprobante              debe          haber           saldo

31/01/1998 saldo inicial                                         970.00
01/02/1998 RE-00002                              850.00          120.00  
09/02/1998 RE-00007                             1065.00         -945.00  
01/03/1998 FA-00005              1200.00                         255.00  
01/04/1998 FA-00007               700.00                         955.00  
02/04/1998 ND-00002                30.00                         985.00

---------------------------------------------------------------------------------------------------------------------------------

EJEMPLO 2:

nro_cliente = 1
fecha_desde = 01/01/1998
fecha_hasta = 30/04/1998

  fecha    comprobante              debe          haber           saldo

31/12/1997 saldo inicial                                           0.00
01/01/1998 FA-00001              1000.00                        1000.00  
03/01/1998 NC-00001                              150.00          850.00  
08/01/1998 ND-00001               120.00                         970.00  
01/02/1998 RE-00002                              850.00          120.00  
09/02/1998 RE-00007                             1065.00         -945.00  
01/03/1998 FA-00005              1200.00                         255.00  
01/04/1998 FA-00007               700.00                         955.00  
02/04/1998 ND-00002                30.00                         985.00

---------------------------------------------------------------------------------------------------------------------------------
