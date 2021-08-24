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
    @IBOutlet weak var numberOfField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.setTitleColor(UIColor.white, for: .disabled)
        confirmButton.backgroundColor = .blue
        confirmButton.layer.cornerRadius=20
        // Do any additional setup after loading the view.
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        let firestoreDatabese=Firestore.firestore()
        let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                              "Email":Auth.auth().currentUser?.email,
                              "Name":nameText.text!,
                              "City":cityText.text!,
                              "Town":townText.text!,
                              "Phone":phoneText.text!,
                              "Address":addressText.text!,
                              "NumberOfField":numberOfField.text!,
                              "Type":"Stadium",
                              "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        if nameText.text != "" && cityText.text != "" && townText.text != "" && phoneText.text != "" &&  addressText.text != "" && numberOfField.text != "" {
            firestoreDatabese.collection("Stadiums").document(Auth.auth().currentUser!.uid).setData(firestoreStadium) {
                error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toStadiumProfileBC", sender: nil)
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
