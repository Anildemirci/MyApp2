//
//  DateViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 3.08.2021.
//

import UIKit

class DateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hourArray=[String]()
    var nameLabel=""
    var selectedHour=""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        collectionView.delegate=self
        collectionView.dataSource=self
        // Do any additional setup after loading the view.
        fieldName.text=nameLabel
        hourArray=["00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00","04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRequestAppointment" {
            let destinationVC=segue.destination as! RequestAppointmentViewController
            destinationVC.chosenHour=selectedHour
            destinationVC.chosenField=nameLabel
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        cell.datesButton.setTitle("17.05.1996", for: .normal)
        cell.datesButton.addTarget(self, action: #selector(viewdetail), for: .touchUpInside)
        return cell
    }
    @objc func viewdetail(sender:UIButton){
        hourArray=["11:11-01:00","21:00-02:00","32:00-03:00","43:00-04:00","64:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-10:00"]
    }
}
