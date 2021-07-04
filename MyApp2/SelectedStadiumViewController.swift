//
//  SelectedStadiumViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 4.07.2021.
//

import UIKit

class SelectedStadiumViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addFavoriteButton: UIButton! //tıklandığında fav işareti işaretlensin
    @IBOutlet weak var nameLabel: UILabel!
    var name=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text=name
        // Do any additional setup after loading the view.
    }
    @IBAction func imagesClicked(_ sender: Any) {
    }
    @IBAction func informationClicked(_ sender: Any) {
    }
    @IBAction func commentClicked(_ sender: Any) {
    }
    @IBAction func requestClicked(_ sender: Any) {
    }
    @IBAction func addFavoriteClicked(_ sender: Any) {
    }
    
    
}
