//
//  UserInformationViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 25.08.2021.
//

import UIKit
import Firebase
class UserInformationViewController: UIViewController {

    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var town: UILabel!
    @IBOutlet weak var confirmedAppointments: UILabel!
    @IBOutlet weak var canceledAppointments: UILabel!
    
    var confirmedNumber=Int()
    var canceledNumber=Int()
    var firedatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let docref=firedatabase.collection("Users").document(currentUser!.uid)
        docref.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                let surname=document.get("Surname") as! String
                self.userFullname.text="Ad Soyad: \(name) \(surname)"
                let mobilePhone=document.get("Phone") as! String
                self.phone.text="Telefon: \(mobilePhone)"
                let userCity=document.get("City") as! String
                self.city.text="Şehir: \(userCity)"
                let userTown=document.get("Town") as! String
                self.town.text="İlçe: \(userTown)"
                
                
            }
        }
        firedatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).whereField("Status", isEqualTo:"İptal edildi.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                self.canceledNumber=snapshot!.count
                self.canceledAppointments.text=("İptal ettiğin randevu sayısı: \(self.canceledNumber)")
            }
    }
        firedatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).whereField("Status", isEqualTo:"Onaylandı.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                self.confirmedNumber=snapshot!.count
                self.confirmedAppointments.text=("Aldığın randevu sayısı: \(self.confirmedNumber)")
            }
    }
        
        
}
}
