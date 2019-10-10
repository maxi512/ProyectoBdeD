package baseProyecto;

import java.awt.Dimension;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JPasswordField;
import javax.swing.JLabel;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.awt.event.ActionEvent;
import java.awt.Font;

@SuppressWarnings("serial")
public class InicioEmpleado extends javax.swing.JInternalFrame {

	private VentanaInfoVuelos ventana;
	private JTextField textField;
	private JPasswordField passwordField;
	protected Connection conexionBD = null;

	/**
	 * Create the application.
	 */
	public InicioEmpleado(VentanaInfoVuelos ventana) {
		initialize();
		this.ventana = ventana;

	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		setPreferredSize(new Dimension(1100, 600));
		this.setBounds(0, 0, 800, 600);
		setVisible(true);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		JPanel panel = new JPanel();
		panel.setBounds(0, -27, 800, 600);
		getContentPane().add(panel);
		panel.setLayout(null);

		textField = new JTextField();
		textField.setFont(new Font("Dialog", Font.PLAIN, 14));
		textField.setBounds(473, 128, 124, 19);
		panel.add(textField);
		textField.setColumns(10);

		passwordField = new JPasswordField();
		passwordField.setFont(new Font("Dialog", Font.PLAIN, 14));
		passwordField.setBounds(473, 224, 124, 19);
		panel.add(passwordField);

		JLabel lblUser = new JLabel("Nro de legajo:");
		lblUser.setFont(new Font("Dialog", Font.BOLD, 14));
		lblUser.setBounds(193, 130, 124, 15);
		panel.add(lblUser);

		JLabel lblPassword = new JLabel("Password");
		lblPassword.setFont(new Font("Dialog", Font.BOLD, 14));
		lblPassword.setBounds(193, 226, 101, 15);
		panel.add(lblPassword);

		JButton btnLogearse = new JButton("Logearse");
		btnLogearse.setFont(new Font("Dialog", Font.BOLD, 14));
		btnLogearse.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent arg0) {

				char[] arrayC = passwordField.getPassword();
				String pass = new String(arrayC);

				String legajo = textField.getText();

				Connection conexionBD = null;

				try {

					// se genera el string que define los datos de la conexi�n
					String servidor = "localhost:3306";
					String baseDatos = "vuelos";
					String usuario = "admin";
					String clave = "admin";
					String uriConexion = "jdbc:mysql://" + servidor + "/" + baseDatos
							+ "?serverTimezone=America/Argentina/Buenos_Aires";
					// se intenta establecer la conexi�n
					conexionBD = DriverManager.getConnection(uriConexion, usuario, clave);

				} catch (SQLException ex) {
					String mensaje = "SQLException: " + ex.getMessage() + "\n" + "SQLState: " + ex.getSQLState() + "\n"
							+ "VendorError: " + ex.getErrorCode();

					mostrarMensajeError(mensaje);
				}

				try {
					Statement stmt = conexionBD.createStatement();

					try {
						int legajoNumerico = Integer.parseInt(legajo);

						String sql = "SELECT legajo, password FROM usuarios having legajo = " + legajoNumerico
								+ " and password = md5('" + pass + "');";

						ResultSet resultado = stmt.executeQuery(sql);

						int cantFilas = 0;

						if (resultado.last())
							cantFilas = resultado.getRow();

						if (cantFilas == 1) {
							activarConsultasEmpleado();
						} else {
							mostrarUsuarioIncorrecto();
						}

					} catch (NumberFormatException e) {
						mostrarLegajoNoNumerico();
					}

				} catch (SQLException e) {
					mostrarMensajeError(e.getMessage());
				}

			}
		});
		btnLogearse.setBounds(308, 335, 134, 35);
		panel.add(btnLogearse);

		pack();

	}
	
	/**
	 * Muestra mensaje de error relacionado al ingreso incorrecto del usuario
	 */
	void mostrarUsuarioIncorrecto() {
		JOptionPane.showMessageDialog(this, "Se produjo un error al intentar conectarse a la base de datos.\n"
				+ "Usuario y/o contraseña incorrecto.", "Error", JOptionPane.ERROR_MESSAGE);
	}
	
	/**
	 * Muestra mensaje de error al ingresar un numero de legajo no numerico
	 */
	void mostrarLegajoNoNumerico() {
		JOptionPane.showMessageDialog(this, "Se produjo un error al intentar conectarse a la base de datos.\n"
				+ "Por favor, ingrese numero de legajo correctamente.", "Error", JOptionPane.ERROR_MESSAGE);
	}
	
	/**
	 * Muestra un mensaje de error previamente creado
	 * @param msg Mensaje a mostrar
	 */
	void mostrarMensajeError(String msg) {
		JOptionPane.showMessageDialog(this, msg, "Error", JOptionPane.ERROR_MESSAGE);
	}
	
	/**
	 * Cierra la conexion con el servidor
	 */
	void cerrarConexion() {
		if (conexionBD != null) {
			try {
				conexionBD.close();
				conexionBD = null;
			} catch (SQLException ex) {
				String mensaje = "SQLException: " + ex.getMessage() + "\n" + "SQLState: " + ex.getSQLState() + "\n"
						+ "VendorError: " + ex.getErrorCode();

				mostrarMensajeError(mensaje);
			}
		}
	}
	
	/**
	 * Muestra la ventana de consultas para el empleado
	 */
	private void activarConsultasEmpleado() {
		this.setVisible(false);
		this.ventana.setVisible(true);
	}
}
