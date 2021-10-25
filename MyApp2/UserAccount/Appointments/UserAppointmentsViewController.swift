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
    var confirmedAppointmentsArray=[String]()
    var pastAppointments=[String]()
    var appointmentDate=""
    var status=""
    var daysArray=[String]()
    var today=""
    var navTitle=""
    var appointmentCount=0
    
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
            
            
            navigationItem.title=navTitle
            navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        }
        
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).whereField("Status", isEqualTo: status).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let date=document.get("AppointmentDate") as! String
                    if self.status == "Onay bekliyor." {
                        if self.daysArray.contains(date) {
                            self.appointmentsArray.append(document.documentID)
                        }
                    }
                    else if self.status == "Onaylandı." {
                        if self.daysArray.contains(date) {
                            self.confirmedAppointmentsArray.append(document.documentID)
                        } else {
                            self.pastAppointments.append(document.documentID)
                        }
                    }
                }
                if self.status == "Onay bekliyor." {
                    self.appointmentCount=self.appointmentsArray.count
                } else {
                    if self.today == "past" {
                        self.appointmentCount=self.pastAppointments.count
                    } else {
                        self.appointmentCount=self.confirmedAppointmentsArray.count
                    }
                }
                if self.appointmentCount == 0  {
                    self.tableView.isUserInteractionEnabled=false
                }
                self.tableView.reloadData()
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
        var number=0
        if status == "Onaylandı." {
            if today == "past" {
                if pastAppointments.count == 0 {
                    return 1
                } else {
                    number=pastAppointments.count
                }
            }
            else if today == "next"{
                if confirmedAppointmentsArray.count == 0 {
                    return 1
                } else {
                    number=confirmedAppointmentsArray.count
                }
            }
        } else {
            if appointmentsArray.count == 0 {
                return 1
            } else {
                number=appointmentsArray.count
            }
        }
        return number
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "userAppointmentCell", for: indexPath) as! UserAppointmentTableViewCell
        
        if status == "Onaylandı." {
            
            if today == "past" {
                if pastAppointments.count != 0 {
                    cell.appointmentLabel.text=pastAppointments[indexPath.row]
                } else {
                    cell.appointmentLabel.text="Henüz bekleyen randevunuz yok."
                }
            }
            else if today == "next" {
                if confirmedAppointmentsArray.count != 0 {
                    cell.appointmentLabel.text=confirmedAppointmentsArray[indexPath.row]
                } else {
                    cell.appointmentLabel.text="Henüz bekleyen randevunuz yok."
                }
            }
            
        } else {
            if appointmentsArray.count != 0 {
                cell.appointmentLabel.text=appointmentsArray[indexPath.row]
            } else {
                cell.appointmentLabel.text="Henüz bekleyen randevunuz yok."
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if today == "past" {
            appointmentDate=pastAppointments[indexPath.row]
        } else if today == "next" {
            appointmentDate=confirmedAppointmentsArray[indexPath.row]
        } else {
            appointmentDate=appointmentsArray[indexPath.row]
        }
        
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
