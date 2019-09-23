package hola;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JButton;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import java.awt.Font;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class pantalla {

	private JFrame frame;
	private JTextField textField;
	private JPasswordField passwordField;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					pantalla window = new pantalla();
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
	public pantalla() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setResizable(false);
		frame.setBounds(100, 100, 492, 325);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		textField = new JTextField();
		textField.setBounds(281, 61, 124, 19);
		frame.getContentPane().add(textField);
		textField.setColumns(10);
		
		passwordField = new JPasswordField();
		passwordField.setBounds(281, 121, 124, 19);
		frame.getContentPane().add(passwordField);
		
		JButton btnIniciarSesion = new JButton("Iniciar Sesion");
		btnIniciarSesion.addActionListener(new ActionListener() {
			
			
			
			public void actionPerformed(ActionEvent arg0) {
				
				char[] arrayC = passwordField.getPassword();
				
				String pass = new String(arrayC);

				if(!(textField.getText().equals("")&& !(pass.equals("")))){

					Servidor server = new Servidor();
					try {
						
						server.establecerConexion(textField.getText(), pass);
						
					}
					catch(java.sql.SQLException e) {
						
						
						System.out.println(e.getMessage());
						System.out.println(e.getSQLState());
						System.out.println(e.getErrorCode());

					}
					
				}
				
				
			}
		});
		btnIniciarSesion.setBounds(167, 178, 125, 25);
		frame.getContentPane().add(btnIniciarSesion);
		
		JLabel lblUsuario = new JLabel("Usuario:");
		lblUsuario.setFont(new Font("Dialog", Font.BOLD, 13));
		lblUsuario.setBounds(92, 63, 66, 15);
		frame.getContentPane().add(lblUsuario);
		
		JLabel lblContrasea = new JLabel("Contraseña:");
		lblContrasea.setBounds(92, 123, 83, 15);
		frame.getContentPane().add(lblContrasea);
	}
}
