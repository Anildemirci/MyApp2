//
//  UserSettingsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase
class UserSettingsViewController: UIViewController {
    
    @IBOutlet weak var newMailText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var newPasswordText2: UITextField!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        do {
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
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Mail adresiniz değiştirilmiştir.")
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
        let okButton=UIAlertAction(title: titleInput, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
