drop table cuentas 
drop table detalle_reservas
drop table reservas
drop table recibos
drop table huespedes
drop table habitaciones
drop table tipos_habitaciones
drop table clientes

create table clientes (
	nro_cliente				integer,
	apellido_cliente		varchar(50),
	nombre_cliente			varchar(50),
	tipo_doc_cliente		varchar(3),
	nro_doc_cliente			integer,
	genero					varchar(15),
	fecha_nac_cliente		date,
	telefono				integer,

	primary key(nro_cliente)
)
go

create table tipos_habitaciones (
	cod_tipo_habitacion		integer,
	desc_tipo_habitacion	varchar(100),
	costo_diario			decimal(10,2),

	primary key(cod_tipo_habitacion)
)
go

create table habitaciones (
	nro_habitacion			smallint,
	cod_tipo_habitacion		integer,
	piso					tinyint,
	observaciones			varchar(50),

	primary key(nro_habitacion),
	foreign key(cod_tipo_habitacion) references tipos_habitaciones(cod_tipo_habitacion)
)
go

create table huespedes (
	nro_cuenta				integer,
	nro_cliente				integer,
	fecha_ingreso			date,
	fecha_egreso			date,

	primary key(nro_cuenta, nro_cliente),
	foreign key(nro_cliente) references clientes(nro_cliente)
)
go

create table recibos (
	nro_recibo				integer,
	fecha_recibo			date,
	nro_cliente				integer,

	primary key(nro_recibo),
	foreign key (nro_cliente) references clientes(nro_cliente)
)
go

create table reservas (
	nro_reserva				integer,
	nro_cliente				integer,
	fecha_reserva			date,

	primary key(nro_reserva),
	foreign key(nro_cliente) references clientes(nro_cliente)
)
go

create table detalle_reservas (
	nro_detalle_reserva		integer,
	nro_reserva				integer,
	cod_tipo_habitacion		tinyint,
	cant_huespedes			smallint,
	fecha_ingreso			date,
	fecha_egreso			date,

	primary key(nro_detalle_reserva, nro_reserva),
	foreign key(nro_reserva) references reservas(nro_reserva)
)
go

create table cuentas (
	nro_cuenta				integer,
	nro_habitacion			smallint,
	nro_cliente				integer,
	nro_reserva				integer,
	nro_detalle_reserva		integer,
	fecha_hora_ingreso		date,
	fecha_hora_egreso		date,
	nro_factura				integer,
	importe_factura			decimal(10,2),
	nro_recibo				integer

	primary key(nro_cuenta),
	foreign key(nro_habitacion) references habitaciones(nro_habitacion),
	foreign key(nro_cliente) references clientes(nro_cliente),
	foreign key(nro_reserva) references reservas(nro_reserva),
	foreign key(nro_recibo)	references recibos(nro_recibo)
)
go

select * from cuentas 
select * from detalle_reservas
select * from reservas
select * from recibos
select * from huespedes
select * from habitaciones
select * from tipos_habitaciones
select * from clientes

--2.	Programar una función escalar que devuelva una ‘S’ o una ‘N’ para indicar si una 
--habitación está disponible o no, respectivamente, en una fecha determinada. La función 
--recibe como argumentos el nro. de habitación y la fecha. Considerar que una habitación está 
--disponible si no hay ninguna cuenta asociada a la misma para la cual la fecha ingresada está
--dentro del rango de fecha_ingreso y fecha_salida, o la fecha ingresada es mayor que la fecha
--_ingreso y la fecha_salida es nula (la habitación aún está ocupada).

create function habitacion_disponible 
(
	@nro_habitacion		smallint,
	@fecha				datetime
)
	returns char(1)
	as
		begin
			select if exists (
				select * 
					from 
			)
		end
	go










	



	