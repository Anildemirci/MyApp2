//
//  StadiumInformationsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 6.07.2021.
//

import UIKit

class StadiumInformationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var featuresTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        featuresTableView.delegate=self
        featuresTableView.dataSource=self
        // Do any additional setup after loading the view.
        addressLabel.text="Fındıklı Mahallesi,Başıbüyük Yolu No:54,Maltepe/İstanbul"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=featuresTableView.dequeueReusableCell(withIdentifier: "WorkingHoursCell", for: indexPath) as! WorkingHoursCell
        cell.dayLabel.text="Kamera var"
        
        return cell
    }
    
    @IBAction func backClicked(_ sender: Any) {
        
    }
    @IBAction func editClicked(_ sender: Any) {
        
    }
    
    @IBAction func navigationClicked(_ sender: Any) {
    }
    
}
