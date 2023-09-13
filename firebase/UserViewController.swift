//
//  UserViewController.swift
//  firebase
//
//  Created by Javier Rodríguez Valentín on 04/10/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet var userView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var inputAddress: UITextField!
    @IBOutlet weak var inputPhone: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var modifyBtn: UIButton!
    @IBOutlet weak var eraseBtn: UIButton!
    
    
    var email = ""
    var db = Firestore.firestore()
    
    init(email:String){
        self.email = email
        super.init(nibName: "UserViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        //esta función te la pone Xcode al meter la función anterior del init
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true //oculta el botón back
        navigationController?.isNavigationBarHidden = true //oculta la barra entera
        //navigationItem.setHidesBackButton(true, animated: true) //oculta el botón back 
        
        userView.backgroundColor = .cyan
        
        label.text = email
        label.textAlignment = .center
        label.font = label.font.withSize(23)
        
        labelAddress.text = "Dirección"
        labelAddress.textAlignment = .center
        labelAddress.font = label.font.withSize(23)
        
        labelPhone.text = "Teléfono"
        labelPhone.textAlignment = .center
        labelPhone.font = label.font.withSize(23)
        
        inputAddress.attributedPlaceholder = NSAttributedString(string: "Introduzca su dirección", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        inputAddress.font = UIFont.systemFont(ofSize: 23)
        inputAddress.keyboardType = .emailAddress//teclado del tipo email
        inputAddress.spellCheckingType = UITextSpellCheckingType.no//para que no cambie palabras de forma automáticamente
        
        inputPhone.attributedPlaceholder = NSAttributedString(string: "Introduzca su teléfono", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        inputPhone.font = UIFont.systemFont(ofSize: 23)
        inputPhone.keyboardType = .phonePad//teclado numérico
        
        saveBtn.setTitle("Guardar datos", for: .normal)
        saveBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        saveBtn.tintColor = .white
        saveBtn.layer.cornerRadius = 12
        saveBtn.backgroundColor = UIColor(red: 98/255, green: 128/255, blue: 18/255, alpha: 1)
        saveBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
        modifyBtn.setTitle("Obtener datos", for: .normal)
        modifyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        modifyBtn.tintColor = .white
        modifyBtn.layer.cornerRadius = 12
        modifyBtn.backgroundColor = UIColor(red: 98/255, green: 128/255, blue: 18/255, alpha: 1)
        modifyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
        eraseBtn.setTitle("Borrar datos", for: .normal)
        eraseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        eraseBtn.tintColor = .white
        eraseBtn.layer.cornerRadius = 12
        eraseBtn.backgroundColor = UIColor(red: 213/255, green: 143/255, blue: 0/255, alpha: 1)
        eraseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
        logoutBtn.setTitle("LOGOUT", for: .normal)
        logoutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        logoutBtn.tintColor = .white
        logoutBtn.layer.cornerRadius = 12
        logoutBtn.backgroundColor = UIColor(red: 213/255, green: 143/255, blue: 0/255, alpha: 1)
        logoutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
        deleteBtn.setTitle("BORRAR CUENTA", for: .normal)
        deleteBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        deleteBtn.tintColor = .white
        deleteBtn.layer.cornerRadius = 12
        deleteBtn.backgroundColor = UIColor(red: 255/255, green: 34/255, blue: 0/255, alpha: 1)
        deleteBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
    }
    
    //MARK: touchesBegan()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    //MARK: logoutBtnAc
    @IBAction func logoutBtnAc(_ sender: Any) {
        logout()
    }
    
    //MARK: deleteBtnAc
    @IBAction func deleteBtnAc(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                // An error happened.
                print("Error al eliminar la cuenta. Error: \(error)")
            } else {
                // Account deleted.
                self.alert(titulo: "Eliminar cuenta", msg: "Cuenta eliminada")
                self.logout()
            }
        }
        
    }
    
    //MARK: logout()
    func logout(){
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Error. No se ha podido desloguear")
        }
       
    }
    
    //MARK: saveBtnAc
    @IBAction func saveBtnAc(_ sender: Any) {
        self.view.endEditing(true) //para hacer desaparecer el teclado
        var a = 0
        if inputAddress.text == "" && inputPhone.text! == ""{
            a = 1
        }else if inputAddress.text != "" && inputPhone.text! == ""{
            a = 2
        }else if inputAddress.text == "" && inputPhone.text! != ""{
            a = 3
        }else if inputAddress.text != "" && inputPhone.text! != ""{
            a = 4
        }else{
            a = 5
        }
        save(a: a)
        
    }
    
    //MARK: modifyBtnAc
    @IBAction func modifyBtnAc(_ sender: Any) {
        self.view.endEditing(true) //para hacer desaparecer el teclado
        db.collection("usuarios").document(email).getDocument { (capture, error) in
            
            if let document = capture , error == nil{
                if let address = document.get("direccion") as? String{
                    self.inputAddress.text = address
                }else{
                    self.inputAddress.text = ""
                }
                
                if let phone = document.get("telefono") as? String{
                    self.inputPhone.text = phone
                }else{
                    self.inputAddress.text = ""
                    self.inputPhone.text = ""
                }
                
                if ((document.get("direccion") as? String) == nil) && ((document.get("telefono") as? String) == nil){
                    self.alert(titulo: "Modificar datos", msg: "Sin datos para mostrar")
                }
                
            }
        }
    }
    
    //MARK: eraseBtnAc
    @IBAction func eraseBtnAc(_ sender: Any) {
        
        self.view.endEditing(true) //para hacer desaparecer el teclado
        db.collection("usuarios").document(email).delete()
        alert(titulo: "Borrar datos", msg: "Datos borrados")
        self.inputPhone.text = ""
        self.inputAddress.text = ""
        //borra solo un campo
        //db.collection("usuarios").document(email).updateData(["dieccion" : FieldValue.delete()])
    }
    
    //MARK: alert()
    func alert(titulo: String, msg:String){
        
        //print("exito")
        let alert = UIAlertController(title: titulo, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: {/*Para poner el temporizador, se puede poner nil*/ Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        })})
        
    }
    
    //MARK: save(a)
    func save(a: Int){
    
        switch a {
        case 1:
            alert(titulo: "Guardar datos", msg: "Escriba algo para guardar")
        case 2:
            db.collection("usuarios").document(email).setData(["direccion" : inputAddress.text!])
            //print("datos guardados")
            alert(titulo: "Guardar datos", msg: "Dirección guardada satisfactoriamente")
            inputAddress.text = ""
        case 3:
            db.collection("usuarios").document(email).setData(["telefono": inputPhone.text!])
            //print("datos guardados")
            alert(titulo: "Guardar datos", msg: "Teléfono guardado satisfactoriamente")
            inputPhone.text = ""
        case 4:
            db.collection("usuarios").document(email).setData(["direccion" : inputAddress.text!, "telefono": inputPhone.text!])
            print("datos guardados")
            alert(titulo: "Guardar datos", msg: "Datos guardados satisfactoriamente")
            inputAddress.text = ""
            inputPhone.text = ""
        case 5:
            alert(titulo: "Guardar datos", msg: "Error al guardar")
        default:
            alert(titulo: "Guardar datos", msg: "Error al guardar2")
        }
        
    }
    
    
}

/* para eliminar el teclado desde el alert, no es la mejor manera
 func alert(msg:String){
     
     //print("exito")
     let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "ok", style: .default, handler:{_ in
         self.view.endEditing(true) //para eleminar el teclado
     }))
     present(alert, animated: true, completion: {/*Para poner el temporizador, se puede poner nil*/ Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
         self.dismiss(animated: true, completion: nil)
     })})
     
 }
 */


/* Para hacer diferentes textos
 
 label.attributedText =
 NSMutableAttributedString()
 .bold("Address: ")
 .normal(" Kathmandu, Nepal\n\n")
 .orangeHighlight(" Email: ")
 .blackHighlight(" prajeet.shrestha@gmail.com ")
 .bold("\n\nCopyright: ")
 .underlined(" All rights reserved. 2020.")
 
 */

