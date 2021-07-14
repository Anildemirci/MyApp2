//
//  StadiumInformationsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 6.07.2021.
//

import UIKit
import Firebase
class StadiumInformationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var featuresTableView: UITableView!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var userTypeArray=[String]()
    var stadiumTypeArray=[String]()
    var equalName=""
    var infoArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        featuresTableView.delegate=self
        featuresTableView.dataSource=self
        // Do any additional setup after loading the view.
        
        //user girişi ise
        firestoreDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if let userType=document.get("User") as? String{
                        self.userTypeArray.append(userType)
                        if self.userTypeArray.contains(self.currentUser!.uid) {
                            self.backButton.isHidden=true
                            self.editButton.isHidden=true
                            
                            self.firestoreDatabase.collection("Stadiums").whereField("Name", isEqualTo: self.equalName).getDocuments { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents{
                                        let documentId=document.documentID
                                        let docRef=self.firestoreDatabase.collection("Stadiums").document(documentId)
                                        docRef.getDocument(source: .cache) { (document, error) in
                                            if let document = document {
                                                let address=document.get("Address") as! String
                                                self.addressLabel.text=address
                                                
                                                if var info=document.get("Informations") as? [String] {
                                                    self.infoArray=info
                                                    self.featuresTableView.reloadData()
                                                }else {
                                                    self.infoArray=["Saha tarafından henüz bilgi girilmemiştir."]
                                                    
                                                }
                                            }
                                    }
                                    }
                                }
                            }
                        } else {
                            let docRef=self.firestoreDatabase.collection("Stadiums").document(self.currentUser!.uid)
                            docRef.getDocument(source: .cache) { (document, error) in
                                if let document = document {
                                    let address=document.get("Address") as! String
                                    self.addressLabel.text=address
                                    if var info=document.get("Informations") as? [String] {
                                        self.infoArray=info
                                        self.featuresTableView.reloadData()
                                    }else {
                                        self.infoArray=["Saha tarafından henüz bilgi girilmemiştir."]
                                        
                                    }
                                }
                        }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=featuresTableView.dequeueReusableCell(withIdentifier: "WorkingHoursCell", for: indexPath) as! WorkingHoursCell
        cell.dayLabel.text=infoArray[indexPath.row]
        return cell
    }
    
    @IBAction func backClicked(_ sender: Any) {
        
    }
    @IBAction func editClicked(_ sender: Any) {
        
    }
    
    @IBAction func navigationClicked(_ sender: Any) {
    }
    
    
}
