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
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var appointmentButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    var appointmentArray=[String]()
    var nameStadium=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //photosButton.setTitleColor(UIColor.white, for: .normal)
        //photosButton.backgroundColor = .systemGreen
        photosButton.layer.borderWidth=3
        photosButton.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        //infoButton.setTitleColor(UIColor.white, for: .normal)
        //infoButton.backgroundColor = .systemGreen
        infoButton.layer.borderWidth=3
        infoButton.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        //commentButton.setTitleColor(UIColor.white, for: .normal)
        //commentButton.backgroundColor = .systemGreen
        commentButton.layer.borderWidth=3
        commentButton.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        //uploadButton.setTitleColor(UIColor.white, for: .normal)
        //uploadButton.backgroundColor = .green
        uploadButton.layer.cornerRadius=30
        //appointmentButton.setTitleColor(UIColor.white, for: .normal)
        //appointmentButton.backgroundColor = .systemGreen
        appointmentButton.layer.cornerRadius=30
        profileImageView.layer.borderWidth=1
        profileImageView.layer.borderColor=UIColor.black.cgColor
        // Do any additional setup after loading the view.
        
        profileImageView.isUserInteractionEnabled=true
        navigationItem.title="Hesabım"
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.tintColor=UIColor.white
        navigationController?.navigationBar.backgroundColor=UIColor(named: "myGreen")
        
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        profileImageView.addGestureRecognizer(gestureRecognizer)
        
        let docRef=firestoreDatabase.collection("Stadiums").document(currentUser!.uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                self.nameStadium=name
            }
    }
        firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid).getDocument(source: .cache) { (snapshot, error) in
            if let document = snapshot {
                if let pp=document.get("imageUrl") {
                    self.profileImageView.isUserInteractionEnabled=false
                    self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.trashClicked))
                }else {
                    self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.choosePicture))
                }
            }
        }
        getPhoto()
        
    }
    @objc func trashClicked(){
        firestoreDatabase.collection("ProfilePhoto").document(currentUser!.uid).delete { error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                let storageRef=self.storage.reference()
                let uuid=self.currentUser!.uid
                let deleteRef=storageRef.child("Profile").child("\(uuid).jpg")
                deleteRef.delete { error in
                    if error != nil {
                        self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Fotoğraf silinemedi.")
                    } else {
                        self.makeAlert(titleInput: "Başarılı", messageInput: "Profil fotoğrafınız silindi.")
                    }
                }
            }
        }
    }
    
    @objc func choosePicture(){
        let picker=UIImagePickerController()
        picker.delegate=self
        let actionSheet=UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            } else {
                self.makeAlert(titleInput: "Hata", messageInput: "Kamera müsait değil.")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Galeri", style: .default, handler: { (action:UIAlertAction) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
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
                                                  "StadiumName":self.nameStadium,
                                               "Date":FieldValue.serverTimestamp()] as [String:Any]
                                self.firestoreDatabase.collection("ProfilePhoto").document(Auth.auth().currentUser!.uid).setData(firestoreProfile) { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPendingAppointments" {
            let destinationVC=segue.destination as! PendingAppointmentsViewController
            destinationVC.stadiumName=nameStadium
        }
        if segue.identifier == "toComments" {
            let destinationVC=segue.destination as! CommentsViewController
            destinationVC.name=nameStadium
        }
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
