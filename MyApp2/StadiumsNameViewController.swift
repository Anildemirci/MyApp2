//
//  StadiumsNameViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 24.06.2021.
//

import UIKit
import Firebase

class StadiumsNameViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "stadiumCell", for: indexPath) as! StadiumsTableViewCell
        cell.stadiumNameLabel.text="deneme"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
}
