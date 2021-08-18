//
//  AppoitmentViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 3.08.2021.
//

import UIKit
import Firebase

class AppoitmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var stadiumName=""
    var nameFields=[String]()
    var selectedField=""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
        firestoreDatabase.collection("Stadiums").whereField("Name", isEqualTo: stadiumName).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let numberField=document.get("NumberOfField") as! String
                    let intNumberField=Int(numberField)
                    for number in 1...intNumberField! {
                        self.nameFields.append("Saha \(number)")
                    }
                    self.tableView.reloadData()
                }
            }
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameFields.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as! FieldTableViewCell
        cell.fieldNameLabel.text=nameFields[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectedField" {
            let destinationVC=segue.destination as! DateViewController
            destinationVC.nameLabel=selectedField
            destinationVC.stadium=stadiumName
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedField=nameFields[indexPath.row]
        performSegue(withIdentifier: "toSelectedField", sender: nil)
    }
}
