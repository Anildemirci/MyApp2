//
//  ConfirmDateViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 3.08.2021.
//

import UIKit
import Firebase

class ConfirmDateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hourArray=[String]()
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var selectedName=""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
        collectionView.delegate=self
        collectionView.dataSource=self
        // Do any additional setup after loading the view.
        fieldName.text=selectedName
        
        hourArray=["00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00","04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"]
        self.tableview.reloadData()
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
        
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .medium
        timeFormatter.dateFormat = "HH:mm:ss" //24 saatlik format için
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: NSDate() as Date)
        let time = timeFormatter.string(from: NSDate() as Date)
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "DatesCollectionViewCell", for: indexPath) as! DatesCollectionViewCell
        cell.dateButton.setTitle(date, for: .normal)
        cell.dateButton.addTarget(self, action: #selector(viewdetail), for: .touchUpInside)
        return cell
    }
    @objc func viewdetail(sender:UIButton){
        hourArray=["11:11-01:00","21:00-02:00","32:00-03:00","43:00-04:00","64:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-10:00"]
    }
    @IBAction func editClicked(_ sender: Any) {
    
}

}
