#
CREATE DATABASE vuelos;

#Selecciono la base de datos sobre la cual voy a hacer modificaciones
USE vuelos;

#Creacion Tablas para las entidades


CREATE TABLE comodidades(
	codigo INT UNSIGNED NOT NULL,
	descripcion TEXT NOT NULL,

	CONSTRAINT pk_comodidades
	PRIMARY KEY (codigo)

)ENGINE = InnoDB;

CREATE TABLE clases(
	nombre VARCHAR(50) NOT NULL,
	porcentaje DECIMAL(2,2) UNSIGNED NOT NULL,
	
	CONSTRAINT pk_clases
	PRIMARY KEY (nombre)
	
)ENGINE= InnoDB;

CREATE TABLE ubicaciones(
	pais VARCHAR(30) NOT NULL,
	estado VARCHAR(30) NOT NULL,
	ciudad VARCHAR(30) NOT NULL,

	huso SMALLINT NOT NULL
	check(huso between -12 and 12),
	
	CONSTRAINT pk_ubicaciones
	PRIMARY KEY (pais,estado,ciudad)
		
)ENGINE= InnoDB;

CREATE TABLE pasajeros(
	doc_tipo VARCHAR(50) NOT NULL,
	doc_nro INT UNSIGNED NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono VARCHAR(50) NOT NULL,
	nacionalidad VARCHAR(50) NOT NULL,

	CONSTRAINT pk_doc_pasajeros
	PRIMARY KEY (doc_tipo,doc_nro)

)ENGINE = InnoDB;

CREATE TABLE modelos_avion(
	modelo VARCHAR(50) NOT NULL,
	fabricante VARCHAR(50) NOT NULL,
	cabinas SMALLINT unsigned NOT NULL,
	cant_asientos SMALLINT unsigned NOT NULL,
	
	CONSTRAINT pk_modelos_avion
	PRIMARY KEY (modelo)
	
)ENGINE= InnoDB;

CREATE TABLE empleados(
	legajo INT UNSIGNED NOT NULL,
	doc_tipo VARCHAR(50) NOT NULL,
	doc_nro INT UNSIGNED NOT NULL,
	password VARCHAR(32) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono VARCHAR(50) NOT NULL,

	CONSTRAINT pk_empleados
	PRIMARY KEY (legajo)

)ENGINE = InnoDB;

CREATE TABLE aeropuertos(
	codigo VARCHAR(20) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	telefono VARCHAR(20) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	pais VARCHAR(30) NOT NULL,
	estado VARCHAR(30) NOT NULL,
	ciudad VARCHAR(30) NOT NULL,
	
	CONSTRAINT pk_aeropuertos
	PRIMARY KEY (codigo),
	
	CONSTRAINT FK_aeropuertos_ubicacion
	FOREIGN KEY (pais,estado,ciudad) REFERENCES ubicaciones(pais,estado,ciudad)
	
)ENGINE= InnoDB;

CREATE TABLE vuelos_programados(
	numero VARCHAR(50) NOT NULL,
	
	aeropuerto_salida VARCHAR(50) NOT NULL,
	aeropuerto_llegada VARCHAR(50) NOT NULL,

	CONSTRAINT pk_vuelos_programados
	PRIMARY KEY(numero),

	CONSTRAINT FK_vuelos_programados_aeropuerto_salidas
	FOREIGN KEY (aeropuerto_salida) REFERENCES aeropuertos (codigo),

	CONSTRAINT FK_vuelos_programados_aeropuerto_llegada
	FOREIGN KEY (aeropuerto_llegada) REFERENCES aeropuertos (codigo)

) ENGINE= InnoDB;

CREATE TABLE salidas(
	vuelo VARCHAR(50) NOT NULL,
	dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa'),
	hora_sale TIME(4) NOT NULL,
	hora_llega TIME(4) NOT NULL,
	modelo_avion VARCHAR(50) NOT NULL,
	
	CONSTRAINT pk_salidas
	PRIMARY KEY (vuelo,dia),
	
	CONSTRAINT FK_salidas_vuelo
	FOREIGN KEY (vuelo) REFERENCES vuelos_programados(numero),
	
	CONSTRAINT FK_salidas_modelo_avion
	FOREIGN KEY (modelo_avion) REFERENCES modelos_avion(modelo)
	
)ENGINE= InnoDB;

CREATE TABLE instancias_vuelo(
	vuelo VARCHAR(50) NOT NULL,
	fecha DATE NOT NULL,
	dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa') NOT NULL, 
	estado VARCHAR (50),
	
	CONSTRAINT pk_instancias_vuelo
	PRIMARY KEY (vuelo,fecha,dia),
	
	CONSTRAINT FK_instancias_vuelo_vuelo_salida
	FOREIGN KEY (vuelo,dia) REFERENCES salidas(vuelo,dia)
	
	
) ENGINE= InnoDB;

CREATE TABLE reservas(
	numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
	fecha DATE NOT NULL,
	vencimiento DATE NOT NULL,
	estado VARCHAR(50) NOT NULL,
	
	doc_tipo VARCHAR(50) NOT NULL,
	doc_nro INT UNSIGNED NOT NULL,
	
	legajo INT UNSIGNED NOT NULL,

	CONSTRAINT pk_reservas
	PRIMARY KEY (numero),


	CONSTRAINT FK_doc_pasajeros
	FOREIGN KEY (doc_tipo,doc_nro) REFERENCES pasajeros(doc_tipo,doc_nro)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT FK_legajo_reservas
	FOREIGN KEY (legajo) REFERENCES empleados(legajo)
		ON DELETE RESTRICT ON UPDATE CASCADE

)Engine = InnoDB;

CREATE TABLE brinda(
	vuelo VARCHAR(50) NOT NULL,
	dia ENUM ("Do", "Lu", "Ma", "Mi", "Ju", "Vi","Sa"),
	clase VARCHAR(50) NOT NULL,
	precio DECIMAL(7,2) UNSIGNED NOT NULL,
	cant_asientos INT UNSIGNED NOT NULL,
	
	CONSTRAINT pk_brinda
	PRIMARY KEY (vuelo,dia,clase),

	CONSTRAINT FK_vuelo_brinda
	FOREIGN KEY (vuelo,dia) REFERENCES salidas(vuelo,dia)
		ON DELETE RESTRICT ON UPDATE CASCADE,


	CONSTRAINT FK_clase_brinda
	FOREIGN KEY (clase) REFERENCES clases(nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE

)Engine = InnoDB;

CREATE TABLE posee(

	clase VARCHAR(50) NOT NULL,
	comodidad INT UNSIGNED NOT NULL,

	CONSTRAINT pk_posee
	PRIMARY KEY (clase,comodidad),
	
	CONSTRAINT FK_clase_posee
	FOREIGN KEY (clase) REFERENCES clases(nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE,


	CONSTRAINT FK_comodidad_posee
	FOREIGN KEY (comodidad) REFERENCES comodidades(codigo)
		ON DELETE RESTRICT ON UPDATE CASCADE

)Engine = InnoDB;

CREATE TABLE reserva_vuelo_clase(
	numero INT UNSIGNED NOT NULL,
	vuelo VARCHAR(50) NOT NULL,
	fecha_vuelo DATE NOT NULL,
	clase VARCHAR(50) NOT NULL,
	
	CONSTRAINT pk_reserva_vuelo_clase
	PRIMARY KEY (numero,vuelo,fecha_vuelo),

	CONSTRAINT FK_nombre_clase_reserva_vuelo_clase
	FOREIGN KEY (clase) REFERENCES clases(nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT FK_instancia_reserva_vuelo_clase
	FOREIGN KEY (vuelo,fecha_vuelo) REFERENCES instancias_vuelo(vuelo,fecha)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_numerorva_reserva_vuelo_clase
	FOREIGN KEY (numero) REFERENCES reservas(numero)
		ON DELETE RESTRICT ON UPDATE CASCADE

)Engine = InnoDB;


# CREACION DE LA VISTA
CREATE VIEW vuelos_disponibles AS
SELECT  info_vuelo.vuelo,info_vuelo.fecha,info_vuelo.dia,info_vuelo.modelo_avion,info_vuelo.hora_sale,info_vuelo.hora_llega,info_vuelo.Diferencia,
		info_aeropuerto.codigo_salida,info_aeropuerto.nombre_salida,info_aeropuerto.ciudad_salida,info_aeropuerto.estado_salida,info_aeropuerto.pais_salida,
		info_aeropuerto.codigo_llegada,info_aeropuerto.nombre_llegada,info_aeropuerto.ciudad_llegada,info_aeropuerto.estado_llegada,info_aeropuerto.pais_llegada,
		info_disponibles.clase,info_disponibles.precio,info_disponibles.Disponibles
		

FROM 	(SELECT sal.vuelo,ins.fecha,ins.dia,sal.modelo_avion,sal.hora_sale,sal.hora_llega, if(timediff(sal.hora_llega,sal.hora_sale)<0,timediff(timediff(sal.hora_llega,sal.hora_sale),"-24:00"),timediff(sal.hora_llega,sal.hora_sale)) as 'Diferencia'
		 FROM salidas sal, instancias_vuelo ins 
		 WHERE sal.vuelo=ins.vuelo and sal.dia=ins.dia) info_vuelo,
		 
		 (SELECT 	ins.vuelo,ins.fecha,ins.dia,
					a_salida.codigo codigo_salida,a_salida.nombre nombre_salida,a_salida.ciudad ciudad_salida,a_salida.pais pais_salida, a_salida.estado estado_salida,
					a_llegada.codigo codigo_llegada,a_llegada.nombre nombre_llegada,a_llegada.ciudad ciudad_llegada,a_llegada.pais pais_llegada, a_llegada.estado estado_llegada
		 FROM instancias_vuelo ins, vuelos_programados v, aeropuertos a_salida,aeropuertos a_llegada
		 WHERE ins.vuelo=v.numero and v.aeropuerto_salida= a_salida.codigo and v.aeropuerto_llegada=a_llegada.codigo) info_aeropuerto,
		 
		(SELECT TABLA_Disponibles_clase.vuelo,TABLA_Disponibles_clase.fecha,TABLA_Disponibles_clase.dia,TABLA_Disponibles_clase.clase,precio, ROUND((cant_asientos*(1+porcentaje))-Vendidos) as 'Disponibles' 
		 FROM	(SELECT tabla1.vuelo,tabla1.fecha,tabla1.dia,tabla1.clase,IF(tabla1.clase=tabla2.clase,vendidos,0) Vendidos	
				 FROM   (SELECT ins.vuelo,ins.fecha,ins.dia,b.clase,precio,cant_asientos,porcentaje
						 FROM instancias_vuelo ins, brinda b, clases c 
						 WHERE ins.vuelo=b.vuelo AND ins.dia=b.dia AND b.clase=c.nombre) tabla1,
				
						(SELECT ins.vuelo,ins.fecha,ins.dia,clase,count(clase) vendidos 
						 FROM instancias_vuelo ins JOIN reserva_vuelo_clase rvc ON ins.fecha=rvc.fecha_vuelo AND
																ins.vuelo=rvc.vuelo
						 GROUP BY vuelo,fecha,dia,clase) tabla2
				
				 WHERE tabla1.vuelo=tabla2.vuelo AND	 tabla1.fecha=tabla2.fecha AND tabla1.dia=tabla2.dia) TABLA_Vendidos_por_clase,
		
				(SELECT ins.vuelo,ins.fecha,ins.dia,b.clase,precio,cant_asientos,porcentaje
				 FROM instancias_vuelo ins, brinda b, clases c 
				 WHERE ins.vuelo=b.vuelo AND ins.dia=b.dia AND b.clase=c.nombre) TABLA_Disponibles_clase
		 
		 WHERE TABLA_Disponibles_clase.vuelo=TABLA_Vendidos_por_clase.vuelo 
				AND TABLA_Disponibles_clase.fecha=TABLA_Vendidos_por_clase.fecha
				AND TABLA_Disponibles_clase.dia=TABLA_Vendidos_por_clase.dia 
				AND TABLA_Disponibles_clase.clase=TABLA_Vendidos_por_clase.clase)  info_disponibles
				
WHERE	info_vuelo.vuelo=info_aeropuerto.vuelo AND info_aeropuerto.vuelo=info_disponibles.vuelo AND
		info_vuelo.fecha=info_aeropuerto.fecha AND info_aeropuerto.fecha=info_disponibles.fecha AND
		info_vuelo.dia=info_aeropuerto.dia AND info_aeropuerto.dia=info_disponibles.dia;
 



##CREACION DE USUARIOS##
#USUARIO CLIENTE
CREATE USER 'cliente'@'%' IDENTIFIED BY 'cliente';

GRANT SELECT ON vuelos.vuelos_disponibles TO 'cliente'@'%';


#USUARIO ADMIN
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON vuelos.* TO 'admin'@'localhost' WITH GRANT OPTION;


#USUARIO EMPLEADO
CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';
GRANT SELECT ON vuelos.* TO 'empleado'@'%';
GRANT ALL PRIVILEGES ON vuelos.reservas TO 'empleado'@'%';
GRANT ALL PRIVILEGES ON vuelos.pasajeros TO 'empleado'@'%';
GRANT ALL PRIVILEGES ON vuelos.reserva_vuelo_clase TO 'empleado'@'%';

