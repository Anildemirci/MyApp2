//
//  StadiumPhotosViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 6.07.2021.
//

import UIKit
import Firebase
import SDWebImage

class StadiumPhotosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var photoStatement=[String]()
    var imageUrl=[String]()
    var image=""
    var chosenPhoto=""
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    var userTypeArray=[String]()
    var stadiumTypeArray=[String]()
    var ID=""
    var delStorage=""
    var storageId=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
        navigationItem.title="Fotoğraflar"
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        firestoreDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if let userType=document.get("User") as? String{
                        self.userTypeArray.append(userType)
                        if self.userTypeArray.contains(self.currentUser!.uid) {
                            self.getDataFromUser()
                        }
                    }
                }
            }
        }
        firestoreDatabase.collection("Stadiums").addSnapshotListener { (snapshot, error) in
            if error==nil {
                for document in snapshot!.documents{
                    if let userType=document.get("User") as? String{
                        self.stadiumTypeArray.append(userType)
                        if self.stadiumTypeArray.contains(self.currentUser!.uid) {
                            self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.uploadClicked))
                            self.getDataFromStadium()
                        }
                    }
                }
            }
        }
        
    }
    
    func getDataFromStadium(){
        firestoreDatabase.collection("StadiumPhotos").document(currentUser!.uid).collection("Photos").order(by: "Date",descending: true).addSnapshotListener { (snapshot, error) in
                  if error != nil{
                      self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                  } else {
                      
                      self.photoStatement.removeAll(keepingCapacity: false)
                      self.imageUrl.removeAll(keepingCapacity: false)
                      
                          for document in snapshot!.documents{
                              if let storagee=document.get("StorageID") as? String {
                                  self.storageId.append(storagee)
                              }
                              if let photoComment=document.get("Statement") as? String {
                                  self.photoStatement.append(photoComment)
                                  
                              }
                              if let photoUrl=document.get("photoUrl") as? String {
                                  self.imageUrl.append(photoUrl)
                              }
                          }
                      self.tableView.reloadData()
                  }
              }
    }
    
    func getDataFromUser(){
        firestoreDatabase.collection("StadiumPhotos").document(ID).collection("Photos").addSnapshotListener { (snapshot, error) in
                  if error != nil{
                      self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                  } else {
                      
                      self.photoStatement.removeAll(keepingCapacity: false)
                      self.imageUrl.removeAll(keepingCapacity: false)
                      
                          for document in snapshot!.documents{
                              if let photoComment=document.get("Statement") as? String {
                                  self.photoStatement.append(photoComment)
                                  
                              }
                              if let photoUrl=document.get("photoUrl") as? String {
                                  self.imageUrl.append(photoUrl)
                              }
                          }
                      self.tableView.reloadData()
                  }
              }
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let firestoreDatabase=Firestore.firestore()
            delStorage=storageId[indexPath.row]
            firestoreDatabase.collection("Stadiums").addSnapshotListener { [self] (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents
                    {
                        if let userType=document.get("User") as? String{
                            stadiumTypeArray.append(userType)
                        }
                    }
                    if stadiumTypeArray.contains(currentUser!.uid) {
                        if editingStyle == UITableViewCell.EditingStyle.delete {
                            let delPhoto=imageUrl[indexPath.row]
                            firestoreDatabase.collection("StadiumPhotos").document(currentUser!.uid).collection("Photos").whereField("photoUrl", isEqualTo: delPhoto).getDocuments() { (query, error) in
                                if error == nil {
                                    for document in query!.documents{
                                        let delDocID=document.documentID
                                        firestoreDatabase.collection("StadiumPhotos").document(currentUser!.uid).collection("Photos").document(delDocID).delete(){ error in
                                            if error == nil {
                                                storage.reference().child("StadiumPhotos").child(currentUser!.uid).child("\(delStorage).jpg").delete { error in
                                                    if error != nil {
                                                        self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Bilinmeyen hata.")
                                                    } else {
                                                        self.makeAlert(titleInput: "Başarılı", messageInput: "Fotoğraf silindi.")
                                                    }
                                                }
                                            }else {
                                                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                            }
                                        }
                                    }
                                }
                                }
                        }
                    } else {
                        
                    }
            }
            }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if userTypeArray.contains(self.currentUser!.uid) {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrl.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "stadiumPhotosCell", for: indexPath) as! StadiumPhotosViewCell
        cell.commentLabel.text=photoStatement[indexPath.row]
        cell.stadiumPhotosView.sd_setImage(with: URL(string: imageUrl[indexPath.row]))
        return cell
    }
    
    @objc func uploadClicked(){
        performSegue(withIdentifier: "toUploadPhoto", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto" {
            let destinationVC=segue.destination as! ThePhotoViewController
            destinationVC.selectedPhoto=chosenPhoto
            destinationVC.image=image
            destinationVC.imageArray=imageUrl
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenPhoto=imageUrl[indexPath.row]
        performSegue(withIdentifier: "toPhoto", sender: nil)
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
