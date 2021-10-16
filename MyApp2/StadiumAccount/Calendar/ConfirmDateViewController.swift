//
//  ConfirmDateViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 3.08.2021.
//

import UIKit
import Firebase
import Foundation

class ConfirmDateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hourArray=[String]()
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var selectedName=""
    var nameStadium=""
    var hour=""
    var date=""
    var daysArray=[String]()
    var redHours=[String]()
    var redDates=[String]()
    var yellowHours=[String]()
    var yellowDates=[String]()
    var preDay=""
    var selectedIndex=Int()
    var closedByStadium=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
        collectionView.delegate=self
        collectionView.dataSource=self
        // Do any additional setup after loading the view.
        fieldName.text=selectedName
        
        hourArray=["00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00","04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"]
        
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
       // getHourfromCalendar()
    }
    
    func getHourfromCalendar(){
        self.firestoreDatabase.collection("Calendar").document(nameStadium).collection(selectedName).whereField("Status", isEqualTo: "Onaylandı.").addSnapshotListener { (snapshot,error) in
            if error == nil {
                for document in snapshot!.documents {
                    if let redhour=document.get("Hour") {
                        self.redHours.append(redhour as! String)
                    }
                }
            }
        }
        self.firestoreDatabase.collection("Calendar").document(nameStadium).collection(selectedName).whereField("Status", isEqualTo: "Onay bekliyor.").addSnapshotListener { (snapshot,error) in
            if error == nil {
                for document in snapshot!.documents {
                    if let yellowHour=document.get("Hour") {
                        self.yellowHours.append(yellowHour as! String)
                    }
                }
            }
        }
    }
    
    func getDatefromCalendar(day: String){
        
        if preDay != day {
            redDates.removeAll()
            yellowDates.removeAll()
            closedByStadium.removeAll()
            self.firestoreDatabase.collection("Calendar").document(nameStadium).collection(selectedName).whereField("AppointmentDate", isEqualTo: day).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents {
                        if let type=document.get("Type") {
                            if type as! String == "Stadium" {
                                let closedStadium=document.get("Hour") as! String
                                if self.closedByStadium.contains(closedStadium) {
                                    
                                } else {
                                    self.closedByStadium.append(closedStadium)
                                }
                            } else if type as! String == "User" {
                                if let status=document.get("Status") {
                                    if status as! String == "Onaylandı." {
                                        let redhours=document.get("Hour")
                                        if self.redDates.contains(redhours as! String) {
                                        } else {
                                            self.redDates.append(redhours as! String)
                                        }
                                    }
                                    else if status as! String == "Onay bekliyor." {
                                        let yellowhours=document.get("Hour")
                                        if self.yellowDates.contains(yellowhours as! String) {
                                        } else {
                                            self.yellowDates.append(yellowhours as! String)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            self.firestoreDatabase.collection("Calendar").document(nameStadium).collection(selectedName).whereField("AppointmentDate", isEqualTo: day).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents {
                        if let type=document.get("Type") {
                            if type as! String == "Stadium" {
                                let closedStadium=document.get("Hour") as! String
                                if self.closedByStadium.contains(closedStadium) {
                                    
                                } else {
                                    self.closedByStadium.append(closedStadium)
                                }
                            } else if type as! String == "User" {
                                if let status=document.get("Status") {
                                    if status as! String == "Onaylandı." {
                                        let redhours=document.get("Hour")
                                        if self.redDates.contains(redhours as! String) {
                                        } else {
                                            self.redDates.append(redhours as! String)
                                        }
                                    }
                                    else if status as! String == "Onay bekliyor." {
                                        let yellowhours=document.get("Hour")
                                        if self.yellowDates.contains(yellowhours as! String) {
                                        } else {
                                            self.yellowDates.append(yellowhours as! String)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hour=hourArray[indexPath.row]
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "confirmDateCell", for: indexPath) as! ConfirmDateTableViewCell
        cell.hourLabel.backgroundColor=UIColor.green
        
        if closedByStadium.count > 1 {
            for i in 0...closedByStadium.count-1 {
                if hourArray[indexPath.row]==(closedByStadium[i]) {
                    cell.hourLabel.backgroundColor=UIColor.purple
                    cell.isUserInteractionEnabled=true
                    cell.closeButton.isHidden=true
                    cell.openButton.isHidden=false
                }
            }
        } else if closedByStadium.count == 1 {
            let redHour=closedByStadium[0]
            if hourArray[indexPath.row]==(redHour) {
                cell.hourLabel.backgroundColor=UIColor.purple
                cell.isUserInteractionEnabled=true
                cell.closeButton.isHidden=true
                cell.openButton.isHidden=false
            }
        }
        
        if redDates.count > 1 {
            for i in 0...redDates.count-1 {
                if hourArray[indexPath.row]==(redDates[i]) {
                    cell.hourLabel.backgroundColor=UIColor.red
                    cell.isUserInteractionEnabled=false
                    cell.closeButton.isHidden=true
                }
            }
        } else if redDates.count == 1 {
            let redHour=redDates[0]
            if hourArray[indexPath.row]==(redHour) {
                cell.hourLabel.backgroundColor=UIColor.red
                cell.isUserInteractionEnabled=false
                cell.closeButton.isHidden=true
            }
        }
        if yellowDates.count > 1 {
            for i in 0...yellowDates.count-1 {
                
                if hourArray[indexPath.row]==(yellowDates[i]) {
                    cell.hourLabel.backgroundColor=UIColor.yellow
                    cell.isUserInteractionEnabled=false
                    cell.closeButton.isHidden=true

                }
            }
        } else if yellowDates.count == 1 {
            let yellowHour=yellowDates[0]
            if hourArray[indexPath.row]==(yellowHour) {
                cell.hourLabel.backgroundColor=UIColor.yellow
                cell.isUserInteractionEnabled=false
                cell.closeButton.isHidden=true
            }
        }
        
        cell.hourLabel.text=hourArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex=indexPath.row
        date=daysArray[indexPath.row]
        getDatefromCalendar(day: date)
        self.collectionView.reloadData()
        self.tableview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "DatesCollectionViewCell", for: indexPath) as! DatesCollectionViewCell
        cell.datesLabel.text=daysArray[indexPath.row]
        if selectedIndex==indexPath.row {
            cell.backgroundColor=UIColor.brown
        } else {
            cell.backgroundColor=UIColor.white
        } 
        return cell
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        
        if date != "" && hour != "" {
            let firestoreCalendar=["User":Auth.auth().currentUser!.uid,
                                   "Email":Auth.auth().currentUser!.email!,
                                   "Type":"Stadium",
                                   "StadiumName":self.nameStadium,
                                   "FieldName":self.selectedName,
                                   "Hour":self.hour,
                                   "AppointmentDate":self.date,
                                   "Price":"Bilinmiyor.",
                                   "Status":"Onaylandı.",
                                   "Date":FieldValue.serverTimestamp()] as [String:Any]
            self.firestoreDatabase.collection("Calendar").document(self.nameStadium).collection(self.selectedName).document(self.date+"-"+self.hour).setData(firestoreCalendar) {
                error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else {
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Saati randevulara kapattınız.")
                    self.hour=""
                    self.tableview.reloadData()
                }
            }
        } else {
            self.makeAlert(titleInput: "Hata", messageInput: "Tarih/saat seçiniz.")
        }
        
        }
    
    @IBAction func openClicked(_ sender: Any) {
        if date != "" && hour != "" {
            self.firestoreDatabase.collection("Calendar").document(self.nameStadium).collection(self.selectedName).document(self.date+"-"+self.hour).delete { error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Saati randevulara açtınız.")
                    self.hour=""
                    self.tableview.reloadData()
                }
            }
        } else {
            self.makeAlert(titleInput: "Hata", messageInput: "Tarih/saat seçiniz.")
        }
    }
    
    @IBAction func editClicked(_ sender: Any) {
        performSegue(withIdentifier: "toEditFromField", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditFromField" {
            let destinationVC=segue.destination as! DateEditViewController
            destinationVC.chosenField=selectedName
            destinationVC.chosenStadium=nameStadium
        }
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

