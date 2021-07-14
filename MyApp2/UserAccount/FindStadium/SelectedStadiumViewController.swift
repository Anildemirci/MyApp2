//
//  SelectedStadiumViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 4.07.2021.
//

import UIKit
import Firebase
import SDWebImage

class SelectedStadiumViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addFavoriteButton: UIButton! //tıklandığında fav işareti işaretlensin
    @IBOutlet weak var nameLabel: UILabel!
    var name=""
    var ID=""
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFavoriteButton.titleLabel?.text=""
        nameLabel.text=name
        
        let imageRef=firestoreDatabase.collection("ProfilePhoto").whereField("StadiumName", isEqualTo: name).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    if document.get("imageUrl") != nil {
                        let imageUrl=document.get("imageUrl") as! String
                        self.imageView.sd_setImage(with: URL(string: imageUrl))
                    }
                }
            }
        }
        firestoreDatabase.collection("Stadiums").whereField("Name", isEqualTo: name).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let stadiumId=document.get("User") as! String
                    self.ID=stadiumId
                }
            }
        }
        
    }
    @IBAction func imagesClicked(_ sender: Any) {
        performSegue(withIdentifier: "toStadiumPhotosFromUser", sender: nil)
    }
    @IBAction func informationClicked(_ sender: Any) {
    }
    @IBAction func commentClicked(_ sender: Any) {
    }
    @IBAction func requestClicked(_ sender: Any) {
    }
    @IBAction func addFavoriteClicked(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStadiumPhotosFromUser" {
            let destinationVC=segue.destination as! StadiumPhotosViewController
            destinationVC.ID=ID
        }
        if segue.identifier == "toInformationFromUser" {
            let destinationVC2=segue.destination as! StadiumInformationsViewController
            destinationVC2.equalName=name
        }
    }
}
