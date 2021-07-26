//
//  FavoritesViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var chosenName=""
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var favStadium=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
        getDataFromFirestore()
    }
    func getDataFromFirestore(){
        
        self.firestoreDatabase.collection("Users").whereField("User", isEqualTo: currentUser!.uid).getDocuments { (snapshot, error) in
                for document in snapshot!.documents{
                    let docRef=self.firestoreDatabase.collection("Users").document(self.currentUser!.uid)
                    docRef.getDocument(source: .cache) { (document, error) in
                        if let document = document {
                            
                            if var favName=document.get("FavoriteStadiums") as? [String] {
                                self.favStadium=favName
                                self.tableView.reloadData()
                            }
                        }
                }
                }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favStadium.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! FavoriteStadiumsTableViewCell
        cell.nameLabel.text=favStadium[indexPath.row]
        return cell
    }
    
}
