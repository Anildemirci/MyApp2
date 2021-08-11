//
//  DateEditViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 8.08.2021.
//

import UIKit
import Firebase

class DateEditViewController: UIViewController {

    @IBOutlet weak var openingTime: UITextField!
    @IBOutlet weak var closingTime: UITextField!
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
    
    @IBAction func confirmClicked(_ sender: Any) {
        
        if openingTime.text != "" && closingTime.text != "" {
            self.firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: self.currentUser!.uid).getDocuments { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents{
                        let documentId=document.documentID
                        if document.get("Opened") != nil && document.get("Closed") != nil {
                            self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Opened":self.openingTime.text!])
                            self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Closed":self.closingTime.text!])
                            }
                        else {
                            let addOpened=["Opened":self.openingTime.text!,
                                           "Closed":self.closingTime.text!] as [String:Any]
                            self.firestoreDatabase.collection("Stadiums").document(documentId).setData(addOpened, merge: true)
                            self.makeAlert(titleInput: "Success", messageInput: "Çalışma saatleri düzenlendi")
                        }
                    }
                }
            }
            
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Lütfen boş bırakmayınız.")
            }
        }
    

    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
