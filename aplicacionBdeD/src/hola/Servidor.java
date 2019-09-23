package hola;

import java.sql.*;

public class Servidor {
	
	

	private String servidor = "localhost:3306";
	private String baseDeDatos = "vuelos";
	private String usuario;
	private String clave;
	
	public Servidor() {
		
	}
	
	public java.sql.Connection establecerConexion(String user, String clave) throws java.sql.SQLException {
		this.clave = clave;
		this.usuario = user;
		
		
		String url = "jdbc:mysql://" + servidor + "/" + baseDeDatos + "?serverTimezone=America/Argentina/Buenos_Aires";
		
		java.sql.Connection cnx = java.sql.DriverManager.getConnection(url, usuario, clave);
		
		return cnx;

	}
}
