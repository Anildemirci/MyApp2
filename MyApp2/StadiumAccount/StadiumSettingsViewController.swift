//
//  StadiumSettingsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 23.06.2021.
//

import UIKit
import Firebase

class StadiumSettingsViewController: UIViewController {
    
    @IBOutlet weak var newMailText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var newPasswordText2: UITextField!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeEmailButton.setTitleColor(UIColor.white, for: .normal)
        //changeEmailButton.backgroundColor = .systemBlue
        changeEmailButton.layer.cornerRadius=30
        changePasswordButton.setTitleColor(UIColor.white, for: .normal)
        //changePasswordButton.backgroundColor = .systemBlue
        changePasswordButton.layer.cornerRadius=30
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        //logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius=30
        view1.layer.cornerRadius=30
        view2.layer.cornerRadius=30
        // Do any additional setup after loading the view.
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("**Error**")
        }
    }
    
    @IBAction func changeMailClicked(_ sender: Any) {
        
        if newMailText.text != "" {
            currentUser?.updateEmail(to: newMailText.text!, completion: { (error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Lütfen geçerli mail adresi giriniz.")
                } else {
                    self.firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: self.currentUser!.uid).getDocuments { (snapshot, error) in
                        if error == nil {
                            for document in snapshot!.documents{
                                let documentId=document.documentID
                                self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Email": self.newMailText.text!])
                                self.makeAlert(titleInput: "Başarılı", messageInput: "Mail adresiniz değiştirilmiştir.")
                            }
                        }
                    }
                }
            })
        }else {
            makeAlert(titleInput: "Error", messageInput: "Lütfen yeni mailinizi giriniz.")
        }
    }
    
    @IBAction func changePasswordClicked(_ sender: Any) {
        
        if newPasswordText.text != "" && newPasswordText2.text != "" {
            if newPasswordText.text==newPasswordText2.text {
                currentUser?.updatePassword(to: newPasswordText.text!, completion: { (error) in
                    if error != nil {
                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        self.makeAlert(titleInput: "Başarılı", messageInput: "Şifreniz değiştirilmiştir.")
                    }
                })
            } else {
                self.makeAlert(titleInput: "Error", messageInput: "Şifreler eşleşmiyor.")
            }
        }else {
            self.makeAlert(titleInput: "Error", messageInput: "Lütfen eksiksiz doldurunuz.")
        }
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
