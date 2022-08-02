drop table det_asientos
drop table asientos
drop table plan_cuentas
go

create table plan_cuentas
(
 periodo		smallint		not null,
 cod_cuenta		char(7)			not null,
 nom_cuenta		varchar(100)	not null,
 imputable		char(1)			not null,
 cod_cta_padre  char(7)			null
)
go

-- período es un año calendario
-- el código de cuenta tiene una longitud fija de 7 caracteres
-- tiene 4 niveles x-xx-xx-xx
-- cod_cuenta es único por período
-- nom_cuenta es único por período
-- imputable es S o N
-- las cuentas imputables son las hojas (no tienen hijas)
-- la cuenta padre tiene los mismos valores para todos los niveles anteriores y 
-- cero en el nivel correspondiente a la cuenta 

create table asientos
(
 nro_asiento      integer		not null,
 cpto_asiento     varchar(100)  not null,
 fecha_asiento    date			not null
)
go

-- nro_asiento es único

create table det_asientos
(
 nro_asiento    integer			not null,
 nro_detalle    tinyint			not null,
 periodo		smallint		null,
 cod_cuenta		char(7)			null,
 cpto_cuenta    varchar(100)	null,
 debe_haber		char(1)			not null,
 importe		decimal(10,2)	not null
)
go

-- nro_detalle es único por asiento
-- el período de la cuenta debe ser consistente con la fecha del asiento 
-- debe_haber es D o H
-- importe es > 0.00
-- si no se informa la cuenta en det_asientos, se debe informar cpto_cuenta

insert into plan_cuentas
values (2000,'1000000','ACTIVO','N',NULL),
       (2000,'1010100','CAJA','S','1010000'),
       (2000,'1010000','DISPONIBILIDADES','N','1000000'),
       (2000,'1010200','BANCOS','N','1010000'),
       (2000,'1010201','BANCO PROV. DE CBA.','S','1010200'),
       (2000,'1010202','BANCO NAC. ARGENTINA','S','1010200'),
       (2000,'2000000','PASIVO','N',NULL),
       (2000,'2010000','ACTIVO CORRIENTE','N','2000000'),
       (2000,'2010100','ACREEDORES','N','2010000'),
       (2000,'2010101','YPF','S','2010100'),
       (2000,'2010102','EPEC','S','2010100'),
       (2000,'2010103','TELECOM','S','2010100'),
       (2001,'1000000','ACTIVO','N',NULL),
       (2001,'1010000','DISPONIBILIDADES','N','1000000'),
       (2001,'1010100','CAJA','S','1010000'),
       (2001,'1010200','BANCOS','N','1010000'),
       (2001,'1010203','BANCO SUQUIA','S','1010200'),
       (2001,'1010204','BANCO RIO','S','1010200'),
       (2001,'2000000','PASIVO','N',NULL),
       (2001,'2010000','ACTIVO CORRIENTE','N','2000000'),
       (2001,'2010100','ACREEDORES','N','2010000'),
       (2001,'2010101','TELEFONICA','S','2010100'),
       (2001,'2010102','AGUAS CORDOBESAS','S','2010100')
go

insert into asientos (nro_asiento, fecha_asiento, cpto_asiento)
values (1,'2002/02/10','Depósito en BPC'),
       (2,'2002/03/12','Extracción de BNA'),
       (3,'2002/05/03','Pago a YPF'),
       (4,'2002/06/10','Depósito en BNA'),
       (5,'2002/08/10','Pago a EPEC'),
       (6,'2002/08/12','Transferencia BPC a BNA')
go

insert into det_asientos
values (1,1,2000,'1010201',NULL,'D',1000.00),
	   (1,2,2000,'1010100',NULL,'H',1000.00),
	   (2,1,2000,'1010100',NULL,'D',700.00),
	   (2,2,2000,'1010202',NULL,'H',700.00),
	   (3,1,2000,'2010101',NULL,'D',600.00),
	   (3,2,2000,'1010100',NULL,'H',200.00),
	   (3,3,null,null,'Cheque','H',300.00),
	   (4,1,2000,'1010202',NULL,'D',400.00),
	   (4,2,2000,'1010100',NULL,'H',400.00),
	   (5,1,2000,'2010102',NULL,'D',1000.00),
	   (5,2,2000,'1010100',NULL,'H',700.00),
	   (5,3,2000,'1010201',NULL,'H',500.00),
	   (6,1,2000,'1010202',NULL,'D',1200.00),
	   (6,2,2000,'1010200',NULL,'H',1200.00)
go


/*
EJERCICIO 1:

- Crear las tablas con las reglas de integridad indicadas que pueden implementarse en forma declarativa
- Indique las redundancias existentes en el modelo

EJERCICIO 2:

Crear los triggers necesarios para verificar las siguientes reglas de integridad:

- Las cuentas imputables son las hojas (no tienen hijos)
- Las cuentas referenciadas en det_asientos deben corresponder al período correcto. 
  Es decir, deben coincidir el año del asiento con el periodo de la cuenta referenciada

EJERCICIO 3:

Programar un procedimiento que analice todos los asientos verificando la existencia de los siguientes errores:

1. Asientos desbalanceados
2. Asientos a los que les falte alguna imputación (referencia a cuentas)
3. Asientos que tengan alguna imputación a cuentas que no son imputables

NOTA: 
 - se deben dar los detalles del error
 - un asiento puede tener más de un error (inclusive del mismo tipo)
 - cada asiento se mostrará tantas veces como errores tenga aunque se repita el tipo de error

De acuerdo a los datos registrados, el resultado debiera ser el siguiente:

nro_asiento    fecha  cpto_asiento            error
------------------------------------------------------------------------------------------------------------------------
3        03/05/2000 Pago a YPF                El asiento esta desbalanceado - diferencia D-H: 100.00
3        03/05/2000 Pago a YPF                Al asiento le falta una imputación al haber por 300.00
5        10/08/2000 Pago a EPEC               El asiento esta desbalanceado - diferencia D-H: -200.00
6        12/08/2000 Transferencia BPC a BNA   El asiento tiene una imputación a la cuenta 1-01-02-00 que no es imputable

NOTA: - en asientos desbalanceados siempre mostrar la diferencia D-H (positiva o negativa)
      - si le falta una imputación se debe informar si es al debe o al haber y su importe
      - si tiene una imputación a una cuenta no imputable se debe mostrar el código de cuenta
        con la mascara x-xx-xx-xx

*/
