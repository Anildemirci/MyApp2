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
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var photoStatement=[String]()
    var imageUrl=[String]()
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var userTypeArray=[String]()
    var stadiumTypeArray=[String]()
    var ID=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
        
        firestoreDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if let userType=document.get("User") as? String{
                        self.userTypeArray.append(userType)
                        if self.userTypeArray.contains(self.currentUser!.uid) {
                            self.uploadButton.isHidden=true
                            self.backButton.isHidden=true
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
                            self.getDataFromStadium()
                        }
                    }
                }
            }
        }
        
    }
    
    func getDataFromStadium(){
        firestoreDatabase.collection("StadiumPhotos").document(currentUser!.uid).collection("Photos").addSnapshotListener { (snapshot, error) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrl.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "stadiumPhotosCell", for: indexPath) as! StadiumPhotosViewCell
        cell.commentLabel.text=photoStatement[indexPath.row]
        cell.stadiumPhotosView.sd_setImage(with: URL(string: imageUrl[indexPath.row]))
        return cell
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        performSegue(withIdentifier: "toUploadPhoto", sender: nil)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        
        firestoreDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
                   if error == nil {
                       for document in snapshot!.documents{
                           if let userType=document.get("User") as? String{
                               self.userTypeArray.append(userType)
                               if self.userTypeArray.contains(self.currentUser!.uid) {
                                   self.performSegue(withIdentifier: "backUser", sender: nil)
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
                                   self.performSegue(withIdentifier: "backStadium", sender: nil)
                               }
                           }
                       }
                   }
               }
    }
    
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
