//
//  RequestAppointmentViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 3.08.2021.
//

import UIKit
import Firebase

class RequestAppointmentViewController: UIViewController {
    
    @IBOutlet weak var stadiumNameLabel: UILabel!
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var noteText: UITextField!
    
    var chosenHour=""
    var chosenDay=""
    var chosenField=""
    var chosenStadiumName=""
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var userName=""
    var userPhone=""
    var userSurname=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hourLabel.text=chosenHour
        fieldNameLabel.text=chosenField
        stadiumNameLabel.text=chosenStadiumName
        dateLabel.text=chosenDay
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        let docref=firestoreDatabase.collection("Users").document(currentUser!.uid)
        docref.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                self.userName=name
                let phone=document.get("Phone") as! String
                self.userPhone=phone
                let surname=document.get("Surname") as! String
                self.userSurname=surname
            }
        }
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        let firestoreDatabase=Firestore.firestore()
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser?.email,
                           "Type":"User",
                           "StadiumName":stadiumNameLabel.text!,
                           "FieldName":fieldNameLabel.text!,
                           "Hour":hourLabel.text!,
                           "Price":priceLabel.text!,
                           "Note":noteText.text,
                           "AppointmentDate":dateLabel.text!,
                           "Status":"Onay bekliyor.",
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .medium
        timeFormatter.dateFormat = "HH:mm:ss" //24 saatlik format için
        let date = dateFormatter.string(from: NSDate() as Date)
        let time = timeFormatter.string(from: NSDate() as Date)

        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).document(date+"-"+time).setData(firestoreUser) {
            error in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
            } else {
                self.makeAlert(titleInput: "Başarılı", messageInput: "Randevu talebiniz gönderildi.")
                //kontrolleri gerçekleştir.
            }
        }
        
        let firestoreStadium=["User":Auth.auth().currentUser!.uid,
                              "Email":Auth.auth().currentUser?.email,
                              "Type":"User",
                              "StadiumName":stadiumNameLabel.text!,
                              "FieldName":fieldNameLabel.text!,
                              "Hour":hourLabel.text!,
                              "Price":priceLabel.text!,
                              "Note":noteText.text!,
                              "AppointmentDate":dateLabel.text!,
                              "Status":"Onay bekliyor.",
                              "UserFullName":userName+" "+userSurname,
                              "UserPhone":userPhone,
                              "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        firestoreDatabase.collection("StadiumAppointments").document(stadiumNameLabel.text!).collection(stadiumNameLabel.text!).document(date+"-"+time).setData(firestoreStadium) {
            error in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
            } else {
                self.makeAlert(titleInput: "Başarılı", messageInput: "Randevu talebiniz gönderildi.")
                //kontrolleri gerçekleştir.
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
