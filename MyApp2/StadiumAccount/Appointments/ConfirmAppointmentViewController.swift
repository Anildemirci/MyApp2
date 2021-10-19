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
    @IBOutlet weak var confirmNumberLabel: UILabel!
    @IBOutlet weak var cancelNumberLabel: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var documentID=""
    var name=""
    var userID=""
    var cancelNumber=Int()
    var confirmNumber=Int()
    var fieldNamee=""
    var datee=""
    var hourr=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = .systemGreen
        confirmButton.layer.cornerRadius=30
        rejectButton.setTitleColor(UIColor.white, for: .normal)
        rejectButton.backgroundColor = .red
        rejectButton.layer.cornerRadius=30
        fieldNameLabel.layer.borderWidth=1
        fieldNameLabel.layer.borderColor=UIColor.systemGreen.cgColor
        dateLabel.layer.borderWidth=1
        dateLabel.layer.borderColor=UIColor.systemGreen.cgColor
        hourLabel.layer.borderWidth=1
        hourLabel.layer.borderColor=UIColor.systemGreen.cgColor
        priceLabel.layer.borderWidth=1
        priceLabel.layer.borderColor=UIColor.systemGreen.cgColor
        noteLabel.layer.borderWidth=1
        noteLabel.layer.borderColor=UIColor.systemGreen.cgColor
        userFullNameLabel.layer.borderWidth=1
        userFullNameLabel.layer.borderColor=UIColor.systemGreen.cgColor
        userPhoneLabel.layer.borderWidth=1
        userPhoneLabel.layer.borderColor=UIColor.systemGreen.cgColor
        downPaymentLabel.layer.borderWidth=1
        downPaymentLabel.layer.borderColor=UIColor.systemGreen.cgColor
        confirmNumberLabel.layer.borderWidth=1
        confirmNumberLabel.layer.borderColor=UIColor.systemGreen.cgColor
        cancelNumberLabel.layer.borderWidth=1
        cancelNumberLabel.layer.borderColor=UIColor.systemGreen.cgColor
        view1.layer.cornerRadius=30
        view2.layer.cornerRadius=30
        // Do any additional setup after loading the view.

        
        firestoreDatabase.collection("StadiumAppointments").document(name).collection(name).document(documentID).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        let fieldName=document.get("FieldName") as! String
                        self.fieldNameLabel.text=("Saha Adı: \(fieldName)")
                        self.fieldNamee=fieldName
                        let date=document.get("AppointmentDate") as! String
                        self.dateLabel.text=("Tarih: \(date)")
                        self.datee=date
                        let hour=document.get("Hour") as! String
                        self.hourLabel.text=("Saat: \(hour)")
                        self.hourr=hour
                        let price=document.get("Price") as! String
                        self.priceLabel.text=("Fiyat: \(price)")
                        let note=document.get("Note") as! String
                        self.noteLabel.text=("Not: \(note)")
                        let userName=document.get("UserFullName") as! String
                        self.userFullNameLabel.text=("Adı: \(userName)")
                        let userPhone=document.get("UserPhone") as! String
                        self.userPhoneLabel.text=("Telefon: \(userPhone)")
                    }
                }
        firestoreDatabase.collection("StadiumAppointments").document(name).collection(name).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    if document.documentID == self.documentID {
                        let userId=document.get("User") as! String
                        self.userID=userId
                    }
                }
            }
            self.getFromData()
        }
    }
    
    
    func getFromData(){
        firestoreDatabase.collection("UserAppointments").document(userID).collection(userID).whereField("Status", isEqualTo:"İptal edildi.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                self.cancelNumber=snapshot!.count
                self.cancelNumberLabel.text!=("İptal ettiği randevu sayısı: \(self.cancelNumber)")
            }
    }
        firestoreDatabase.collection("UserAppointments").document(userID).collection(userID).whereField("Status", isEqualTo:"Onaylandı.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                self.confirmNumber=snapshot!.count
                self.confirmNumberLabel.text!=("Tamamladığı randevu sayısı: \(self.confirmNumber)")
            }
    }
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        
        confirmAlert(titleInput: "Onaylama", messageInput: "Randevuyu onaylamak istiyor musunuz?")
        
    }
    
    @IBAction func rejectClicked(_ sender: Any) {

        rejectAlert(titleInput: "Onaylama", messageInput: "Randevuyu reddetmek istiyor musunuz?")
        
    }
    
    func confirmAlert(titleInput: String,messageInput: String) {
           let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        
        let yesButton=UIAlertAction(title: "Evet", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.firestoreDatabase.collection("StadiumAppointments").document(self.name).collection(self.name).document(self.documentID).updateData(["Status":"Onaylandı."])
            self.firestoreDatabase.collection("UserAppointments").document(self.userID).collection(self.userID).document(self.documentID).updateData(["Status":"Onaylandı."])
            self.firestoreDatabase.collection("Calendar").document(self.name).collection(self.fieldNamee).document(self.datee+"-"+self.hourr).updateData(["Status":"Onaylandı."])
            self.makeAlert(titleInput: "Başarılı", messageInput: "Randevu onaylandı.")
        })
        let noButton=UIAlertAction(title: "Hayır", style: UIAlertAction.Style.default, handler: nil)
           
           alert.addAction(yesButton)
           alert.addAction(noButton)
           self.present(alert, animated: true, completion: nil)
       }
    
    func rejectAlert(titleInput: String,messageInput: String) {
           let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        
        let yesButton=UIAlertAction(title: "Evet", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.firestoreDatabase.collection("StadiumAppointments").document(self.name).collection(self.name).document(self.documentID).updateData(["Status":"Reddedildi."])
            self.firestoreDatabase.collection("UserAppointments").document(self.userID).collection(self.userID).document(self.documentID).updateData(["Status":"Reddedildi."])
            self.firestoreDatabase.collection("Calendar").document(self.name).collection(self.fieldNamee).document(self.datee+"-"+self.hourr).updateData(["Status":"Reddedildi."])
            self.makeAlert(titleInput: "Başarılı", messageInput: "Randevu reddedildi.")
            
        })
        let noButton=UIAlertAction(title: "Hayır", style: UIAlertAction.Style.default, handler: nil)
           
           alert.addAction(yesButton)
           alert.addAction(noButton)
           self.present(alert, animated: true, completion: nil)
       }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "toStadiumProfileFromConfirm", sender: nil)
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
