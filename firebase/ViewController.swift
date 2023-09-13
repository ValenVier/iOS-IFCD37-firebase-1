//
//  ViewController.swift
//  firebase
//
//  Created by Javier Rodríguez Valentín on 04/10/2021.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet var telephone: UIView!
    
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPass: UILabel!
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPass: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("viewdidload", parameters: ["msg":"analíticas funcionando"])
        
        telephone.backgroundColor = .orange
        
        navigationItem.hidesBackButton = true
        
        labelEmail.textAlignment = .center
        labelEmail.text = "Email"
        labelEmail.font = labelEmail.font.withSize(23)
        labelPass.textAlignment = .center
        labelPass.text = "Contraseña"
        labelPass.font = labelEmail.font.withSize(23)
        
        inputEmail.attributedPlaceholder = NSAttributedString(string: "Introduzca su Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        inputEmail.keyboardType = .emailAddress//teclado del tipo email
        inputEmail.spellCheckingType = UITextSpellCheckingType.no//para que no cambie palabras de forma automáticamente
        
        inputPass.attributedPlaceholder = NSAttributedString(string: "Introduzca su contraseña", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        inputPass.isSecureTextEntry = true
        
        
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.tintColor = .white
        loginBtn.layer.cornerRadius = 12
        loginBtn.backgroundColor = UIColor(red: 98/255, green: 128/255, blue: 18/255, alpha: 1)
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        registerBtn.setTitle("Registrarse", for: .normal)
        registerBtn.tintColor = .white
        registerBtn.layer.cornerRadius = 12
        registerBtn.backgroundColor = .red
        registerBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
    }
    
    //MARK: viewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        self.view.endEditing(true) //para hacer desaparecer el teclado
    }

    //MARK: loginBtnAc
    @IBAction func loginBtnAc(_ sender: Any) {
    
        Auth.auth().signIn(withEmail: inputEmail.text!, password: inputPass.text!) { (result, error) in
            
            if error != nil{
                print("Usuario no registrado")
            }else{
                
                //Si no hay error nos lleva a la siguiente pantalla
                self.navigationController?.pushViewController(UserViewController(email: self.inputEmail.text!), animated: true)
                
            }
        }
    }

    //MARK: registerbtnAc
    @IBAction func registerbtnAc(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: inputEmail.text!, password: inputPass.text!) { (result, error) in
            
            if error != nil{
                print("Hubo un problema al registrar")
            }else{
                
                //Si no hay error nos lleva a la siguiente pantalla
                self.navigationController?.pushViewController(UserViewController(email: self.inputEmail.text!), animated: true)
                
            }
            
        }
    }
    
    //MARK: touchesBegan()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Hace desaparecer el teclado cuando se toca en otro lugar que no sea un label -> https://kaushalelsewhere.medium.com/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
        view.endEditing(true)
    }
    
    //MARK: viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        //para inicializar los campos de textos sin nada escrito
        inputEmail.text = ""
        inputPass.text = ""
    }

}

