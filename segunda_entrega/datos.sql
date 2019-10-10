USE vuelos;

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
INSERT INTO empleados VALUES (1,"DNI",40101010,md5("empleado1"),"Gomez","Mario","12 de Octubre 1010","291444444");
INSERT INTO empleados VALUES (2,"DNI",20202020,md5("empleado2"),"Paez","Lautaro","Alsina 10","2974876333");
INSERT INTO empleados VALUES (3,"DNI",40404040,md5("empleado3"),"Toledo","Pepe","Rivadavia 11","291345543");

#aeropuertos
INSERT INTO aeropuertos VALUES("BB1010","Julio Cesar","20009873423","Pje Esperanza 20","Argentina","Buenos Aires","Bahia Blanca");
INSERT INTO aeropuertos VALUES("BA2020","Diocresiano","21109873423","Pje Fe 20","Argentina","Buenos Aires","Buenos Aires");

#vuelos programados
INSERT INTO vuelos_programados VALUES("3000","BB1010","BA2020");
INSERT INTO vuelos_programados VALUES("4000","BA2020","BB1010");

#salidas
INSERT INTO salidas VALUES ("3000","Ma","14:00","18:00","777"); 
INSERT INTO salidas VALUES ("4000","Lu","13:00","17:00","333"); 
INSERT INTO salidas VALUES ("3000","Mi","00:00","04:00","777");

#instancias vuelos
INSERT INTO instancias_vuelo VALUES("3000","2020:09:15","Ma","Demorado");
INSERT INTO instancias_vuelo VALUES("4000","2020:09:14","Lu","Demorado");
INSERT INTO instancias_vuelo VALUES("3000","2020:09:16","Mi","En Horario");
INSERT INTO instancias_vuelo VALUES("4000","2020:09:21","Lu","Demorado");

#reservas
INSERT INTO reservas VALUES(1000,"2020:09:15","2020:09:22","Activa","DNI",41386475,1);
INSERT INTO reservas VALUES(1001,"2020:09:15","2020:09:22","Activa","DNI",40777475,1);
INSERT INTO reservas VALUES(1002,"2020:09:16","2020:09:23","Activa","DNI",12386999,2);
INSERT INTO reservas VALUES(1003,"2020:09:16","2020:09:23","Activa","DNI",40888475,2);
INSERT INTO reservas VALUES(1004,"2020:09:16","2020:09:23","Activa","DNI",12386999,3);
INSERT INTO reservas VALUES(1005,"2020:09:16","2020:09:23","Activa","DNI",11386475,3);

#brinda
INSERT INTO brinda VALUES("3000","Ma","Premium",01000.00,30);
INSERT INTO brinda VALUES("3000","Ma","Turista",00200.00,50);
INSERT INTO brinda VALUES("3000","Ma","Low Cost",00100.00,50);
INSERT INTO brinda VALUES("3000","Mi","Premium",00200.00,30);
INSERT INTO brinda VALUES("3000","Mi","Turista",00200.00,50);
INSERT INTO brinda VALUES("3000","Mi","Low Cost",00200.00,50);
INSERT INTO brinda VALUES("4000","Lu","Premium",10000.00,70);

#posee
INSERT INTO posee VALUES("Low Cost",10);
INSERT INTO posee VALUES("Turista",10);
INSERT INTO posee VALUES("Turista",20);
INSERT INTO posee VALUES("Premium",10);
INSERT INTO posee VALUES("Premium",20);
INSERT INTO posee VALUES("Premium",30);

#reserva_vuelo_clase
INSERT INTO reserva_vuelo_clase VALUES(1000,"3000","2020:09:15","Turista");
INSERT INTO reserva_vuelo_clase VALUES(1001,"4000","2020:09:14","Premium");
INSERT INTO reserva_vuelo_clase VALUES(1002,"4000","2020:09:14","Premium");
INSERT INTO reserva_vuelo_clase VALUES(1003,"3000","2020:09:16","Low Cost");
INSERT INTO reserva_vuelo_clase VALUES(1005,"4000","2020:09:21","Premium");
