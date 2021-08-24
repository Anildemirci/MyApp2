//
//  UserSignUpViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase

class UserSignUpViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var password2Text: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.setTitleColor(UIColor.white, for: .disabled)
        signUpButton.backgroundColor = .green
        signUpButton.layer.cornerRadius=20
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" && password2Text.text != "" {
            if passwordText.text == password2Text.text {
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                    if error != nil {
                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        self.performSegue(withIdentifier: "toUserInfoVC", sender: nil)
                    }
                }
            } else {
                makeAlert(titleInput: "Error!", messageInput: "Şifreler eşleşmiyor.")
            }
        } else {
            makeAlert(titleInput: "Error!", messageInput: "Tüm bilgileri giriniz.")
        }
        
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

