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
    var currentTime=""
    var daysArray=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        // Do any additional setup after loading the view.
        
        for day in 0...13 {
            let hourToAdd=3
            let daysToAdd=0 + day
            let UTCDate = getCurrentDate()
            var dateComponent = DateComponents()
            dateComponent.hour=hourToAdd
            dateComponent.day = daysToAdd
            let currentDate = Calendar.current.date(byAdding: dateComponent, to: UTCDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let date = dateFormatter.string(from: currentDate! as Date)
            daysArray.append(date)
        }
        
        firestoreDatabase.collection("StadiumAppointments").document(stadiumName).collection(stadiumName).whereField("Status", isEqualTo: "Onay bekliyor.").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let date=document.get("AppointmentDate") as! String
                    if self.daysArray.contains(date) {
                        self.appointmentsArray.append(document.documentID)
                    }
                }
                if self.appointmentsArray.count == 0 {
                    self.tableView.isUserInteractionEnabled=false
                }
                //self.tableView.reloadData() life cycle'da incele
            }
        }
        
    }
    
    func getCurrentDate()->Date {
        var now=Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now
        
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
