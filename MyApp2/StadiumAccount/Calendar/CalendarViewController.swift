//
//  CalendarViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 23.06.2021.
//

import UIKit
import Firebase

class CalendarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var nameFields=[String]()
    var chosenName=""
    var stadiumName=""
    override func viewDidLoad() {
        tableView.delegate=self
        tableView.dataSource=self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let docRef=firestoreDatabase.collection("Stadiums").document(currentUser!.uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                self.stadiumName=name
                let fields=document.get("NumberOfField") as! String
                let intFields=Int(fields)
                for number in 1...intFields! {
                    self.nameFields.append("Saha \(number)")
                }
                self.tableView.reloadData()
            }
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameFields.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "confirmField", for: indexPath) as! ConfirmFieldTableViewCell
        cell.fieldNameLabel.text=nameFields[indexPath.row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmDate" {
            let destinationVC=segue.destination as! ConfirmDateViewController
            destinationVC.selectedName=chosenName
            destinationVC.nameStadium=stadiumName
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenName=nameFields[indexPath.row]
        performSegue(withIdentifier: "toConfirmDate", sender: nil)
    }
}
