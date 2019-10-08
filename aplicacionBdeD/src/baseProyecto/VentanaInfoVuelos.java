package baseProyecto;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.ButtonGroup;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JRadioButton;
import javax.swing.text.MaskFormatter;

import quick.dbtable.DBTable;

import java.text.ParseException;
import javax.swing.JButton;
import javax.swing.JLabel;

public class VentanaInfoVuelos extends JFrame {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JRadioButton rdbtnIda;
	private JRadioButton rdbtnIdayVuelta;
	private JFormattedTextField txtFechaIda, txtFechaVuelta;
	private ButtonGroup group;
	private DBTable tabla;
	private JList listOrigen, listDestino;
	protected Connection conexionBD = null;
	protected int seleccionadoOrigen = -1;
	protected int seleccionadoDestino = -1;

	private JFrame frame;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					VentanaInfoVuelos window = new VentanaInfoVuelos();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

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
		frame = new JFrame();
		frame.setBounds(100, 100, 800, 600);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);

		group = new ButtonGroup();

		rdbtnIda = new JRadioButton("Solo Ida");
		rdbtnIda.setSelected(true);
		rdbtnIda.setBounds(514, 33, 144, 23);
		frame.getContentPane().add(rdbtnIda);

		rdbtnIdayVuelta = new JRadioButton("Ida y vuelta");
		rdbtnIdayVuelta.setBounds(514, 60, 144, 23);
		frame.getContentPane().add(rdbtnIdayVuelta);

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

			frame.getContentPane().add(txtFechaIda);
			frame.getContentPane().add(txtFechaVuelta);

		} catch (ParseException e) {
			e.printStackTrace();
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
			e.printStackTrace();
		}

		String ciudades[] = obtenerContenidoFilas(rs);

		listOrigen = new JList(ciudades);
		listOrigen.setBounds(31, 79, 157, 149);
		frame.getContentPane().add(listOrigen);

		listDestino = new JList(ciudades);
		listDestino.setBounds(247, 79, 157, 149);
		frame.getContentPane().add(listDestino);

		// inizializo tabla

		tabla = new DBTable();

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

		// setea la tabla solo para lectura, no se puede editar su contenido
		tabla.setEditable(false);
		tabla.setBounds(45, 278, 714, 261);

		frame.getContentPane().add(tabla);
		pack();

		JButton btnBuscarVuelos = new JButton("Buscar vuelos");
		btnBuscarVuelos.setBounds(544, 197, 171, 31);
		frame.getContentPane().add(btnBuscarVuelos);
		
		JLabel lblFechaIda = new JLabel("Fecha Ida");
		lblFechaIda.setBounds(474, 95, 66, 15);
		frame.getContentPane().add(lblFechaIda);
		
		JLabel lblFechaVuelta = new JLabel("Fecha Vuelta");
		lblFechaVuelta.setBounds(474, 148, 111, 15);
		frame.getContentPane().add(lblFechaVuelta);
		
		JLabel lblCiudadOrigen = new JLabel("Ciudad origen");
		lblCiudadOrigen.setBounds(31, 37, 132, 15);
		frame.getContentPane().add(lblCiudadOrigen);
		
		JLabel lblCiudadDestinoi = new JLabel("Ciudad destino");
		lblCiudadDestinoi.setBounds(247, 37, 132, 15);
		frame.getContentPane().add(lblCiudadDestinoi);

		btnBuscarVuelos.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				if(verificarDatos()) {
					refrescar();
				}
			}
		});

	}

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
				JOptionPane.showMessageDialog(this,
						"Se produjo un error al intentar conectarse a la base de datos.\n" + ex.getMessage(), "Error",
						JOptionPane.ERROR_MESSAGE);
			}
		}
	}

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

	private void seleccionarFila() {
		// this.seleccionado = this.tabla.getSelectedRow();
		// this.txtNombre.setText(this.tabla.getValueAt(this.tabla.getSelectedRow(),
		// 0).toString());
		// this.txtFecha.setText(Fechas.convertirDateAString((java.util.Date)
		// this.tabla.getValueAt(this.tabla.getSelectedRow(), 1)));
	}

	private void inicializarCampos() {
		this.seleccionadoOrigen = -1;
		this.seleccionadoDestino = -1;

		this.txtFechaIda.setText("");
		this.txtFechaVuelta.setText("");

	}

	private void refrescar() {
		try {
			Statement stmt = this.conexionBD.createStatement();

			String sql = "select * \n"
					+ "from instancias_vuelo, vuelos_programados natural join(select codigo aeropuerto_salida, ciudad ciudad_salida\n"
					+ "from aeropuertos) salida natural join (\n"
					+ "select codigo aeropuerto_llegada, ciudad ciudad_llegada\n" + "from aeropuertos\n" + ") llegada\n"
					+ "where instancias_vuelo.vuelo = vuelos_programados.numero and ciudad_salida = '"
					+ (String) listOrigen.getSelectedValue()+"' and ciudad_llegada = '"+ (String) listDestino.getSelectedValue()+"';";

			ResultSet rs = stmt.executeQuery(sql);

			// actualiza el contenido de la tabla con los datos del resulset rs
			tabla.refresh(rs);

			// setea el formato de visualización de la columna "fecha" a dia/mes/año
			// tabla.getColumnByDatabaseName("fecha").setDateFormat("dd/MM/YYYY");

			tabla.getColumnByDatabaseName("fecha").setMinWidth(80);

			rs.close();
			stmt.close();
		} catch (SQLException ex) {
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		}

		this.inicializarCampos();
	}

	private boolean verificarDatos() {
		boolean valido=true;
		String mensajeError= null;
		if(this.txtFechaIda.getText().isEmpty()) {
			mensajeError=" Debe ingresar un valor para el campo 'Fecha Ida' ";
			valido= false;
		}
		else {
			if(! Fechas.validar(this.txtFechaIda.getText().trim())) {
				mensajeError = "En el campo 'Fecha Ida' debe ingresar un valor con el formato dd/mm/aaaa.";
				txtFechaIda.setText("");
				valido= false;
			}
		}
		if(valido && rdbtnIdayVuelta.isSelected()) {
			if(this.txtFechaVuelta.getText().isEmpty()) {
				mensajeError=" Debe ingresar un valor para el campo 'Fecha Vuelta' ";
				valido=false;
			}
			else {
				if(! Fechas.validar(this.txtFechaVuelta.getText().trim())) {
					mensajeError = "En el campo 'Fecha Vuelta' debe ingresar un valor con el formato dd/mm/aaaa.";
					txtFechaVuelta.setText("");;
					valido= false;
				}
				else {
					
					boolean mayor= fechaMayor(this.txtFechaIda.getText().trim(),this.txtFechaVuelta.getText().trim());
					if(mayor) {
						valido=false;
						mensajeError= "La Fecha de Vuelta debe ser posterior a la Fecha de Ida";
						txtFechaVuelta.setText("");
						txtFechaIda.setText("");
					}
				}
				
			}
				
		}
		
		if(mensajeError != null) {
			JOptionPane.showMessageDialog(this,
                    mensajeError,
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
		}
		
		return valido;
	}

	/**
	 *  Retorna verdadero si fechaIda es mayor que fechaVuelta
	 * @param fechaIda
	 * @param fechaVuelta
	 * @return
	 */
	private boolean fechaMayor(String fechaIda,String fechaVuelta) {
		boolean mayor=false;
		
		java.sql.Date fVuelta= Fechas.convertirStringADateSQL(fechaVuelta);
		java.sql.Date fIda= Fechas.convertirStringADateSQL(fechaIda);
		
		try {
			Statement stmt = this.conexionBD.createStatement();
			String sql = "SELECT DATEDIFF(\"" + fVuelta + "\",\"" + fIda + "\");";
			
			ResultSet resultado= stmt.executeQuery(sql);
			resultado.first();
			
			int diferencia= resultado.getInt(1);
			mayor = diferencia<0;
			
			resultado.close();
			stmt.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return mayor;
	}

}
