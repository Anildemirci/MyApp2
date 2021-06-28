//
//  StadiumLoginViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase

class StadiumLoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var stadiumMailArray=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()

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
            firestoreDatabase.collection("Stadiums").addSnapshotListener { [self] (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents
                    {
                        if let userType=document.get("User") as? String{
                            stadiumMailArray.append(userType)
                        }
                    }
                    if stadiumMailArray.contains(emailText.text!) {
                        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, errorr) in
                            if errorr != nil {
                                makeAlert(titleInput: "Error", messageInput: errorr?.localizedDescription ?? "Error")
                            } else {
                                performSegue(withIdentifier: "toStadiumProfileBC", sender: nil)
                            }
                        }
                    } else {
                        makeAlert(titleInput: "Hata", messageInput: "Yanlış giriş tipi seçtiniz veya bilgileri yanlış girdiniz.")
                    }
            } else {
                self.makeAlert(titleInput: "Error", messageInput: "Tüm bilgileri giriniz.")
                
            }
            }
        }
    }
    func makeAlert(titleInput:String,messageInput:String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
