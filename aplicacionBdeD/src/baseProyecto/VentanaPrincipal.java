package baseProyecto;

import java.awt.*;
import java.awt.event.*;
import java.beans.PropertyVetoException;

import javax.swing.*;


@SuppressWarnings("serial")
public class VentanaPrincipal extends javax.swing.JFrame{
	
	private InicioAdmin inicioSesion;
	private VentanaConsultas ventanaConsultas;
	
	private JDesktopPane desktopPane;
	private JMenuBar menuBar;
	
	private JMenu mnuOperaciones;
	private JMenuItem mniConsultaAdmin;
    private JMenuItem mniConsultaEmpleado;
    private JMenuItem mniAbm;
    private JSeparator separator;
    private JMenuItem mniSalir;
    
    public static void main(String[] args) 
    {
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
    }
    
    private void initGUI() {
    	try 
        {
           javax.swing.UIManager.setLookAndFeel(javax.swing.UIManager.getSystemLookAndFeelClassName());
        } 
        catch(Exception e) 
        {
           e.printStackTrace();
        }
    	
    	try {
    		
    		this.setTitle("Aplicacion Proyecto Base de Datos");
            this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
            
            desktopPane = new JDesktopPane();
            getContentPane().add(desktopPane,BorderLayout.CENTER);
            desktopPane.setPreferredSize(new java.awt.Dimension(800,600));
            
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
            //SETEAR LISTENER
            
            mniAbm = new JMenuItem();
            mnuOperaciones.add(mniAbm);
            mniAbm.setText("Alta - Baja - Modificacion");
            //SETEAR LISTENER
            
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
            
            this.setSize(800,600);
            pack();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    private void mniConsultaAdminActionPerformed(ActionEvent evt) {
    	try {
    		this.ventanaConsultas.setMaximum(true);
    	}
    	catch(PropertyVetoException e) {
    	}
    	this.inicioSesion.setVisible(true);
    }
    
    private void mniSalirActionPerformed(ActionEvent evt) {
    	this.dispose();
    }
}
