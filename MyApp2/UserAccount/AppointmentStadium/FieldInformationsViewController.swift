//
//  FieldInformationsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 7.10.2021.
//

import UIKit
import Firebase

class FieldInformationsViewController: UIViewController {

    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var sizeFieldLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var downPaymenLabel: UILabel!
    
    var firestoreDatabase=Firestore.firestore()
    var chosenFieldName=""
    var chosenStadiumName=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldNameLabel.text=chosenFieldName
        
        self.firestoreDatabase.collection("FieldInfo").document(chosenStadiumName).collection(chosenStadiumName).whereField("FieldName", isEqualTo: chosenFieldName).addSnapshotListener { (snapshot,error) in
            if error == nil {
                if snapshot?.isEmpty == false {
                    for document in snapshot!.documents {
                            let price=document.get("Price")
                            self.priceLabel.text=("Saha fiyatı: \(price!)") as String
                            let downPayment=document.get("DownPayment")
                            self.downPaymenLabel.text=("Kapora: \(downPayment!)") as String
                            let size=document.get("SizeOfField")
                            self.sizeFieldLabel.text=("Saha büyüklüğü: \(size!)") as String
                    }
                } else {
                    self.sizeFieldLabel.text="Henüz saha boyutu hakkında bilgi verilmedi."
                    self.priceLabel.text="Henüz saha fiyatı hakkında bilgi verilmedi."
                    self.downPaymenLabel.text="Henüz kapora hakkında bilgi verilmedi."
                }
                
            }
        }
    
}
}
