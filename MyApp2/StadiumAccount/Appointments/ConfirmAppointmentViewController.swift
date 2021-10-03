//
//  ConfirmAppointmentViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 24.08.2021.
//

import UIKit
import Firebase
import ImageSlideshow

class ConfirmAppointmentViewController: UIViewController {
    
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var downPaymentLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var documentID=""
    var name=""
    var userID=""
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.setTitleColor(UIColor.white, for: .disabled)
        confirmButton.backgroundColor = .green
        confirmButton.layer.cornerRadius=20
        rejectButton.setTitleColor(UIColor.white, for: .disabled)
        rejectButton.backgroundColor = .red
        rejectButton.layer.cornerRadius=20
        // Do any additional setup after loading the view.
        firestoreDatabase.collection("StadiumAppointments").document(name).collection(name).document(documentID).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        let fieldName=document.get("FieldName") as! String
                        self.fieldNameLabel.text=fieldName
                        let date=document.get("AppointmentDate") as! String
                        self.dateLabel.text=date
                        let hour=document.get("Hour") as! String
                        self.hourLabel.text=hour
                        let price=document.get("Price") as! String
                        self.priceLabel.text=price
                        let note=document.get("Note") as! String
                        self.noteLabel.text=note
                        let userName=document.get("UserFullName") as! String
                        self.userFullNameLabel.text=userName
                        let userPhone=document.get("UserPhone") as! String
                        self.userPhoneLabel.text=userPhone
                        let userId=document.get("User") as! String
                        self.userID=userId
                    }
                }
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        self.firestoreDatabase.collection("StadiumAppointments").document(name).collection(name).document(documentID).updateData(["Status":"Onaylandı."])
        self.firestoreDatabase.collection("UserAppointments").document(userID).collection(userID).document(documentID).updateData(["Status":"Onaylandı."])
        self.firestoreDatabase.collection("Calendar").document(name).collection(name).document(documentID).updateData(["Status":"Onaylandı."])
        self.makeAlert(titleInput: "Başarılı", messageInput: "Randevu onaylanmıştır.")
    }
    
    @IBAction func rejectClicked(_ sender: Any) {
        self.firestoreDatabase.collection("StadiumAppointments").document(name).collection(name).document(documentID).updateData(["Status":"Reddedildi."])
        self.firestoreDatabase.collection("UserAppointments").document(userID).collection(userID).document(documentID).updateData(["Status":"Reddedildi."])
        self.firestoreDatabase.collection("Calendar").document(name).collection(name).document(documentID).updateData(["Status":"Onaylandı."])
        self.makeAlert(titleInput: "Başarılı", messageInput: "Randevu reddedilmiştir.")
    }
    
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
