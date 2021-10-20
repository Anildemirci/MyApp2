//
//  StadiumSignUpViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase

class StadiumSignUpViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordText2: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        //signUpButton.backgroundColor = .systemGreen
        signUpButton.layer.cornerRadius=25
        emailText.layer.cornerRadius=25
        emailText.layer.borderWidth = 1
        emailText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        passwordText.layer.cornerRadius=25
        passwordText.layer.borderWidth=1
        passwordText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        passwordText2.layer.cornerRadius=25
        passwordText2.layer.borderWidth=1
        passwordText2.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        // Do any additional setup after loading the view.
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
    }
    
    @IBAction func signupButtonClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" && passwordText2.text != "" {
            if passwordText.text == passwordText2.text {
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                    if error != nil {
                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        
                        let firestoreDatabese=Firestore.firestore()
                        let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                                              "Email":Auth.auth().currentUser?.email,
                                              "Name":"",
                                              "City":"",
                                              "Town":"",
                                              "Phone":"",
                                              "Address":"",
                                              "NumberOfField":"",
                                              "Type":"Stadium",
                                              "Date":FieldValue.serverTimestamp()] as [String:Any]
                        firestoreDatabese.collection("Stadiums").document(Auth.auth().currentUser!.uid).setData(firestoreStadium) {
                            error in
                            if error != nil {
                                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                            } else {
                                self.performSegue(withIdentifier: "toStadiumInfoVC", sender: nil)
                            }
                        }
                    }
                }
            } else {
                makeAlert(titleInput: "Error", messageInput: "Şifreler eşleşmiyor.")
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Tüm bilgilerini giriniz.")
        }
        
    }
    
    func makeAlert(titleInput:String,messageInput:String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
