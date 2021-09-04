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
                self.userFullname.text=name+" "+surname
                let mobilePhone=document.get("Phone") as! String
                self.phone.text=mobilePhone
                let userCity=document.get("City") as! String
                self.city.text=userCity
                let userTown=document.get("Town") as! String
                self.town.text=userTown
                
                //bugüne kadar aldığı maç sayısı ekleyebilirsin.
            }
        }
    }
    

}
