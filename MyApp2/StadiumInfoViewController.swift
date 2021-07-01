//
//  StadiumInfoViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 23.06.2021.
//

import UIKit
import Firebase

class StadiumInfoViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var townText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    
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
        
        let firestoreDatabese=Firestore.firestore()
        var firestoreReference:DocumentReference? = nil
        let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                              "Email":Auth.auth().currentUser?.email,
                              "Name":nameText.text!,
                              "City":cityText.text!,
                              "Town":townText.text!,
                              "Phone":phoneText.text!,
                              "Address":addressText.text!,
                              "Type":"Stadium",
                              "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        if nameText.text != "" && cityText.text != "" && townText.text != "" && phoneText.text != "" &&  addressText.text != "" {
            firestoreReference=firestoreDatabese.collection("Stadiums").addDocument(data: firestoreStadium, completion: { (error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toStadiumProfileBC", sender: nil)
                }
            })
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
