#
CREATE DATABASE vuelos;

#Selecciono la base de datos sobre la cuel voy a hacer modificaciones
USE vuelos;

#Creacion Tablas para las entidades

CREATE TABLE vuelos_programados(
	numero VARCHAR(50) NOT NULL,
	aeropuerto_salida VARCHAR(50) NOT NULL, 
	aeropuerto_llegada VARCHAR(50) NOT NULL,
	
	CONSTANT pk_vuelos_programados
	PRIMARY KEY (numero),
	
	CONSTRAINT FK_vuelos_programados_aeropuerto_salidas
	FOREIGN KEY (aeropuerto_salida) REFERENCES aeropuertos (codigo),
	
	CONSTRAINT FK_vuelos_programados_aeropuerto_llegada 
	FOREIGN KEY (aeropuerto_llegada) REFERENCES aeropuertos (codigo),
	
) ENGINE= InnoDB;

CREATE TABLE salidas(
	vuelo
)