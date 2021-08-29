//
//  DateEditViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 8.08.2021.
//

import UIKit
import Firebase

class DateEditViewController: UIViewController {

    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var chosenField=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    

    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
