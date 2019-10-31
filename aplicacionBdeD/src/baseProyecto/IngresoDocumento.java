package baseProyecto;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;

import javax.swing.JButton;

public class IngresoDocumento extends JFrame {

	private static final long serialVersionUID = 1L;
	private JFrame frame;
	private String numeroIda, fechaIda, claseIda, legajo;
	private String numeroVuelta, fechaVuelta, claseVuelta;
	private JTextField tipoDoc;
	private JTextField nroDni;
	private boolean soloIda;
	private java.sql.Connection conexionBD;

	/**
	 * Create the application.
	 */
	public IngresoDocumento(String numero, String fecha, String clase, String legajo) {
		this.soloIda = true;
		this.numeroIda = numero;
		this.fechaIda = fecha;
		this.claseIda = clase;
		this.legajo = legajo;

		initialize();

		setDefaultCloseOperation(DISPOSE_ON_CLOSE);

	}

	public IngresoDocumento(String numeroIda, String numeroVuelta, String fechaIda, String fechaVuelta, String claseIda,
			String claseVuelta, String legajo) {

		this.numeroIda = numeroIda;
		this.fechaIda = fechaIda;
		this.claseIda = claseIda;
		this.numeroVuelta = numeroVuelta;
		this.fechaVuelta = fechaVuelta;
		this.claseVuelta = claseVuelta;
		this.legajo = legajo;

		initialize();

		setDefaultCloseOperation(DISPOSE_ON_CLOSE);

	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {

		frame = new JFrame();
		this.setBounds(300, 150, 450, 300);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.getContentPane().setLayout(null);

		JLabel lblTipoDe = new JLabel("Tipo de Documento");
		lblTipoDe.setBounds(69, 57, 152, 15);
		this.getContentPane().add(lblTipoDe);

		JLabel lblNroDeDocumento = new JLabel("Nro de Documento");
		lblNroDeDocumento.setBounds(69, 99, 152, 15);
		this.getContentPane().add(lblNroDeDocumento);

		tipoDoc = new JTextField();
		tipoDoc.setBounds(264, 55, 114, 19);
		this.getContentPane().add(tipoDoc);
		tipoDoc.setColumns(10);

		nroDni = new JTextField();
		nroDni.setBounds(264, 97, 114, 19);
		this.getContentPane().add(nroDni);
		nroDni.setColumns(10);

		JButton btnRealizarReserva = new JButton("Realizar Reserva");
		btnRealizarReserva.setBounds(142, 147, 167, 25);
		btnRealizarReserva.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				realizarReserva();
			}

		});
		this.getContentPane().add(btnRealizarReserva);

	}

	private void realizarReserva() {
		if (!(tipoDoc.getText().equals("")) && !(nroDni.getText().equals(""))) {
			conectarBD();
			try {
				Statement stmt = this.conexionBD.createStatement();
				java.sql.Date fechaIda = Fechas.convertirStringADateSQL(this.fechaIda.trim());
				String sql = "";

				if (soloIda)
					sql = "call reservarVueloIda('" + numeroIda + "', '" + fechaIda + "', '" + claseIda + "', '"
							+ tipoDoc.getText() + "', '" + nroDni.getText() + "', " + Integer.parseInt(legajo) + " );";

				else {
					java.sql.Date fechaVuelta = Fechas.convertirStringADateSQL(this.fechaVuelta.trim());
					sql = "call reservarVueloIdaVuelta('" + numeroIda + "', '" + numeroVuelta + "', '" + fechaIda + "', '"
							+ fechaVuelta + "', '" + claseIda + "', '" + claseVuelta + "', '" + tipoDoc.getText() + "', '"
							+ nroDni.getText() + "', " + Integer.parseInt(legajo) + " );";
				}

				System.out.println(sql);
				ResultSet st = stmt.executeQuery(sql);
				st.first();
				JOptionPane.showMessageDialog(this, st.getString(1), "Info", JOptionPane.OK_OPTION);
				this.setVisible(false);

			} catch (SQLException e) {
				mostrarMensajeError("No se pudo realizar la reserva\n" + e.getMessage());
			}

		} else {

		}

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
				String msg = "Se produjo un error al intentar conectarse a la base de datos.\n" + ex.getMessage();

				mostrarMensajeError(msg);

			}
		}
	}

	private void desconectarBD() {
		if (this.conexionBD != null) {
			try {
				this.conexionBD.close();
				this.conexionBD = null;
			} catch (SQLException ex) {
				String msg = "Se produjo un error al intentar desconectarse a la base de datos.\n" + ex.getMessage();
				mostrarMensajeError(msg);
			}
		}
	}

	void mostrarMensajeError(String msg) {
		JOptionPane.showMessageDialog(this, msg, "Error", JOptionPane.ERROR_MESSAGE);
	}
}
