package baseProyecto;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.border.BevelBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableModel;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@SuppressWarnings("serial")
public class VentanaConsultas extends javax.swing.JInternalFrame {

	private JLabel lblTituloTablas, lblTituloAtributos;

	private JPanel pnlConsulta;
	private JTextArea txtConsulta;
	private JButton botonBorrar;
	private JButton btnEjecutar;

	private JTable tabla;
	private JScrollPane scrTabla, scrConsulta;

	protected Connection conexionBD = null;

	private JPanel pnlTablas;
	private JList listaTablas, listaAtributos;
	private JScrollPane scrollTablas, scrollAtributos;

	public VentanaConsultas() {
		super();
		initGUI();

	}

	private void initGUI() {
		try {
			setPreferredSize(new Dimension(800, 600));
			this.setBounds(0, 0, 800, 600);
			setVisible(true);
			BorderLayout thisLayout = new BorderLayout();
			this.setTitle("Consultas Administrador");
			getContentPane().setLayout(thisLayout);
			this.setClosable(true);
			this.setDefaultCloseOperation(WindowConstants.HIDE_ON_CLOSE);
			this.setMaximizable(true);

			this.addComponentListener(new ComponentAdapter() {
				public void componentHidden(ComponentEvent evt) {
					thisComponentHidden(evt);
				}

				public void componentShown(ComponentEvent evt) {
					thisComponentShown(evt);
				}
			});
			pnlConsulta = new JPanel();
			getContentPane().add(pnlConsulta, BorderLayout.NORTH);

			scrConsulta = new JScrollPane();
			pnlConsulta.add(scrConsulta);

			txtConsulta = new JTextArea();
			scrConsulta.setViewportView(txtConsulta);
			txtConsulta.setTabSize(3);
			txtConsulta.setColumns(80);
			txtConsulta.setBorder(BorderFactory.createEtchedBorder(BevelBorder.LOWERED));
			txtConsulta.setText("SELECT * FROM reservas;");
			txtConsulta.setFont(new java.awt.Font("Monospaced", 0, 12));
			txtConsulta.setRows(10);

			btnEjecutar = new JButton();
			pnlConsulta.add(btnEjecutar);
			btnEjecutar.setText("Ejecutar");
			btnEjecutar.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent evt) {
					btnEjecutarActionPerformed(evt);
				}
			});

			botonBorrar = new JButton();
			pnlConsulta.add(botonBorrar);
			botonBorrar.setText("Borrar");
			botonBorrar.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					txtConsulta.setText("");
				}
			});

			scrTabla = new JScrollPane();
			getContentPane().add(scrTabla, BorderLayout.CENTER);

			tabla = new JTable();
			scrTabla.setViewportView(tabla);

			/////////////////////////////////
			pnlTablas = new JPanel();
			pnlTablas.setLayout(new GridLayout(1, 1));
			getContentPane().add(pnlTablas, BorderLayout.SOUTH);

			scrollTablas = new JScrollPane();
			scrollAtributos = new JScrollPane();

			pnlTablas.add(scrollTablas);
			pnlTablas.add(scrollAtributos);

			lblTituloTablas = new JLabel("Tablas Base de Datos Vuelos");
			lblTituloTablas.setFont(new Font("Dialog", Font.BOLD, 13));
			scrollTablas.setColumnHeaderView(lblTituloTablas);

			lblTituloAtributos = new JLabel("Atributos de la Tabla: ");
			lblTituloAtributos.setFont(new Font("Dialog", Font.BOLD, 13));
			scrollAtributos.setColumnHeaderView(lblTituloAtributos);

			conectarBD();
			Statement stmt = this.conexionBD.createStatement();
			String sql = "SHOW TABLES;";
			ResultSet rs = stmt.executeQuery(sql);

			String nombres[] = obtenerContenidoFilas(rs);
			listaTablas = new JList(nombres);

			listaTablas.addListSelectionListener(new ListSelectionListener() {

				public void valueChanged(ListSelectionEvent evt) {
					listaTablasValueChanged(evt);
				}

			});

			listaAtributos = new JList();

			scrollTablas.setViewportView(listaTablas);
			scrollAtributos.setViewportView(listaAtributos);

			pack();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	private void listaTablasValueChanged(ListSelectionEvent evt) {
		String atributos[] = null;
		String itemSeleccionado = (String) listaTablas.getSelectedValue();
		String headerScroll = "Atributos de la Tabla: " + itemSeleccionado;
		try {
			Statement stmt = this.conexionBD.createStatement();
			String sql = "DESCRIBE " + itemSeleccionado + ";";
			ResultSet rs = stmt.executeQuery(sql);
			atributos = obtenerContenidoFilas(rs);
		} catch (Exception e) {
			e.printStackTrace();
		}

		lblTituloAtributos.setText(headerScroll);
		scrollAtributos.setColumnHeaderView(lblTituloAtributos);
		listaAtributos.setListData(atributos);
	}

	private void btnEjecutarActionPerformed(ActionEvent evt) {
		this.refrescarTabla();
	}

	private void thisComponentShown(ComponentEvent evt) {
		this.conectarBD();
	}

	private void thisComponentHidden(ComponentEvent evt) {
		this.desconectarBD();
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

	private void desconectarBD() {
		if (this.conexionBD != null) {
			try {
				this.conexionBD.close();
				this.conexionBD = null;
			} catch (SQLException ex) {
				JOptionPane.showMessageDialog(this,
						"Se produjo un error al intentar desconectarse a la base de datos.\n" + ex.getMessage(),
						"Error", JOptionPane.ERROR_MESSAGE);
			}
		}
	}

	private void refrescarTabla() {
		try {
			Statement stmt = this.conexionBD.createStatement();
			String sql = this.txtConsulta.getText().trim();
			String[] columnas = null;

			boolean isResultSet = stmt.execute(sql);
			ResultSet resultado = null;
			if (isResultSet) {
				resultado = stmt.getResultSet();

				columnas = obtenerNombreColumnas(resultado);

				TableModel BarcosModel = new DefaultTableModel(new String[][] {}, columnas) {
					@Override
					public boolean isCellEditable(int row, int column) {
						return false;
					}
				};

				tabla.setModel(BarcosModel);
				tabla.setAutoCreateRowSorter(true);

				((DefaultTableModel) this.tabla.getModel()).setRowCount(0);
				int i = 0;
				while (resultado.next()) {
					((DefaultTableModel) this.tabla.getModel()).setRowCount(i + 1);
					for (int j = 0; j < columnas.length; j++) {
						this.tabla.setValueAt(resultado.getObject(j + 1), i, j);
					}
					i++;
				}

				resultado.close();
				stmt.close();
			}

		} catch (SQLException ex) {
			// en caso de error, se muestra la causa en la consola
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		}
	}

	private String[] obtenerNombreColumnas(ResultSet tabla) {
		String columnas[] = null;
		try {
			columnas = new String[tabla.getMetaData().getColumnCount()];
			for (int i = 1; i <= tabla.getMetaData().getColumnCount(); i++) {
				columnas[i - 1] = tabla.getMetaData().getColumnName(i);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return columnas;
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

	
	
	
}
