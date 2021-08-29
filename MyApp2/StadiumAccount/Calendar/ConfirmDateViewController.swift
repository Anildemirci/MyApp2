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
    var pending=[String]()
    var confirmed=[String]()
    var daysArray=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
        collectionView.delegate=self
        collectionView.dataSource=self
        // Do any additional setup after loading the view.
        fieldName.text=selectedName
        let docRef=firestoreDatabase.collection("Stadiums").document(currentUser!.uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                self.nameStadium=name
            }
    }
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
        
        self.tableview.reloadData()
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
        return hourArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "confirmDateCell", for: indexPath) as! ConfirmDateTableViewCell
        cell.hourLabel?.text=hourArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "DatesCollectionViewCell", for: indexPath) as! DatesCollectionViewCell
        cell.datesLabel.text=daysArray[indexPath.row]
        return cell
    }
 
    @IBAction func editClicked(_ sender: Any) {
    
}

}
