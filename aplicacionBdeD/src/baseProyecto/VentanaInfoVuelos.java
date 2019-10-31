package baseProyecto;

import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.ButtonGroup;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.WindowConstants;
import javax.swing.text.MaskFormatter;

import quick.dbtable.DBTable;

import java.text.ParseException;
import javax.swing.JButton;
import javax.swing.JLabel;

public class VentanaInfoVuelos extends javax.swing.JInternalFrame {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JRadioButton rdbtnIda;
	private JRadioButton rdbtnIdayVuelta;
	private JFormattedTextField txtFechaIda, txtFechaVuelta;
	private ButtonGroup group;
	private boolean seleccionVueloIda = false;
	private DBTable tabla, tablaInfoVuelo;
	private JList listOrigen, listDestino;
	protected Connection conexionBD = null;
	private int legajoEmpleado;
	private String passEmpleado;
	protected int seleccionadoOrigen = -1;
	protected int seleccionadoDestino = -1;
	
	private String numeroIda, claseIda;
	private JButton btnBuscarVuelos = new JButton("Buscar vuelos");
	private JButton btnReserva = new JButton("Realizar Reserva");

	/**
	 * Create the application.
	 */
	public VentanaInfoVuelos() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {

		setPreferredSize(new Dimension(1100, 600));
		this.setBounds(0, 0, 800, 600);
		setVisible(true);
		this.setClosable(true);
		this.setDefaultCloseOperation(WindowConstants.HIDE_ON_CLOSE);

		JPanel panel = new JPanel();
		panel.setBounds(0, -27, 800, 600);
		getContentPane().add(panel);
		panel.setLayout(null);

		group = new ButtonGroup();

		rdbtnIda = new JRadioButton("Solo Ida");
		rdbtnIda.setSelected(true);
		rdbtnIda.setBounds(804, 91, 144, 23);
		panel.add(rdbtnIda);

		rdbtnIdayVuelta = new JRadioButton("Ida y vuelta");
		rdbtnIdayVuelta.setBounds(804, 137, 144, 23);
		panel.add(rdbtnIdayVuelta);

		group.add(rdbtnIda);
		group.add(rdbtnIdayVuelta);

		try {
			txtFechaIda = new JFormattedTextField(new MaskFormatter("##'/##'/####"));
			txtFechaIda.setLocation(625, 91);
			txtFechaIda.setSize(90, 24);

			txtFechaVuelta = new JFormattedTextField(new MaskFormatter("##'/##'/####"));
			txtFechaVuelta.setLocation(625, 144);
			txtFechaVuelta.setSize(90, 24);
			txtFechaVuelta.setEditable(false);

			panel.add(txtFechaIda);
			panel.add(txtFechaVuelta);

		} catch (ParseException e) {
			mostrarMensajeError(e.getMessage());
		}

		rdbtnIda.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				txtFechaVuelta.setText("");
				txtFechaVuelta.setEditable(false);

			}
		});

		rdbtnIdayVuelta.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				txtFechaVuelta.setEditable(true);

			}
		});

		conectarBD();

		ResultSet rs = null;

		try {

			Statement stmt = this.conexionBD.createStatement();
			String sql = "Select ciudad from aeropuertos;";
			rs = stmt.executeQuery(sql);

		} catch (SQLException e) {
			mostrarMensajeError(e.getMessage());
		}

		String ciudades[] = obtenerContenidoFilas(rs);

		listOrigen = new JList(ciudades);
		listOrigen.setBounds(31, 79, 157, 149);
		panel.add(listOrigen);

		listDestino = new JList(ciudades);
		listDestino.setBounds(247, 79, 157, 149);
		panel.add(listDestino);

		// inizializo tabla

		tabla = new DBTable();
		tablaInfoVuelo = new DBTable();
		tabla.setVisible(false);
		tablaInfoVuelo.setVisible(false);

		tabla.setToolTipText("Doble-click o Espacio para seleccionar el registro.");
		tabla.addKeyListener(new KeyAdapter() {
			public void keyTyped(KeyEvent evt) {
				tablaKeyTyped(evt);
			}
		});

		tabla.addMouseListener(new MouseAdapter() {
			public void mouseClicked(MouseEvent evt) {
				tablaMouseClicked(evt);
			}
		});
		
		tablaInfoVuelo.addMouseListener(new MouseAdapter() {

			
			@Override
			public void mouseClicked(MouseEvent e) {
				actionTablaInfoVuelo();
				
			}
		});

		// setea la tabla solo para lectura, no se puede editar su contenido
		tabla.setEditable(false);
		tablaInfoVuelo.setEditable(false);
		tabla.setBounds(31, 278, 614, 261);
		tablaInfoVuelo.setBounds(670, 278, 390, 261);

		panel.add(tabla);
		panel.add(tablaInfoVuelo);
		pack();

		btnBuscarVuelos.setBounds(744, 197, 171, 31);
		panel.add(btnBuscarVuelos);

		btnReserva.setBounds(945, 91, 70, 70);
		
		btnReserva.setEnabled(false);

		btnReserva.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				accionBotonReserva();
				tablaInfoVuelo.setVisible(false);
			}
		});
		panel.add(btnReserva);

		JLabel lblFechaIda = new JLabel("Fecha Ida");
		lblFechaIda.setBounds(474, 95, 80, 15);
		panel.add(lblFechaIda);

		JLabel lblFechaVuelta = new JLabel("Fecha Vuelta");
		lblFechaVuelta.setBounds(474, 148, 111, 15);
		panel.add(lblFechaVuelta);

		JLabel lblCiudadOrigen = new JLabel("Ciudad origen");
		lblCiudadOrigen.setBounds(31, 37, 132, 15);
		panel.add(lblCiudadOrigen);

		JLabel lblCiudadDestinoi = new JLabel("Ciudad destino");
		lblCiudadDestinoi.setBounds(247, 37, 132, 15);
		panel.add(lblCiudadDestinoi);

		btnBuscarVuelos.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				if (verificarDatos()) {
					refrescar();
					tabla.setVisible(true);
					tablaInfoVuelo.setVisible(false);
					btnReserva.setEnabled(false);

				}
			}
		});

	}

	/**
	 * Realiza la coneccion con la base de datos Vuelos
	 */
	private void conectarBD() {
		if (this.conexionBD == null) {
			try {
				// se genera el string que define los datos de la conexi�n
				String servidor = "localhost:3306";
				String baseDatos = "vuelos";
				String usuario = "admin";
				String clave = "admin";
				String uriConexion = "jdbc:mysql://" + servidor + "/" + baseDatos
						+ "?serverTimezone=America/Argentina/Buenos_Aires";
				// se intenta establecer la conexi�n
				this.conexionBD = DriverManager.getConnection(uriConexion, usuario, clave);
			} catch (SQLException ex) {
				String msg = "SQLException: " + ex.getMessage() + "\n" + "SQLState: " + ex.getSQLState() + "\n"
						+ "VendorError: " + ex.getErrorCode();

				mostrarMensajeError(msg);
			}
		}
	}

	/**
	 * Dado un resultSet, devuelve
	 * 
	 * @param tabla
	 * @return
	 */
	private String[] obtenerContenidoFilas(ResultSet tabla) {
		String nombres[] = null;
		int cantFilas = 0, i = 0;
		try {
			if (tabla.last()) { // Nos posicionamos al final
				cantFilas = tabla.getRow(); // sacamos la cantidad de filas
				tabla.beforeFirst(); // nos posicionamos antes del inicio (como viene por defecto)
			}
			nombres = new String[cantFilas];
			while (tabla.next()) {
				nombres[i] = tabla.getString(1);
				i++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return nombres;
	}
	

	private void tablaMouseClicked(MouseEvent evt) {
		if ((this.tabla.getSelectedRow() != -1) && (evt.getClickCount() == 2)) {
			this.seleccionarFila();
		}
	}

	private void tablaKeyTyped(KeyEvent evt) {
		if ((this.tabla.getSelectedRow() != -1) && (evt.getKeyChar() == ' ')) {
			this.seleccionarFila();
		}
	}

	/**
	 * Accion a realizar cuando se selecciona una fila (Refresca Tabla)
	 */
	private void seleccionarFila() {
		refrescarInfoVuelo();
		tablaInfoVuelo.setVisible(true);
	}

	/**
	 * inicializo los index de las listas
	 */
	private void inicializarCampos() {
		this.seleccionadoOrigen = -1;
		this.seleccionadoDestino = -1;

	}

	/**
	 * Refresca los datos de la tabla de clases
	 */
	private void refrescarInfoVuelo() {
		try {
			int seleccionado = this.tabla.getSelectedRow();

			String numero = this.tabla.getValueAt(seleccionado, 1).toString();

			// Asumimos que no van a existir salidas a la misma hora el mismo dia en
			// simultaneo
			java.sql.Time hora = (java.sql.Time) this.tabla.getValueAt(seleccionado, 4);

			java.sql.Date fecha = (Date) this.tabla.getValueAt(seleccionado, 0);

			Statement stmt = this.conexionBD.createStatement();

			String sql = "SELECT vuelo Vuelo, clase Clase, asientos_disponibles Disponibles, precio Precio "
					+ "FROM vuelos_disponibles " + "WHERE vuelo = \"" + numero + "\" AND fecha = \"" + fecha
					+ "\" AND hora_sale = \"" + hora + "\";";

			ResultSet rs = stmt.executeQuery(sql);

			tablaInfoVuelo.refresh(rs);

			tablaInfoVuelo.getColumn(0).setMaxWidth(50);

			tablaInfoVuelo.getColumn(3).setMinWidth(90);

			tablaInfoVuelo.getColumn(1).setMaxWidth(120);

			rs.close();
			stmt.close();
			
			btnReserva.setEnabled(true);
		} catch (SQLException ex) {
			String msg = "SQLException: " + ex.getMessage() + "\n" + "SQLState: " + ex.getSQLState() + "\n"
					+ "VendorError: " + ex.getErrorCode();

			mostrarMensajeError(msg);
		}

	}

	/**
	 * Refresca los datos de la tabla de vuelos
	 */
	private void refrescar() {
		try {
			Statement stmt = this.conexionBD.createStatement();
			String ciudadOrigen = (String) listOrigen.getSelectedValue();
			String ciudadDestino = (String) listDestino.getSelectedValue();

			java.sql.Date fechaIda = Fechas.convertirStringADateSQL(this.txtFechaIda.getText().trim());
			java.sql.Date fechaVuelta = null;

			String sql = "SELECT DISTINCT fecha as Fecha, vuelo as 'Numero Vuelo',ciudad_salida as 'Ciudad Salida',nombre_salida as 'Aeropuerto Salida', hora_sale as 'Hora Salida',"
					+ "ciudad_llegada as 'Ciudad Llegada', nombre_llegada as 'Aeropuerto Llegada', hora_llega as 'Hora Llegada', modelo_avion as 'Modelo de avion', Diferencia as 'Tiempo Estimado' "
					+ "FROM vuelos_disponibles ";

			String wheresql;

			if (rdbtnIdayVuelta.isSelected()) {
				fechaVuelta = Fechas.convertirStringADateSQL(this.txtFechaVuelta.getText().trim());
				wheresql = "WHERE (ciudad_salida = \"" + ciudadOrigen + "\" AND ciudad_llegada = \"" + ciudadDestino
						+ "\" AND " + "fecha = \"" + fechaIda + "\") OR " + "(ciudad_salida = \"" + ciudadDestino
						+ "\" AND ciudad_llegada = \"" + ciudadOrigen + "\" AND " + "fecha = \"" + fechaVuelta + "\");";
			} else {
				wheresql = "WHERE ciudad_salida = \"" + ciudadOrigen + "\" AND ciudad_llegada = \"" + ciudadDestino
						+ "\" AND fecha = \"" + fechaIda + "\";";
			}

			sql += wheresql;

			ResultSet rs = stmt.executeQuery(sql);

			// actualiza el contenido de la tabla con los datos del resulset rs
			tabla.refresh(rs);

			// setea el formato de visualizacion de las columnas "Hora Salida", "Hora
			// Llegada" y "Tiempo Estimado" a Hora:Minuto
			tabla.getColumnByDatabaseName("Hora Salida").setDateFormat("HH:mm");

			tabla.getColumnByDatabaseName("Hora Llegada").setDateFormat("HH:mm");

			tabla.getColumnByDatabaseName("Tiempo Estimado").setDateFormat("HH:mm");
			tabla.getColumnByDatabaseName("Tiempo Estimado").setMinWidth(150);

			tabla.getColumnByDatabaseName("Fecha").setDateFormat("dd/MM/YYYY");
			tabla.getColumnByDatabaseName("Fecha").setMinWidth(80);

			rs.close();
			stmt.close();
		} catch (SQLException ex) {

			String msg = "SQLException: " + ex.getMessage() + "\n" + "SQLState: " + ex.getSQLState() + "\n"
					+ "VendorError: " + ex.getErrorCode();

			mostrarMensajeError(msg);

		}

		this.inicializarCampos();
	}

	/**
	 * Realiza validaciones sobre los datos ingresados por el usuario
	 * 
	 * @return True si los datos son correctos, falso en caso contrario
	 */
	private boolean verificarDatos() {
		boolean valido = true;
		String mensajeError = null;
		if (this.txtFechaIda.getText().isEmpty()) {
			mensajeError = " Debe ingresar un valor para el campo 'Fecha Ida' ";
			valido = false;
		} else {
			if (!Fechas.validar(this.txtFechaIda.getText().trim())) {
				mensajeError = "En el campo 'Fecha Ida' debe ingresar un valor con el formato dd/mm/aaaa.";
				txtFechaIda.setText("");
				valido = false;
			}
		}
		if (valido && rdbtnIdayVuelta.isSelected()) {
			if (this.txtFechaVuelta.getText().isEmpty()) {
				mensajeError = " Debe ingresar un valor para el campo 'Fecha Vuelta' ";
				valido = false;
			} else {
				if (!Fechas.validar(this.txtFechaVuelta.getText().trim())) {
					mensajeError = "En el campo 'Fecha Vuelta' debe ingresar un valor con el formato dd/mm/aaaa.";
					txtFechaVuelta.setText("");
					;
					valido = false;
				} else {

					boolean mayor = fechaMayor(this.txtFechaIda.getText().trim(), this.txtFechaVuelta.getText().trim());
					if (mayor) {
						valido = false;
						mensajeError = "La Fecha de Vuelta debe ser posterior a la Fecha de Ida";
						txtFechaVuelta.setText("");
						txtFechaIda.setText("");
					}
				}

			}

		}

		if (mensajeError != null) {
			mostrarMensajeError(mensajeError);
		}

		return valido;
	}

	/**
	 * Retorna verdadero si fechaIda es mayor que fechaVuelta
	 * 
	 * @param fechaIda    Fecha de ida a verificar
	 * @param fechaVuelta Fecha de Vuelta a verificar
	 * @return True si fechaIda es mayor que fechaVuelta, Falso en caso contrario
	 */
	private boolean fechaMayor(String fechaIda, String fechaVuelta) {
		boolean mayor = false;

		java.sql.Date fVuelta = Fechas.convertirStringADateSQL(fechaVuelta);
		java.sql.Date fIda = Fechas.convertirStringADateSQL(fechaIda);

		try {
			Statement stmt = this.conexionBD.createStatement();
			String sql = "SELECT DATEDIFF(\"" + fVuelta + "\",\"" + fIda + "\");";

			ResultSet resultado = stmt.executeQuery(sql);
			resultado.first();

			int diferencia = resultado.getInt(1);
			mayor = diferencia < 0;

			resultado.close();
			stmt.close();
		} catch (SQLException ex) {
			String msg = "SQLException: " + ex.getMessage() + "\n" + "SQLState: " + ex.getSQLState() + "\n"
					+ "VendorError: " + ex.getErrorCode();

			mostrarMensajeError(msg);
		}
		return mayor;
	}
	
	private void accionBotonReserva() {
		/**
		 * obtener datos ingresar datos
		 */

		// SOLO IDA
		if (rdbtnIda.isSelected()) {
			int vueloSeleccionado = this.tabla.getSelectedRow();
			int claseSeleccionada = this.tablaInfoVuelo.getSelectedRow();
			
			java.sql.Date fechaIda = Fechas.convertirStringADateSQL(this.txtFechaIda.getText().trim());

			String numero = this.tabla.getValueAt(vueloSeleccionado, 1).toString();
			String clase = this.tablaInfoVuelo.getValueAt(claseSeleccionada, 1).toString();
			IngresoDocumento in = new IngresoDocumento(numero,txtFechaIda.getText(), clase, Integer.toString(legajoEmpleado));
			in.setVisible(true);
			
		}
		else {
			/*
			 * verificar vuelo
			 * mostrar cartel
			 * verificar
			 * pasar info
			 */
			
			if(!seleccionVueloIda) {
				int vueloSeleccionado = this.tabla.getSelectedRow();
				String ciudadSeleccionada = this.tabla.getValueAt(vueloSeleccionado, 2).toString();
				
				if(ciudadSeleccionada.equals(listOrigen.getSelectedValue().toString())) {
					int claseSeleccionada = this.tablaInfoVuelo.getSelectedRow();

					String numero = this.tabla.getValueAt(vueloSeleccionado, 1).toString();
					String clase = this.tablaInfoVuelo.getValueAt(claseSeleccionada, 1).toString();
					
					this.numeroIda = numero;
					this.claseIda = clase;
					
					JOptionPane.showMessageDialog(this, "Selecciono el vuelo de ida, por favor seleccione el vuelo de vuelta"
							+ "", "Info", JOptionPane.INFORMATION_MESSAGE);
					
					this.seleccionVueloIda = true;
					
					listDestino.setEnabled(false);
					listOrigen.setEnabled(false);
					
					txtFechaIda.setEnabled(false);
					txtFechaVuelta.setEnabled(false);
					
					btnBuscarVuelos.setEnabled(false);
					
					rdbtnIda.setEnabled(false);
					rdbtnIdayVuelta.setEnabled(false);
					
				}
				
				else {
					mostrarMensajeError("Por favor seleccione primero el vuelo de ida.");
				}
			}
			else {
				int vueloSeleccionado = this.tabla.getSelectedRow();
				String ciudadSeleccionada = this.tabla.getValueAt(vueloSeleccionado, 2).toString();
				if(ciudadSeleccionada.equals(listDestino.getSelectedValue().toString())) {
					
					int claseSeleccionada = this.tablaInfoVuelo.getSelectedRow();

					String numero = this.tabla.getValueAt(vueloSeleccionado, 1).toString();
					String clase = this.tablaInfoVuelo.getValueAt(claseSeleccionada, 1).toString();
					
					IngresoDocumento in = new IngresoDocumento(numeroIda,numero,txtFechaIda.getText(),
							txtFechaVuelta.getText(),claseIda,clase,Integer.toString(legajoEmpleado));
					
					
					in.setVisible(true);
					
					listDestino.setEnabled(true);
					listOrigen.setEnabled(true);
					
					txtFechaIda.setEnabled(true);
					txtFechaVuelta.setEnabled(true);
					
					btnBuscarVuelos.setEnabled(true);
					
					btnReserva.setEnabled(false);
					
					rdbtnIda.setEnabled(true);
					rdbtnIdayVuelta.setEnabled(true);
					
					this.seleccionVueloIda = false;
					
				}
				
				else {
					mostrarMensajeError("Por favor seleccione el vuelo de vuelta.");
				}
			}
			
			
		}
		
		

	}

	/**
	 * Muestra un mensaje de error
	 * 
	 * @param msg Mensaje a mostrar
	 */
	void mostrarMensajeError(String msg) {
		JOptionPane.showMessageDialog(this, msg, "Error", JOptionPane.ERROR_MESSAGE);
	}
	
	void setInfoEmpleado(int legajo, String pass) {
		this.legajoEmpleado = legajo;
		this.passEmpleado = pass;
	}
	

	private void actionTablaInfoVuelo() {
		//Activar boton
		
	}

}
