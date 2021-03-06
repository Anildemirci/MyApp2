//
//  UserLoginViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase

class UserLoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var userTypeArray=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius=25
        emailText.layer.cornerRadius=25
        emailText.layer.borderWidth = 1
        emailText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        passwordText.layer.cornerRadius=25
        passwordText.layer.borderWidth=1
        passwordText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        navigationItem.title="Kullanıcı Girişi"
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        // Do any additional setup after loading the view.
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            let firestoreDatabase=Firestore.firestore()
            firestoreDatabase.collection("Users").addSnapshotListener { [self] (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents
                    {
                        if let userType=document.get("Email") as? String{
                            userTypeArray.append(userType)
                        }
                    }
                    if userTypeArray.contains(emailText.text!) {
                        firestoreDatabase.collection("Users").whereField("Email", isEqualTo: emailText.text!).addSnapshotListener { (snapshot, error) in
                            if error == nil {
                                for document in snapshot!.documents {
                                    if let name=document.get("Name") as? String {
                                        if name == "" {
                                            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, errorr) in
                                                if errorr != nil {
                                                    makeAlert(titleInput: "Error", messageInput: errorr?.localizedDescription ?? "Error")
                                                } else {
                                                    performSegue(withIdentifier: "toUserInfoFromLogin", sender: nil)
                                                }
                                            }
                                        } else {
                                            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, errorr) in
                                                if errorr != nil {
                                                    makeAlert(titleInput: "Error", messageInput: errorr?.localizedDescription ?? "Error")
                                                } else {
                                                    performSegue(withIdentifier: "toUserProfileBC", sender: nil)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        makeAlert(titleInput: "Hata", messageInput: "Yanlış giriş tipi seçtiniz veya bilgileri yanlış girdiniz.")
                    }
            }
            }
        }else {
            self.makeAlert(titleInput: "Error", messageInput: "Tüm bilgileri giriniz.")
            
        }
     
    }
    
    func makeAlert(titleInput:String,messageInput:String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
