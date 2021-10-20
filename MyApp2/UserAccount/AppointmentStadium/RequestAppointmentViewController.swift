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
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var view1: UIView!
    
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
        hourLabel.text=("Saat: \(chosenHour)")
        fieldNameLabel.text=("Saha numarası: \(chosenField)")
        stadiumNameLabel.text=chosenStadiumName
        dateLabel.text=("Tarih: \(chosenDay)")
        
        hourLabel.layer.borderWidth=1
        hourLabel.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        fieldNameLabel.layer.borderWidth=1
        fieldNameLabel.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        stadiumNameLabel.layer.borderWidth=1
        stadiumNameLabel.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        dateLabel.layer.borderWidth=1
        dateLabel.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        //confirmButton.layer.cornerRadius=30
        //confirmButton.backgroundColor=UIColor.systemGreen
        confirmButton.setTitleColor(UIColor.white, for: .disabled)
        noteText.layer.borderWidth=1
        noteText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        view1.layer.cornerRadius=30
        
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
    
    func confirmFunc(){
        let firestoreDatabase=Firestore.firestore()
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser?.email,
                           "Type":"User",
                           "StadiumName":chosenStadiumName,
                           "FieldName":chosenField,
                           "Hour":chosenHour,
                           "Price":priceLabel.text!,
                           "Note":noteText.text,
                           "AppointmentDate":chosenDay,
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
                              "Email":Auth.auth().currentUser!.email!,
                              "Type":"User",
                              "StadiumName":chosenStadiumName,
                              "FieldName":chosenField,
                              "Hour":chosenHour,
                              "Price":priceLabel.text!,
                              "Note":noteText.text!,
                              "AppointmentDate":chosenDay,
                              "Status":"Onay bekliyor.",
                              "UserFullName":userName+" "+userSurname,
                              "UserPhone":userPhone,
                              "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        firestoreDatabase.collection("StadiumAppointments").document(stadiumNameLabel.text!).collection(stadiumNameLabel.text!).document(date+"-"+time).setData(firestoreStadium) {
            error in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
            } else {
                //kontrolleri gerçekleştir.
                self.makeAlert(titleInput: "Başarılı", messageInput: "Randevu talebiniz gönderildi.")
            }
        }
        
        let firestoreCalendar=["User":Auth.auth().currentUser!.uid,
                               "Email":Auth.auth().currentUser!.email!,
                               "Type":"User",
                               "StadiumName":chosenStadiumName,
                               "FieldName":chosenField,
                               "Hour":chosenHour,
                               "AppointmentDate":chosenDay,
                               "Price":priceLabel.text!,
                               "Status":"Onay bekliyor.",
                               "Date":FieldValue.serverTimestamp()] as [String:Any]
        firestoreDatabase.collection("Calendar").document(stadiumNameLabel.text!).collection(chosenField).document(chosenDay+"-"+chosenHour).setData(firestoreCalendar) {
            error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }
        }
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        confirmAlert(titleInput: "Onaylama", messageInput: "Randevu talebiniz gönderilsin mi?")
    }
    
    
    func confirmAlert(titleInput: String,messageInput: String) {
           let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        
        let yesButton=UIAlertAction(title: "Evet", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.confirmFunc()
        })
        let noButton=UIAlertAction(title: "Hayır", style: UIAlertAction.Style.default, handler: nil)
           
           alert.addAction(yesButton)
           alert.addAction(noButton)
           self.present(alert, animated: true, completion: nil)
       }
    
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "toUserProfileFromConfirm", sender: nil)
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
