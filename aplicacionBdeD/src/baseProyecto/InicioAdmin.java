package baseProyecto;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;


@SuppressWarnings("serial")
public class InicioAdmin extends javax.swing.JInternalFrame{
	
	private JPanel panel;
	private JPanel panelDatos;
	private JTextField usuario;
	private JPasswordField password;
	private JButton btnIniciarSesion;
	private VentanaConsultas ventanaConsultas;

	
	/**
	 * Create the application.
	 */
	public InicioAdmin(VentanaConsultas vc) {
		this.ventanaConsultas= vc;
		initGUI();		
	}
	
	/**
	 * Inicializo GUI
	 */
	private void initGUI() {
		try {
			setPreferredSize(new Dimension(1100,600));
			this.setBounds(0,0,800,600);
			setVisible(true);
			BorderLayout thisLayout = new BorderLayout();
			this.setTitle("Iniciar Sesion");
			
			getContentPane().setLayout(thisLayout);
			this.setClosable(true);
			this.setDefaultCloseOperation(WindowConstants.HIDE_ON_CLOSE);
	        this.setMaximizable(false);
	        
	        panelDatos = new JPanel();
	        panelDatos.setLayout(new GridLayout(2,2));
	        panelDatos.setPreferredSize(new Dimension(300,50));
	        
	        panel = new JPanel();
	        SpringLayout layout= new SpringLayout();
	        panel.setLayout(layout);
	        
	        panel.add(panelDatos);
	        
	        getContentPane().add(panel,BorderLayout.CENTER);
	        
	        JLabel lblUsuario = new JLabel("Usuario:");
			lblUsuario.setFont(new Font("Dialog", Font.BOLD, 13));
			lblUsuario.setBounds(92, 63, 66, 15);
			panelDatos.add(lblUsuario);
			
	        usuario = new JTextField();
			usuario.setBounds(281, 61, 124, 19);
			panelDatos.add(usuario);
			usuario.setColumns(10);
	       
			
			JLabel lblContrasea = new JLabel("Password");
			lblContrasea.setFont(new Font("Dialog", Font.BOLD, 13));
			lblContrasea.setBounds(92, 123, 83, 15);
			panelDatos.add(lblContrasea);	
			
			password = new JPasswordField();
			password.setBounds(281, 121, 124, 19);
			panelDatos.add(password);
			
			btnIniciarSesion = new JButton("Iniciar Sesion");
			btnIniciarSesion.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent evt) {
					
					char[] arrayC = password.getPassword();
					String pass = new String(arrayC);
					
					if(usuario.getText().equals("admin") && pass.equals("admin")) {
						activarConsultasAdmin();
						usuario.setText("");
						password.setText("");
						
					}
					else {
						JOptionPane.showMessageDialog(null, "Usuario o Contrase�a incorrectos", "Error", JOptionPane.WARNING_MESSAGE);
					}
				}
			});
			
			btnIniciarSesion.setBounds(167, 178, 150, 30);
			panel.add(btnIniciarSesion);
			
			
			layout.putConstraint(SpringLayout.WEST, panelDatos, 50,SpringLayout.WEST, panel);
			
			layout.putConstraint(SpringLayout.WEST, btnIniciarSesion, 140, SpringLayout.WEST, panel);
			
			layout.putConstraint(SpringLayout.NORTH, panelDatos, 50,SpringLayout.NORTH, panel);
			
			layout.putConstraint(SpringLayout.NORTH, btnIniciarSesion, 25,SpringLayout.SOUTH, panelDatos);
			
			pack();
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}	
		
	}
	
	/**
	 * Activo consultas de Administrador
	 */
	private void activarConsultasAdmin() {
		ventanaConsultas.setVisible(true);
		this.setVisible(false);
	}
}
