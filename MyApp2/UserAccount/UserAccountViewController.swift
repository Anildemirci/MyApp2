//
//  UserAccountViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 23.06.2021.
//

import UIKit
import Firebase
import SDWebImage
import grpc

class UserAccountViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var trashButton: UIButton!
    
    var firedatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var userName=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  profileImageView.contentMode=UIView.ContentMode.scaleAspectFill
      //  profileImageView.layer.masksToBounds=false
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = (profileImageView.frame.size.width)/2
        profileImageView.clipsToBounds = true
        
        trashButton.titleLabel?.text=""
        profileImageView.isUserInteractionEnabled=true
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        profileImageView.addGestureRecognizer(gestureRecognizer)
        
        let docref=firedatabase.collection("Users").document(currentUser!.uid)
        docref.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                self.userName=name
            }
        }
        // Do any additional setup after loading the view.
        firedatabase.collection("UserProfilePhoto").document(currentUser!.uid).getDocument(source: .cache) { (snapshot, error) in
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
        
        let imageRef=firedatabase.collection("UserProfilePhoto").document(currentUser!.uid)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.image=info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("UserProfile")
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
                                                  "UserName":self.userName,
                                               "Date":FieldValue.serverTimestamp()] as [String:Any]
                                self.firedatabase.collection("UserProfilePhoto").document(Auth.auth().currentUser!.uid).setData(firestoreProfile) { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    }
                                }
                            self.firedatabase.collection("UserProfilePhoto").whereField("User", isEqualTo: self.currentUser?.email).getDocuments { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents{
                                        let documentId=document.documentID
                                        self.firedatabase.collection("UserProfilePhoto").document(documentId).updateData(["imageUrl": imageUrl])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func trashClicked(_ sender: Any) {
        firedatabase.collection("UserProfilePhoto").document(currentUser!.uid).updateData(["imageUrl":FieldValue.delete(),]) {
            error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                self.makeAlert(titleInput: "Başarılı", messageInput: "Profil fotoğrafınız silindi.")
            }
        }
    }
    @IBAction func appointmentsClicked(_ sender: Any) {
    }
    @IBAction func informationClicked(_ sender: Any) {
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
