//
//  UserInfoViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var dateOfBirthText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var townText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        let firestoreDatabase=Firestore.firestore()
        var firestoreReference : DocumentReference?=nil
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser?.email,
                           "Name":nameText.text!,
                           "Surname":surnameText.text!,
                           "DateofBirth":dateOfBirthText.text!,
                           "City":cityText.text!,
                           "Town":townText.text!,
                           "Phone":phoneText.text!,
                           "Type":"User",
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        if nameText.text != "" && surnameText.text != "" && dateOfBirthText.text != "" && cityText.text != "" && townText.text != "" && phoneText.text != "" {
            firestoreReference=firestoreDatabase.collection("Users").addDocument(data: firestoreUser, completion: { (error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toUserProfileBC", sender: nil)
                }
            })
        } else {
            makeAlert(titleInput: "Error", messageInput: "Tüm bilgileri giriniz.")
        }
    }
    
    func makeAlert(titleInput:String,messageInput:String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
