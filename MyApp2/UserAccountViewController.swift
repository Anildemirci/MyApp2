//
//  UserAccountViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 23.06.2021.
//

import UIKit
import Firebase

class UserAccountViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var firedatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let docref=firedatabase.collection("Users").document(currentUser!.uid)
        docref.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                self.nameLabel.text=("Hoşgeldin \(name)")
            }
        }
        // Do any additional setup after loading the view.
    }
    


}
