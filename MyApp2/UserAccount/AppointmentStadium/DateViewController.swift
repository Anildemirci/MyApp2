//
//  DateViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 3.08.2021.
//

import UIKit
import Firebase

class DateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    var hourArray=[String]()
    var nameLabel=""
    var selectedHour=""
    var selectedDay=""
    var stadium=""
    var daysArray=[String]()
    var redHours=[String]()
    var yellowHours=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        collectionView.delegate=self
        collectionView.dataSource=self
        // Do any additional setup after loading the view.
        fieldName.text=nameLabel
        
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
        getHourfromCalendar()
        tableView.reloadData()
    }
    
    func getHourfromCalendar(){
        self.firestoreDatabase.collection("Calendar").document(stadium).collection(nameLabel).whereField("Status", isEqualTo: "Onaylandı.").addSnapshotListener { (snapshot,error) in
            if error == nil {
                for document in snapshot!.documents {
                    if let redhour=document.get("Hour") {
                        self.redHours.append(redhour as! String)
                    }
                }
            }
        }
        self.firestoreDatabase.collection("Calendar").document(stadium).collection(nameLabel).whereField("Status", isEqualTo: "Onay bekliyor.").addSnapshotListener { (snapshot,error) in
            if error == nil {
                for document in snapshot!.documents {
                    if let yellowHour=document.get("Hour") {
                        self.yellowHours.append(yellowHour as! String)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
        cell.dateLabel.backgroundColor=UIColor.green
        if redHours.count > 1 {
            for i in 0...redHours.count-1 {
                if hourArray[indexPath.row].contains(redHours[i]) {
                    cell.dateLabel.backgroundColor=UIColor.red
                    cell.isUserInteractionEnabled=false
                }
            }
        } else if redHours.count == 1 {
            let redHour=redHours[0]
            if hourArray[indexPath.row].contains(redHour) {
                cell.dateLabel.backgroundColor=UIColor.red
                cell.isUserInteractionEnabled=false
            }
        }
        if yellowHours.count > 1 {
            for i in 0...yellowHours.count-1 {
                if hourArray[indexPath.row].contains(yellowHours[i]) {
                    cell.dateLabel.backgroundColor=UIColor.yellow
                    cell.isUserInteractionEnabled=false
                }
            }
        } else if yellowHours.count == 1 {
            let yellowHour=yellowHours[0]
            if hourArray[indexPath.row].contains(yellowHour) {
                cell.dateLabel.backgroundColor=UIColor.yellow
                cell.isUserInteractionEnabled=false
            }
        }
        
        cell.dateLabel.text=hourArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHour=hourArray[indexPath.row]
        performSegue(withIdentifier: "toRequestAppointment", sender: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDay=daysArray[indexPath.row]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRequestAppointment" {
            let destinationVC=segue.destination as! RequestAppointmentViewController
            destinationVC.chosenHour=selectedHour
            destinationVC.chosenField=nameLabel
            destinationVC.chosenStadiumName=stadium
            destinationVC.chosenDay=selectedDay
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        cell.datesLabel.text=daysArray[indexPath.row]
        return cell
    }

}
