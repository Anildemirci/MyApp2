//
//  FindStadiumViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase

class FindStadiumViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray=[String]()
    var chosenTown=""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        getDataFromFirestore()
              }
    
     func getDataFromFirestore(){
        let firestoreDatabase=Firestore.firestore()
         firestoreDatabase.collection("Stadiums").order(by: "Town",descending: false) .addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let Town = document.get("Town") as? String {
                            if self.nameArray.contains(Town) {
                                //zaten içeriyor.
                            } else {
                                self.nameArray.append(Town)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell
        cell.townNameLabel.text=nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            chosenTown=nameArray[indexPath.row]
            performSegue(withIdentifier: "toStadiumName", sender: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStadiumName" {
            let destinationVC=segue.destination as! StadiumsNameViewController
            destinationVC.selectedTown=chosenTown
        }
    }
    
}
