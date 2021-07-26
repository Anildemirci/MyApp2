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
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var addedFavButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var name=""
    var favStadium=[String]()
    var ID=""
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.firestoreDatabase.collection("Users").whereField("User", isEqualTo: self.currentUser?.uid).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if let favArray=document.get("FavoriteStadiums") as? [String] {
                        if favArray.contains(self.name) {
                            self.addFavoriteButton.isHidden=true
                            self.addFavoriteButton.isEnabled=false
                        } else {
                            self.addedFavButton.isHidden=true
                            self.addedFavButton.isEnabled=false
                        }
                    }else {
                        self.addedFavButton.isHidden=true
                        self.addedFavButton.isEnabled=false
                    }
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
    @IBAction func addedFavClicked(_ sender: Any) {
        firestoreDatabase.collection("Users").document(currentUser!.uid).updateData(["FavoriteStadiums":FieldValue.arrayRemove([name])])
        self.makeAlert(titleInput: "Başarılı", messageInput: "Saha favorilerden çıkartıldı.")
    }
    
    @IBAction func addFavoriteClicked(_ sender: Any) {
        self.firestoreDatabase.collection("Users").whereField("User", isEqualTo: self.currentUser?.uid).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    let documentId=document.documentID
                    if var favArray=document.get("FavoriteStadiums") as? [String] {
                        if favArray.contains(self.name) {
                            print("saha ekli zaten.")
                        } else {
                            favArray.append(self.name)
                            let addFavStadium=["FavoriteStadiums":favArray] as [String:Any]
                            self.firestoreDatabase.collection("Users").document(documentId).setData(addFavStadium, merge: true) { (error) in
                                if error == nil {
                                    self.makeAlert(titleInput: "Success", messageInput: "Saha favorilere eklendi.")
                                }
                            }
                        }
                    }else {
                        let addFavStadium=["FavoriteStadiums":[self.name]] as [String:Any]
                        self.firestoreDatabase.collection("Users").document(documentId).setData(addFavStadium, merge: true)
                        self.makeAlert(titleInput: "Success", messageInput: "Saha favorilere eklendi.")
                    }
                }
            }
        }
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
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
