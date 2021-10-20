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
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var townText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var dateOfBirthText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.layer.cornerRadius=25
        nameText.layer.cornerRadius=25
        nameText.layer.borderWidth = 1
        nameText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        surnameText.layer.cornerRadius=25
        surnameText.layer.borderWidth=1
        surnameText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        cityText.layer.cornerRadius=25
        cityText.layer.borderWidth=1
        cityText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        townText.layer.cornerRadius=25
        townText.layer.borderWidth = 1
        townText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        phoneText.layer.cornerRadius=25
        phoneText.layer.borderWidth=1
        phoneText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        dateOfBirthText.layer.cornerRadius=25
        dateOfBirthText.layer.borderWidth=1
        dateOfBirthText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        // Do any additional setup after loading the view.
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        let firestoreDatabase=Firestore.firestore()
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
        if nameText.text != "" && surnameText.text != "" && cityText.text != "" && townText.text != "" && phoneText.text != "" && dateOfBirthText.text != "" {
            firestoreDatabase.collection("Users").document(Auth.auth().currentUser!.uid).setData(firestoreUser) {
                error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toUserProfileBC", sender: nil)
                }
            }
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Lütfen tüm bilgileri giriniz.")
        }
    }
    
    
    func makeAlert(titleInput:String,messageInput:String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
