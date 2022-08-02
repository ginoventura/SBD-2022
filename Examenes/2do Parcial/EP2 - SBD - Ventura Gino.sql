DROP TABLE habitaciones
DROP TABLE tipos_habitaciones
DROP TABLE detalle_reservas
DROP TABLE reservas
DROP TABLE recibos
DROP TABLE huespedes
DROP TABLE clientes
DROP TABLE cuentas
GO

CREATE TABLE habitaciones (
nro_habitacion					SMALLINT					NOT NULL,	
cod_tipo_habitacion				VARCHAR(15)					NOT NULL,
piso_habitacion					TINYINT						NOT NULL,
obs_habitacion					VARCHAR(50)					NOT NULL,

CONSTRAINT PK__habitaciones__END							PRIMARY KEY(nro_habitacion),
CONSTRAINT FK__habitaciones__tipos_habitaciones__1__END		FOREIGN KEY (cod_tipo_habitacion) REFERENCES tipos_habitaciones
)
GO

CREATE TABLE tipos_habitaciones (
cod_tipo_habitacion				VARCHAR(15)					NOT NULL,	
desc_tipo_habitacion			VARCHAR(100)				NOT NULL,
costo_diario					DECIMAL(10,2)				NOT NULL,

CONSTRAINT PK__tipos_habitaciones__END						PRIMARY KEY(cod_tipo_habitacion)
)
GO

CREATE TABLE detalle_reservas (
nro_reserva						SMALLINT					NOT NULL,	
nro_detalle_reserva				SMALLINT					NOT NULL,	
cod_tipo_habitacion				VARCHAR(15)					NOT NULL,	
cant_huespedes					TINYINT						NOT NULL,
fecha_ingreso					DATE						NOT NULL,
fecha_egreso					DATE						NOT NULL,

CONSTRAINT PK__detalle_reservas__END						PRIMARY KEY(nro_reserva, nro_detalle_reserva),
CONSTRAINT FK__detalle_reservas__reservas__1__END			FOREIGN KEY(nro_reserva) REFERENCES reservas,
CONSTRAINT FK__detalle_reservas__tipos_habitaciones__1__END	FOREIGN KEY(cod_tipo_habitacion) REFERENCES tipos_habitaciones
)
GO

CREATE TABLE reservas (
nro_reserva						SMALLINT					NOT NULL,
nro_cliente						SMALLINT					NOT NULL,
fecha_reserva					DATE						NOT NULL,

CONSTRAINT PK__reservas__END								PRIMARY KEY(nro_reserva)
)
GO

CREATE TABLE recibos (
nro_recibo						SMALLINT					NOT NULL,	
fecha_recibo					DATE						NOT NULL,
nro_cliente						SMALLINT					NOT NULL,

CONSTRAINT PK__recibos__END									PRIMARY KEY(nro_recibo),
CONSTRAINT FK__recibos__clientes__1__END					FOREIGN KEY(nro_cliente) REFERENCES clientes
)
GO

CREATE TABLE huespedes (
nro_cuenta						SMALLINT					NOT NULL,	--FK CUENTAS
nro_cliente						SMALLINT					NOT NULL,	--FK CLIENTES
fecha_ingreso					DATE						NOT NULL,
fecha_salida					DATE						NOT NULL,

CONSTRAINT PK__huespedes__END								PRIMARY KEY(nro_cuenta, nro_cliente),
CONSTRAINT FK__huespedes__cuentas__1__END					FOREIGN KEY(nro_cuenta) REFERENCES cuentas,
CONSTRAINT FK__huespedes__clientes__1__END					FOREIGN KEY(nro_cliente) REFERENCES clientes
)
GO

CREATE TABLE clientes (
nro_cliente							SMALLINT				NOT NULL,	
nombre_cliente						VARCHAR(30)				NOT NULL,
apellido_cliente					VARCHAR(30)				NOT NULL,
nro_dni_cliente						INTEGER					NOT NULL,
tipo_dni_cliente					VARCHAR(10)				NOT NULL,
genero_cliente						VARCHAR(2)				NOT NULL,
fecha_nac							DATE					NOT NULL,
email_cliente						VARCHAR(50)				NOT NULL,
tel_cliente							VARCHAR(100)			NOT NULL,

CONSTRAINT PK__clientes__END								PRIMARY KEY(nro_cliente)
)
GO

CREATE TABLE cuentas (
nro_cuenta							SMALLINT				NOT NULL,	
nro_habitacion						SMALLINT				NOT NULL,	
nro_cliente							SMALLINT				NOT NULL,	
nro_reserva							SMALLINT				NOT NULL,	
nro_detalle_reserva					SMALLINT				NOT NULL,	
fecha_hora_ingreso					DATETIME				NOT NULL,	
fecha_hora_salida					DATETIME				NOT NULL,
nro_factura							SMALLINT				NOT NULL,
importe_factura						DECIMAL(10,2)			NOT NULL,
nro_recibo							SMALLINT				NOT NULL,	

CONSTRAINT PK__cuentas__END									PRIMARY KEY(nro_cuenta),
CONSTRAINT FK__cuentas__habitaciones__1__END				FOREIGN KEY(nro_habitacion)		REFERENCES habitaciones,
CONSTRAINT FK__cuentas__clientes__1__END					FOREIGN KEY(nro_cliente)		REFERENCES clientes,
CONSTRAINT FK__cuentas__reservas__1__END					FOREIGN KEY(nro_reserva)		REFERENCES reservas,
CONSTRAINT FK__cuentas__detalle_reservas__1__END			FOREIGN KEY(nro_detalle_reserva, nro_recibo) REFERENCES detalle_reservas,
)
GO

--EJERCICIO 2) 

CREATE FUNCTION fn_habitacion_disponible (
	@nro_habitacion		SMALLINT,
	@fecha				DATETIME
)
RETURNS CHAR(1)
AS
BEGIN
	DECLARE @habitacion_disponible		CHAR(1)
		SELECT @habitacion_disponible = CASE WHEN EXISTS 
		(SELECT *
			FROM cuentas c
				WHERE c.nro_habitacion = @nro_habitacion 
					  AND c.fecha_hora_salida IS NULL
					  AND c.fecha_hora_ingreso <= @fecha
					  AND c.fecha_hora_salida >= @fecha)
			THEN 'S'
			ELSE 'N'
		END
	RETURN (@habitacion_disponible)
END
GO

DROP FUNCTION fn_habitacion_disponible

-- EJERCICIO 3)

SELECT fn_habitacion_disponible (5, '2022-05-27')


