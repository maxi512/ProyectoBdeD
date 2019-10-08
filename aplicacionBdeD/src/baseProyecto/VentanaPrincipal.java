package baseProyecto;

import java.awt.*;
import java.awt.event.*;
import java.beans.PropertyVetoException;

import javax.swing.*;

@SuppressWarnings("serial")
public class VentanaPrincipal extends javax.swing.JFrame {

	private InicioAdmin inicioSesion;
	private VentanaConsultas ventanaConsultas;
	private InicioEmpleado inicioEmpleado;
	private VentanaInfoVuelos ventanaInfoVuelos;

	private JDesktopPane desktopPane;
	private JMenuBar menuBar;

	private JMenu mnuOperaciones;
	private JMenuItem mniConsultaAdmin;
	private JMenuItem mniConsultaEmpleado;
	private JMenuItem mniAbm;
	private JSeparator separator;
	private JMenuItem mniSalir;

	public static void main(String[] args) {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				VentanaPrincipal inst = new VentanaPrincipal();
				inst.setLocationRelativeTo(null);
				inst.setVisible(true);
			}
		});
	}

	public VentanaPrincipal() {
		super();

		initGUI();

		this.ventanaConsultas = new VentanaConsultas();
		this.ventanaConsultas.setVisible(false);
		this.desktopPane.add(this.ventanaConsultas);

		this.inicioSesion = new InicioAdmin(ventanaConsultas);
		this.inicioSesion.setVisible(false);
		this.desktopPane.add(this.inicioSesion);
		
		this.ventanaInfoVuelos = new VentanaInfoVuelos();
		this.ventanaInfoVuelos.setVisible(false);
		this.desktopPane.add(this.ventanaInfoVuelos);

		this.inicioEmpleado = new InicioEmpleado(ventanaInfoVuelos);
		this.inicioEmpleado.setVisible(false);
		this.desktopPane.add(this.inicioEmpleado);
	}

	private void initGUI() {
		try {
			javax.swing.UIManager.setLookAndFeel(javax.swing.UIManager.getSystemLookAndFeelClassName());
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {

			this.setTitle("Aplicacion Proyecto Base de Datos");
			this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

			desktopPane = new JDesktopPane();
			getContentPane().add(desktopPane, BorderLayout.CENTER);
			desktopPane.setPreferredSize(new java.awt.Dimension(1100, 600));

			menuBar = new JMenuBar();
			setJMenuBar(menuBar);

			mnuOperaciones = new JMenu();
			menuBar.add(mnuOperaciones);
			mnuOperaciones.setText("Operaciones");

			mniConsultaAdmin = new JMenuItem();
			mnuOperaciones.add(mniConsultaAdmin);
			mniConsultaAdmin.setText("Consultas Administrador");
			mniConsultaAdmin.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent evt) {
					mniConsultaAdminActionPerformed(evt);
				}
			});

			mniConsultaEmpleado = new JMenuItem();
			mnuOperaciones.add(mniConsultaEmpleado);
			mniConsultaEmpleado.setText("Consultas Empleado");
			mniConsultaEmpleado.addActionListener(new ActionListener() {
				
				@Override
				public void actionPerformed(ActionEvent arg0) {
					mnConsultaEmpleadoActionPerformed(arg0);
					
				}
			});
			// SETEAR LISTENER

			mniAbm = new JMenuItem();
			mnuOperaciones.add(mniAbm);
			mniAbm.setText("Alta - Baja - Modificacion");
			// SETEAR LISTENER

			separator = new JSeparator();
			mnuOperaciones.add(separator);

			mniSalir = new JMenuItem();
			mnuOperaciones.add(mniSalir);
			mniSalir.setText("Salir");
			mniSalir.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent evt) {
					mniSalirActionPerformed(evt);
				}
			});

			this.setSize(800, 600);
			pack();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void mnConsultaEmpleadoActionPerformed(ActionEvent arg0) {
		try {
			this.ventanaConsultas.setMaximum(true);
		} catch (PropertyVetoException e) {
		}
		
		this.inicioEmpleado.setVisible(true);
	}

	private void mniConsultaAdminActionPerformed(ActionEvent evt) {
		try {
			this.ventanaConsultas.setMaximum(true);
		} catch (PropertyVetoException e) {
		}
		this.inicioSesion.setVisible(true);
	}

	private void mniSalirActionPerformed(ActionEvent evt) {
		this.dispose();
	}
}
