//
//  StadiumAccountViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 23.06.2021.
//

import UIKit
import Firebase
import SDWebImage
import grpc

class StadiumAccountViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var appointmentButton: UIButton!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var appointmentArray=[String]()
    var nameStadium=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadButton.setTitleColor(UIColor.white, for: .disabled)
        uploadButton.backgroundColor = .green
        uploadButton.layer.cornerRadius=20
        appointmentButton.setTitleColor(UIColor.white, for: .disabled)
        appointmentButton.backgroundColor = .green
        appointmentButton.layer.cornerRadius=20
        // Do any additional setup after loading the view.
        
        trashButton.titleLabel?.text=""
        profileImageView.isUserInteractionEnabled=true
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        profileImageView.addGestureRecognizer(gestureRecognizer)
        
        let docRef=firestoreDatabase.collection("Stadiums").document(currentUser!.uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                self.nameStadium=name
                self.nameLabel.text=name
            }
    }
        firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid).getDocument(source: .cache) { (snapshot, error) in
            if let document = snapshot {
                if let pp=document.get("imageUrl") {
                    self.profileImageView.isUserInteractionEnabled=false
                }else {
                    self.trashButton.isHidden=true
                }
            }
        }
        getPhoto()
        
    }
    @objc func choosePicture(){
        let picker=UIImagePickerController()
        picker.delegate=self
        picker.sourceType = .photoLibrary
      //  picker.sourceType = .camera daha sonra ekle
        self.present(picker, animated: true, completion: nil)
    }
    
    func getPhoto(){
        
        let imageRef=firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid)
               imageRef.getDocument(source: .cache) { (document, error) in
                   if let document = document {
                       if error == nil {
                           if document.get("imageUrl") != nil {
                               let imageUrl=document.get("imageUrl") as! String
                               self.profileImageView.sd_setImage(with: URL(string: imageUrl))
                           }
                       }
                   }
           }
    }
    
    func getAppointment(){
      //  self.appointmentButton.setTitle("Bekleyen \(self.appointmentArray.count) adet randevu.", for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.image=info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("Profile")
        if let data=profileImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid=currentUser!.uid
            
            let imageReference=mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metedata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl=url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreProfile=["imageUrl":imageUrl!,
                                                  "User":Auth.auth().currentUser!.email!,
                                                  "ID":Auth.auth().currentUser!.uid,
                                                  "StadiumName":self.nameLabel.text!,
                                               "Date":FieldValue.serverTimestamp()] as [String:Any]
                                self.firestoreDatabase.collection("ProfilePhoto").document(Auth.auth().currentUser!.uid).setData(firestoreProfile) { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    }
                                }
                            self.firestoreDatabase.collection("ProfilePhoto").whereField("User", isEqualTo: self.currentUser?.email).getDocuments { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents{
                                        let documentId=document.documentID
                                        self.firestoreDatabase.collection("ProfilePhoto").document(documentId).updateData(["imageUrl": imageUrl])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func imagesClicked(_ sender: Any) {
    }
    @IBAction func informationClicked(_ sender: Any) {
        
    }
    @IBAction func commentClicked(_ sender: Any) {
    }
    @IBAction func trashButtonClicked(_ sender: Any) {

        firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid).updateData(["imageUrl":FieldValue.delete(),]) {
            error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                self.makeAlert(titleInput: "Başarılı", messageInput: "Profil fotoğrafınız silindi.")
            }
        }
    }
    
    @IBAction func appointmentClicked(_ sender: Any) {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPendingAppointments" {
            let destinationVC=segue.destination as! PendingAppointmentsViewController
            destinationVC.stadiumName=nameStadium
        }
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
