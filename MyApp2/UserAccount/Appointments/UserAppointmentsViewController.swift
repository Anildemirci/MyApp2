//
//  UserAppointmentsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 25.08.2021.
//

import UIKit
import Firebase

class UserAppointmentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var appointmentsArray=[String]()
    var appointmentDate=""
    var status=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        // Do any additional setup after loading the view.
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).whereField("Status", isEqualTo: status).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    self.appointmentsArray.append(document.documentID)
                }
                if self.appointmentsArray.count == 0 {
                    self.tableView.isUserInteractionEnabled=false
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
        let cell=tableView.dequeueReusableCell(withIdentifier: "userAppointmentCell", for: indexPath) as! UserAppointmentTableViewCell
        if appointmentsArray.count != 0 {
            cell.appointmentLabel.text=appointmentsArray[indexPath.row]
            return cell
        } else {
            cell.appointmentLabel.text="Henüz bekleyen randevunuz yok."
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appointmentDate=appointmentsArray[indexPath.row]
        performSegue(withIdentifier: "toShowAppointment", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowAppointment" {
            let destinationVC=segue.destination as! EvaluationViewController
            destinationVC.documentID=appointmentDate
        }
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
