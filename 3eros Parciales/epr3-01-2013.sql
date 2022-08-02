
drop table det_recibos
drop table recibos
drop table cuotas
drop table garantes
drop table creditos
drop table clientes
go

create table clientes
(
	nro_cliente		int			not null primary key,
	nom_cliente		varchar(40)	not null unique 
)
go

create table creditos
(
	nro_credito			int				not null primary key,
	nro_cliente			int				not null references clientes,
	fecha_aprobacion	datetime		not null,
	importe_credito		decimal(4,2)	not null
)
go

create table garantes
(
	nro_credito		int		not null references creditos,
	nro_garante		int		not null unique 
)
go 

create table cuotas
(
	nro_credito				int			not null references creditos,
	nro_cuota				int			not null primary key,
	fecha_vencimiento		datetime	not null,
	importe_cuota			decimal		not null,
	check (importe_cuota > 0)
)
go

create table recibos
(
	nro_recibo		int			not null primary key,
	nro_cliente		int			not null references cliente,	
	fecha_pago		datetime	not null
	check (nro_recibo > 0)
)
go

create table det_recibos
(
	nro_recibo		int				not null references recibos,
	nro_credito		int				not null references credito,
	nro_cuota		int				not null references cuota,
	importe_pago	decimal(4,2)	not null check (importe_pago > 0),
	primary key (nro_credito,nro_cuota)
	foreign key (nro_recibo)
	foreign key (nro_credito)
	foreign key (nro_cuota)	
)
go

--ejercicio 2
--cuotas: 
-- La fecha de vencimiento debe ser mayor a la fecha de aprobación del crédito.  

   select *
   from cuotas cu join creditos cred on cu.nro_credito = cred.nro_credito
   where cu.fecha_vencimiento <= cred.fecha_aprobacion
  
  
  --La suma  total de los importes de las cuotas debe ser igual al importe del crédito  que corresponda
  
  select c.importe_cuota,c.nro_credtio,c.nro_cuota
  from cuotas c
  group by nro_credito
  having count(*) < ( select cred.importe_credito from creditos cred
						where c.nro_credito = cred.nro_credito)
  --detalle recibos:  
--Cada recibo puede pagar la cuota completa o una parte de la una cuota

	select *
    from det_recibos d join cuotas c on d.nro_cuota = c.nro_cuota
    where d.importe_pago > c.importe_cuota
    
--ejercicio 3

--La fecha de vencimiento debe ser mayor a la fecha de aprobación del crédito.  
drop trigger
create trigger t_ri_cuotas
     on cuotas
     for insert
     as
     begin
		 if EXISTS (select * from inserted cu join creditos cred on cred.nro_credito = cu.nro_credito
						where cred.fecha_aprobacion >= cu.fecha_vencimiento)
							begin
									raiserror ('La fecha de vencimiento debe ser mayor a la fecha de aprobación del crédito',16,1)
									rollback
							end
      end
      
          
    
--ejercicio 4:

	alter table creditos
	add  pagado varchar(1) default 'N'
	check (pagado in ('S','N'))
 	set pagado = case when exists (( select detr.nro_credito from det_recibos detr
	group by detr.nro_credito
	having sum(detr.importe_pago) = (select cred.importe_credito from creditos cred
										where cred.nro_credito = detr.nro_credito)) )
			then 'S' else 'N'
	end
	
			