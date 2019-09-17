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

#USUARIO ADMIN
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON vuelos.* TO 'admin'@'localhost' WITH GRANT OPTION;


#USUARIO EMPLEADO
CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';
GRANT SELECT ON vuelos.* TO 'empleado'@'%';
GRANT ALL PRIVILEGES ON vuelos.reservas TO 'empleado'@'%';
GRANT ALL PRIVILEGES ON vuelos.pasajeros TO 'empleado'@'%';
GRANT ALL PRIVILEGES ON vuelos.reserva_vuelo_clase TO 'empleado'@'%';


# CREACION DE LA VISTA
CREATE VIEW vuelos_disponibles AS
SELECT  info_vuelo.vuelo,info_vuelo.fecha,info_vuelo.dia,info_vuelo.modelo_avion,info_vuelo.hora_sale,info_vuelo.hora_llega,info_vuelo.Diferencia,
		info_aeropuerto.codigo_salida,info_aeropuerto.nombre_salida,info_aeropuerto.ciudad_salida,info_aeropuerto.estado_salida,info_aeropuerto.pais_salida,
		info_aeropuerto.codigo_llegada,info_aeropuerto.nombre_llegada,info_aeropuerto.ciudad_llegada,info_aeropuerto.estado_llegada,info_aeropuerto.pais_llegada,
		info_disponibles.clase,info_disponibles.precio,info_disponibles.Disponibles
		

FROM 	(SELECT sal.vuelo,ins.fecha,ins.dia,sal.modelo_avion,sal.hora_sale,sal.hora_llega,timediff('00:00','00:00') as 'Diferencia'
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
 

 #USUARIO CLIENTE
CREATE USER 'cliente'@'%' IDENTIFIED BY 'cliente';

GRANT SELECT ON vuelos.vuelos_disponibles TO 'cliente'@'%';


##comodidades
INSERT INTO comodidades VALUES (10,"Asientos grandes");
INSERT INTO comodidades VALUES (20,"Aire Acondicionado");
INSERT INTO comodidades VALUES (30,"Barra de bebidas");

##clases
INSERT INTO clases VALUES ("Turista", 0.30);
INSERT INTO clases VALUES ("Premium", 0.99);
INSERT INTO clases VALUES ("Low Cost", 0.50);

##ubicaciones
INSERT INTO ubicaciones VALUES ("Argentina", "Buenos Aires","Bahia Blanca", -3);
INSERT INTO ubicaciones VALUES ("Argentina", "Buenos Aires","Buenos Aires", -3);
INSERT INTO ubicaciones VALUES ("Argentina", "Santa Cruz","Rio Gallegos", -3);
INSERT INTO ubicaciones VALUES ("Argentina", "Buenos Aires","La Plata", -3);

##pasajeros
INSERT INTO pasajeros VALUES ("DNI",41386475,"Montenegro","Maximiliano","Panama 323","2974933333","Argentino");
INSERT INTO pasajeros VALUES ("DNI",40777475,"Lopez","Joaquin","Zapiola 1000","291987654","Argentino");
INSERT INTO pasajeros VALUES ("DNI",40888475,"Gonzalez","Enrique","Alem 523","2980000000","Argentino");
INSERT INTO pasajeros VALUES ("DNI",12386999,"Soto","Gaston","Alem 10","2985933333","Chileno");
INSERT INTO pasajeros VALUES ("DNI",11386475,"Rau","Joaquin","Alem 11","2985934433","Argentino");

#modelos avion
INSERT INTO modelos_avion VALUES ("777","Boeing",2,100);
INSERT INTO modelos_avion VALUES ("333","Chevrolet",3,150);
INSERT INTO modelos_avion VALUES ("A320","Airbus",4,200);

#empleados
INSERT INTO empleados VALUES (1,"DNI",40101010,"empleado1","Gomez","Mario","12 de Octubre 1010","291444444");
INSERT INTO empleados VALUES (2,"DNI",20202020,"empleado2","Paez","Lautaro","Alsina 10","2974876333");
INSERT INTO empleados VALUES (3,"DNI",40404040,"empleado3","Toledo","Pepe","Rivadavia 11","291345543");

#aeropuertos
INSERT INTO aeropuertos VALUES("BB1010","Julio Cesar","20009873423","Pje Esperanza 20","Argentina","Buenos Aires","Bahia Blanca");
INSERT INTO aeropuertos VALUES("BA2020","Diocresiano","21109873423","Pje Fe 20","Argentina","Buenos Aires","Buenos Aires");

#vuelos programados
INSERT INTO vuelos_programados VALUES("3000","BB1010","BA2020");
INSERT INTO vuelos_programados VALUES("4000","BA2020","BB1010");

#salidas
INSERT INTO salidas VALUES ("3000","Do","14:00","18:00","777"); 
INSERT INTO salidas VALUES ("4000","Sa","13:00","17:00","333"); 
INSERT INTO salidas VALUES ("3000","Lu","00:00","04:00","777");

#instancias vuelos
INSERT INTO instancias_vuelo VALUES("3000","2019:09:15","Do","Demorado");
INSERT INTO instancias_vuelo VALUES("4000","2019:09:14","Sa","Demorado");
INSERT INTO instancias_vuelo VALUES("3000","2019:09:16","Lu","En Horario");
INSERT INTO instancias_vuelo VALUES("4000","2019:09:21","Sa","Demorado");

#reservas
INSERT INTO reservas VALUES(1000,"2019:09:15","2019:09:22","Activa","DNI",41386475,1);
INSERT INTO reservas VALUES(1001,"2019:09:15","2019:09:22","Activa","DNI",40777475,1);
INSERT INTO reservas VALUES(1002,"2019:09:16","2019:09:23","Activa","DNI",12386999,2);
INSERT INTO reservas VALUES(1003,"2019:09:16","2019:09:23","Activa","DNI",40888475,2);
INSERT INTO reservas VALUES(1004,"2019:09:16","2019:09:23","Activa","DNI",12386999,3);
INSERT INTO reservas VALUES(1005,"2019:09:16","2019:09:23","Activa","DNI",11386475,3);

#brinda
INSERT INTO brinda VALUES("3000","Do","Premium",01000.00,30);
INSERT INTO brinda VALUES("3000","Do","Turista",00200.00,50);
INSERT INTO brinda VALUES("3000","Do","Low Cost",00100.00,50);
INSERT INTO brinda VALUES("3000","Lu","Premium",00200.00,30);
INSERT INTO brinda VALUES("3000","Lu","Turista",00200.00,50);
INSERT INTO brinda VALUES("3000","Lu","Low Cost",00200.00,50);
INSERT INTO brinda VALUES("4000","Sa","Premium",10000.00,70);

#posee
INSERT INTO posee VALUES("Low Cost",10);
INSERT INTO posee VALUES("Turista",10);
INSERT INTO posee VALUES("Turista",20);
INSERT INTO posee VALUES("Premium",10);
INSERT INTO posee VALUES("Premium",20);
INSERT INTO posee VALUES("Premium",30);

#reserva_vuelo_clase
INSERT INTO reserva_vuelo_clase VALUES(1000,"3000","2019:09:15","Turista");
INSERT INTO reserva_vuelo_clase VALUES(1001,"4000","2019:09:14","Premium");
INSERT INTO reserva_vuelo_clase VALUES(1002,"4000","2019:09:14","Premium");
INSERT INTO reserva_vuelo_clase VALUES(1003,"3000","2019:09:16","Low Cost");
INSERT INTO reserva_vuelo_clase VALUES(1005,"4000","2019:09:21","Premium");

