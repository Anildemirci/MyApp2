//
//  PendingAppointmentsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 24.08.2021.
//

import UIKit
import Firebase

class PendingAppointmentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var stadiumName=""
    var appointmentsArray=[String]()
    var chosenAppointment=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        // Do any additional setup after loading the view.
        firestoreDatabase.collection("StadiumAppointments").document(stadiumName).collection(stadiumName).whereField("Status", isEqualTo: "Onay bekliyor.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    self.appointmentsArray.append(document.documentID)
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointmentsArray.count == 0 {
            return 1
        } else {
            return appointmentsArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "pendingAppointments", for: indexPath) as! PendingAppointmentsCellTableViewCell
        if appointmentsArray.count == 0 {
            cell.appointmentLabel.text="Henüz bekleyen randevunuz yok."
            tableView.isUserInteractionEnabled=false
            return cell
        } else {
            cell.appointmentLabel.text=appointmentsArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenAppointment=appointmentsArray[indexPath.row]
        performSegue(withIdentifier: "toConfirmAppointment", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmAppointment" {
            let destinationVC=segue.destination as! ConfirmAppointmentViewController
            destinationVC.documentID=chosenAppointment
            destinationVC.name=stadiumName
        }
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
