#
CREATE DATABASE vuelos;

#Selecciono la base de datos sobre la cuel voy a hacer modificaciones
USE vuelos;

#Creacion Tablas para las entidades


CREATE TABLE comodidades(
	codigo INT NOT NULL,
	descripcion VARCHAR(50),

	CONSTRAINT pk_comodidades
	PRIMARY KEY (codigo)

)ENGINE = InnoDB;

CREATE TABLE clases(
	nombre VARCHAR(50) NOT NULL,
	porcentaje FLOAT(4,2),
	
	CONSTRAINT pk_clases
	PRIMARY KEY (nombre)
	
)ENGINE= InnoDB;

CREATE TABLE ubicaciones(
	pais VARCHAR(30) NOT NULL,
	estado VARCHAR(30) NOT NULL,
	ciudad VARCHAR(30) NOT NULL,
	huso SMALLINT NOT NULL,
	
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
	telefono VARCHAR(20),
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
	PRIMARY KEY (numero),

	CONSTRAINT FK_vuelos_programados_aeropuerto_salidas
	FOREIGN KEY (aeropuerto_salida) REFERENCES aeropuertos (codigo),

	CONSTRAINT FK_vuelos_programados_aeropuerto_llegada
	FOREIGN KEY (aeropuerto_llegada) REFERENCES aeropuertos (codigo)

) ENGINE= InnoDB;


CREATE TABLE salidas(
	vuelo VARCHAR(50) NOT NULL,
	dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa'),
	hora_sale SMALLINT NOT NULL,
	hora_llega SMALLINT NOT NULL,
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
	dia ENUM('Do','Lu','Ma','Mi','Ju','Vi','Sa'), 
	estado VARCHAR (50) NOT NULL,
	
	CONSTRAINT pk_instancias_vuelo
	PRIMARY KEY (vuelo,fecha),
	
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
	precio FLOAT(7,5) NOT NULL,
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
	comodidad INT NOT NULL,

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
	FOREIGN KEY (vuelo,fecha_vuelo) REFERENCES instacias_vuelo(vuelo,fecha_vuelo)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_numerorva_reserva_vuelo_clase
	FOREIGN KEY (numero) REFERENCES reservas(numero)
		ON DELETE RESTRICT ON UPDATE CASCADE

)Engine = InnoDB;
