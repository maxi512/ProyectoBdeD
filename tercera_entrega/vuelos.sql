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


# CREACION DE TABLA NECESARIA PARA EL TERCER PROYECYO
CREATE TABLE asientos_reservados(

	vuelo VARCHAR(50) NOT NULL,
	fecha DATE NOT NULL,
	clase VARCHAR(50) NOT NULL,
	cantidad SMALLINT UNSIGNED NOT NULL,	
	
	CONSTRAINT pk_asientos_reservados
	PRIMARY KEY (vuelo,fecha,clase),
	
	CONSTRAINT FK_vuelo_fecha_Asientos_reservados
	FOREIGN KEY (vuelo,fecha) REFERENCES instancias_vuelo(vuelo,fecha),
	
	CONSTRAINT FK_clase_Asientos_reservados
	FOREIGN KEY (clase) REFERENCES clases(nombre)
	

) Engine = InnoDB;


# CREACION DE LA VISTA
CREATE VIEW vuelos_disponibles AS
SELECT	info_vuelo.vuelo,info_vuelo.fecha,info_vuelo.dia,info_vuelo.modelo_avion,info_vuelo.hora_sale,info_vuelo.hora_llega,info_vuelo.Diferencia,
		info_aeropuerto.codigo_salida,info_aeropuerto.nombre_salida,info_aeropuerto.ciudad_salida,info_aeropuerto.estado_salida,info_aeropuerto.pais_salida,
		info_aeropuerto.codigo_llegada,info_aeropuerto.nombre_llegada,info_aeropuerto.ciudad_llegada,info_aeropuerto.estado_llegada,info_aeropuerto.pais_llegada,
		info_disponibles.clase,info_disponibles.precio,info_disponibles.cant_asientos,info_disponibles.asientos_disponibles
		
FROM    (SELECT sal.vuelo,ins.fecha,ins.dia,sal.modelo_avion,sal.hora_sale,sal.hora_llega, if(timediff(sal.hora_llega,sal.hora_sale)<0,timediff(timediff(sal.hora_llega,sal.hora_sale),"-24:00"),timediff(sal.hora_llega,sal.hora_sale)) as 'Diferencia'
		 FROM salidas sal, instancias_vuelo ins 
		 WHERE sal.vuelo=ins.vuelo and sal.dia=ins.dia) AS info_vuelo,
		 
		(SELECT 	ins.vuelo,ins.fecha,ins.dia,
					a_salida.codigo codigo_salida,a_salida.nombre nombre_salida,a_salida.ciudad ciudad_salida,a_salida.pais pais_salida, a_salida.estado estado_salida,
					a_llegada.codigo codigo_llegada,a_llegada.nombre nombre_llegada,a_llegada.ciudad ciudad_llegada,a_llegada.pais pais_llegada, a_llegada.estado estado_llegada
		 FROM instancias_vuelo ins, vuelos_programados v, aeropuertos a_salida,aeropuertos a_llegada
		 WHERE ins.vuelo=v.numero and v.aeropuerto_salida= a_salida.codigo and v.aeropuerto_llegada=a_llegada.codigo) AS info_aeropuerto,
		
		(SELECT total_disponibles.vuelo,total_disponibles.fecha,total_disponibles.dia,total_disponibles.clase,precio,
				FLOOR(cant_asientos*(1+porcentaje)) AS cant_asientos,
				IFNULL( FLOOR(cant_asientos*(1+porcentaje)-vendidos) , FLOOR(cant_asientos*(1+porcentaje)) ) AS asientos_disponibles
		 FROM  (SELECT ins.vuelo,ins.fecha,ins.dia,b.clase,precio,cant_asientos,porcentaje
				 FROM instancias_vuelo ins, brinda b, clases c 
				 WHERE ins.vuelo=b.vuelo AND ins.dia=b.dia AND b.clase=c.nombre) total_disponibles 
				 
			LEFT JOIN
	 	
				(SELECT vuelo,fecha_vuelo,clase,count(clase) vendidos 
				 FROM reserva_vuelo_clase rvc
				 GROUP BY vuelo,fecha_vuelo,clase) total_vendidos 
				 
			ON total_disponibles.vuelo=total_vendidos.vuelo AND total_disponibles.fecha = total_vendidos.fecha_vuelo 
			   AND total_disponibles.clase=total_vendidos.clase) AS info_disponibles
			
WHERE	info_vuelo.vuelo=info_aeropuerto.vuelo AND info_aeropuerto.vuelo=info_disponibles.vuelo AND
		info_vuelo.fecha=info_aeropuerto.fecha AND info_aeropuerto.fecha=info_disponibles.fecha AND
		info_vuelo.dia=info_aeropuerto.dia AND info_aeropuerto.dia=info_disponibles.dia AND (info_vuelo.fecha > CURDATE());
 

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
GRANT SELECT, INSERT, UPDATE ON vuelos.reservas TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON vuelos.pasajeros TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON vuelos.reserva_vuelo_clase TO 'empleado'@'%';



#CREACION DE STORE PROCEDURE
delimiter !

#PROCEDURE PARA RESERVAR VIAJE DE IDA
#
CREATE PROCEDURE reservarVueloIda(IN numero VARCHAR(50), IN fecha DATE, IN clase VARCHAR(50), IN tipo_doc VARCHAR(50), IN nro_doc INT, IN legajoEmpleado INT)
BEGIN
	DECLARE estado_reserva VARCHAR(50);
	DECLARE cantidad_reservados SMALLINT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN # Si se produce una SQLEXCEPTION, se retrocede la transacción con ROLLBACK
			SELECT 'SQLEXCEPTION!, transacción abortada' AS resultado;
			ROLLBACK;
		END;
	START TRANSACTION;
		IF 	EXISTS (SELECT * FROM instancias_vuelo iv WHERE iv.vuelo = numero AND iv.fecha = fecha) AND 
			EXISTS (SELECT * FROM pasajeros WHERE doc_nro = nro_doc AND doc_tipo = tipo_doc) AND 
			EXISTS (SELECT * FROM empleados WHERE legajo = legajoEmpleado) AND 
			EXISTS (SELECT * FROM instancias_vuelo iv, brinda b WHERE iv.fecha = fecha AND iv.vuelo = numero AND iv.vuelo = b.vuelo AND iv.dia = b.dia AND b.clase = clase)
			THEN
				/*LOS DATOS INGRESADOS SON CORRECTOS*/
				SELECT cantidad INTO cantidad_reservados FROM asientos_reservados ar WHERE ar.vuelo=numero AND ar.fecha=fecha AND ar.clase=clase FOR UPDATE;
				IF EXISTS(SELECT * FROM vuelos_disponibles vd WHERE vd.vuelo=numero AND vd.fecha=fecha AND vd.clase=clase AND vd.asientos_disponibles>0) 
				THEN
					SELECT IF(cantidad_reservados<cant_asientos,'confirmada','en espera') INTO estado_reserva 
					FROM instancias_vuelo iv, brinda b 
					WHERE iv.fecha = fecha AND iv.vuelo = numero AND iv.vuelo = b.vuelo AND iv.dia = b.dia AND b.clase = clase;
					INSERT INTO reservas(fecha,vencimiento,estado,doc_tipo,doc_nro,legajo) VALUES (CURDATE(),DATE_SUB(fecha,INTERVAL 15 DAY),estado_reserva,tipo_doc,nro_doc,legajoEmpleado);
					INSERT INTO reserva_vuelo_clase VALUES (LAST_INSERT_ID(),numero,fecha,clase);
					UPDATE asientos_reservados ar SET cantidad= cantidad+1 WHERE ar.vuelo=numero AND ar.fecha=fecha AND ar.clase=clase;
					SELECT 'La reserva se realizo con exito' as resultado;
				ELSE
					SELECT 'No hay lugares disponibles en la clase del vuelo solicitada' as resultado;
				END IF;
		ELSE 
			/* INFORMO ALGUN ERROR*/
			SELECT 'Error: Los datos ingresados no son correctos' AS resultado;
		END IF;
	COMMIT;
END;!


#PROCEDURE PARA RESERVAR VIAJE DE IDA Y VUELTA
#
CREATE PROCEDURE reservarVueloIdaVuelta(IN numeroIda VARCHAR(50),IN numeroVuelta VARCHAR(50), IN fechaIda DATE,IN fechaVuelta DATE, IN claseIda VARCHAR(50),IN claseVuelta VARCHAR(50), IN tipo_doc VARCHAR(50), IN nro_doc INT, IN legajoEmpleado INT)
BEGIN
	DECLARE estado_reserva VARCHAR(50);
	DECLARE cantidad_reservados_ida SMALLINT;
	DECLARE cantidad_reservados_vuelta SMALLINT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN # Si se produce una SQLEXCEPTION, se retrocede la transacción con ROLLBACK
			SELECT 'SQLEXCEPTION!, transacción abortada' AS resultado;
			ROLLBACK;
		END;
	START TRANSACTION;
		# Controlo que los datos pasados como parametro existen en la base de datos.
		IF 	EXISTS (SELECT * FROM instancias_vuelo WHERE vuelo = numeroIda AND fecha = fechaIda) AND #Existe el vuelo de ida
			EXISTS (SELECT * FROM instancias_vuelo WHERE vuelo = numeroVuelta AND fecha = fechaVuelta) AND #Existe el vuelo de vuelta
			EXISTS (SELECT * FROM pasajeros WHERE doc_nro = nro_doc AND doc_tipo = tipo_doc) AND #Existe el pasajero
			EXISTS (SELECT * FROM empleados WHERE legajo = legajoEmpleado) AND  #Existe el empleado
			EXISTS (SELECT * FROM instancias_vuelo iv, brinda b WHERE iv.fecha = fechaIda AND iv.vuelo = numeroIda AND iv.vuelo = b.vuelo AND iv.dia = b.dia AND b.clase = claseIda) AND  #La clase de ida, es brindada por el vuelo en la fecha de ida
			EXISTS (SELECT * FROM instancias_vuelo iv, brinda b WHERE iv.fecha = fechaVuelta AND iv.vuelo = numeroVuelta AND iv.vuelo = b.vuelo AND iv.dia = b.dia AND b.clase = claseVuelta) #La clase de vuelta, es brindada por el vuelo en la fecha de vuelta
			THEN
				/*LOS DATOS INGRESADOS SON CORRECTOS*/
				SELECT cantidad INTO cantidad_reservados_ida FROM asientos_reservados WHERE vuelo=numeroIda AND fecha=fechaIda AND clase=claseIda FOR UPDATE;
				SELECT cantidad INTO cantidad_reservados_vuelta FROM asientos_reservados WHERE vuelo=numeroVuelta AND fecha=fechaVuelta AND clase=claseVuelta FOR UPDATE;
				
				IF EXISTS(SELECT * FROM vuelos_disponibles WHERE vuelo=numeroIda AND fecha=fechaIda AND clase=claseIda AND asientos_disponibles>0)   
				THEN
					IF EXISTS(SELECT * FROM vuelos_disponibles WHERE vuelo=numeroVuelta AND fecha=fechaVuelta AND clase=claseVuelta AND asientos_disponibles>0)
					THEN 
						SELECT IF(cantidad_reservados_ida<cant_asientos,'confirmada','en espera') INTO estado_reserva 
						FROM instancias_vuelo NATURAL JOIN brinda
						WHERE (vuelo = numeroIda) AND (fecha = fechaIda) AND (clase = claseIda);
					
						IF (estado_reserva <> 'en espera') 
						THEN 
							SELECT IF(cantidad_reservados_vuelta< cant_asientos,'confirmada','en espera') INTO estado_reserva 
							FROM instancias_vuelo NATURAL JOIN brinda 
							WHERE (vuelo = numeroVuelta) AND (fecha = fechaVuelta) AND (clase = claseVuelta);
						END IF;
						
						INSERT INTO reservas(fecha,vencimiento,estado,doc_tipo,doc_nro,legajo) VALUES (CURDATE(),DATE_SUB(fechaIda,INTERVAL 15 DAY),estado_reserva,tipo_doc,nro_doc,legajoEmpleado);
						
						INSERT INTO reserva_vuelo_clase VALUES (LAST_INSERT_ID(),numeroIda,fechaIda,claseIda);
						INSERT INTO reserva_vuelo_clase VALUES (LAST_INSERT_ID(),numeroVuelta,fechaVuelta,claseVuelta);
						
						UPDATE asientos_reservados SET cantidad= cantidad+1 WHERE vuelo=numeroIda AND fecha=fechaIda AND clase=claseIda;
						UPDATE asientos_reservados SET cantidad= cantidad+1 WHERE vuelo=numeroVuelta AND fecha=fechaVuelta AND clase=claseVuelta;
						
						SELECT 'La reserva se realizo con exito' as resultado;
					ELSE
						SELECT 'No hay lugares disponibles en la clase del vuelo solicitada para el vuelo de vuelta' as resultado;
					END IF;
				ELSE
					SELECT 'No hay lugares disponibles en la clase del vuelo solicitada para el vuelo de ida' as resultado;
				END IF;
		ELSE 
			/* INFORMO ALGUN ERROR*/
			SELECT 'Error: Los datos ingresados no son correctos' AS resultado;
		END IF;
	COMMIT;
END;!


#PUNTO 4 PROYECTO
# CARGA EN LA BASE DE DATOS LAS INSTANCIAS DE VUELO CORRESPONDIENTES A PARTIR DE LA FECHA ACTUAL
# HASTA EL 31 de DICIEMBRE.
#
CREATE TRIGGER actualizar_instancias_vuelo
AFTER INSERT ON salidas
FOR EACH ROW
BEGIN 
	DECLARE fecha_instancia DATE;
	DECLARE fecha_corte DATE;
	
	IF (DAYOFWEEK(CURDATE())> obtener_nro_dia(NEW.dia))
	THEN
		SELECT DATE_ADD(CURDATE(), INTERVAL ((7 - DAYOFWEEK(CURDATE()))+ obtener_nro_dia(NEW.dia)) DAY ) INTO fecha_instancia;
	ELSE
		SELECT DATE_ADD(CURDATE(), INTERVAL (obtener_nro_dia(NEW.dia) - DAYOFWEEK(CURDATE())) DAY ) INTO fecha_instancia;
	END IF;
	
	SELECT CONCAT(YEAR(CURDATE()),'-12-31') INTO fecha_corte;
	
	WHILE (fecha_instancia <= fecha_corte) DO
		INSERT INTO instancias_vuelo VALUES (NEW.vuelo,fecha_instancia,NEW.dia,'a tiempo');
		SELECT DATE_ADD(fecha_instancia, INTERVAL 7 DAY) INTO fecha_instancia;
	END WHILE;
END; !


# FUNCION PARA RETORNAR EL NUMERO DEL DIA PASADO COMO PARAMETRO 
#
CREATE FUNCTION obtener_nro_dia(dia VARCHAR(2)) RETURNS TINYINT
DETERMINISTIC
BEGIN
	CASE dia
		WHEN 'Do' THEN RETURN 1;
		WHEN 'Lu' THEN RETURN 2;
		WHEN 'Ma' THEN RETURN 3;
		WHEN 'Mi' THEN RETURN 4;
		WHEN 'Ju' THEN RETURN 5;
		WHEN 'Vi' THEN RETURN 6;
		WHEN 'Sa' THEN RETURN 7;
	END CASE; 	
 END; !

 
# Este TRIGGER se encarga de crear las filas correspondientes en la tabla asientos_reservados, asociadas a
# cada clase que brinda cada vuelo. Cuando se crea una fila en la clase brinda, se agrega la fila correspondiente
# a la tabla asientos_reservados, con cantidad=0
#
CREATE TRIGGER asientos_reservados_update
AFTER INSERT ON brinda
FOR EACH ROW 
BEGIN
	DECLARE fecha_vuelo DATE;
	DECLARE fin BOOLEAN DEFAULT false;
	#Declaro cursor para la consulta que devuelve las fechas de un vuelo en un dia determinado.
	DECLARE C CURSOR FOR SELECT fecha FROM instancias_vuelo iv WHERE NEW.vuelo= iv.vuelo AND NEW.dia=iv.dia GROUP BY fecha;
	#Declaro la operacion a realizar cuando el fetch no encuentre mas filas
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=true; 
	OPEN C;
	FETCH C INTO fecha_vuelo; #Recupero la primera fila del cursor
 	WHILE NOT fin DO
		#Inserto en la tabla asientos_reservados una fila con el vuelo, la fecha, la clase, y la cantidad de asientos reservados.
		INSERT INTO asientos_reservados VALUES (NEW.vuelo,fecha_vuelo,NEW.clase,0);
		FETCH C INTO fecha_vuelo; #Recupero la proxima fila
	END WHILE;
	CLOSE C;
	
END;!


 
delimiter ;
















