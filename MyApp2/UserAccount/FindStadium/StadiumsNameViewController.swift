//
//  StadiumsNameViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 24.06.2021.
//

import UIKit
import Firebase

class StadiumsNameViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var stadiumNameArray=[String]()
    var selectedTown=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
        getDataFromFirestore()
    }
 
    func getDataFromFirestore(){
       let firestoreDatabase=Firestore.firestore()
        firestoreDatabase.collection("Stadiums").order(by: "Name",descending: false).addSnapshotListener { (snapshot, error) in
           if error != nil {
               print(error?.localizedDescription ?? "Error")
           } else {
               if snapshot?.isEmpty != true && snapshot != nil {
                   for document in snapshot!.documents {
                       
                       if let Name = document.get("Town") as? String {
                           if Name==self.selectedTown {
                               let stadiumName=document.get("Name") as! String
                               self.stadiumNameArray.append(stadiumName)
                           }
                       }
                   }
                   self.tableView.reloadData()
               }
           }
       }
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "stadiumCell", for: indexPath) as! StadiumsTableViewCell
        cell.stadiumNameLabel.text=stadiumNameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stadiumNameArray.count
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toTownName", sender: nil)
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTown=stadiumNameArray[indexPath.row]
        performSegue(withIdentifier: "toSelectedStadium", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toSelectedStadium" {
            let destinationVC=segue.destination as! SelectedStadiumViewController
            destinationVC.name=selectedTown
        }
    }
    
    }
