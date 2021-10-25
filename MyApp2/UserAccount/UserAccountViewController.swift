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

@available(iOS 13.0, *)
class UserAccountViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var myTeamButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var appointmentsButton: UIButton!
    
    var firedatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var storage=Storage.storage()
    var userName=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.masksToBounds=false
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth=2.0
        profileImageView.layer.borderColor=UIColor.black.cgColor
        //profileImageView.image=UIImage(systemName: "person.circle")
        //trashButton.setImage(UIImage(systemName: "pencil"), for: UIControl.State.normal)
        myTeamButton.layer.borderWidth = 3
        myTeamButton.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        //myTeamButton.backgroundColor=UIColor.systemGreen
        infoButton.layer.borderWidth = 3
        infoButton.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        //infoButton.backgroundColor=UIColor.systemGreen
        appointmentsButton.layer.borderWidth = 3
        appointmentsButton.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        //appointmentsButton.backgroundColor=UIColor.systemRed
       /* let navBar=UINavigationBar(frame: CGRect(x: 0, y: 0, width: Int(view.frame.size.width), height: 75))
        navBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar.barTintColor=UIColor(named: "myGreen")
        view.addSubview(navBar)
        let navItem=UINavigationItem(title: "Hesabım")
        //let doneItem=UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(backButton))
        //navItem.leftBarButtonItem=doneItem
        navBar.setItems([navItem], animated: false) */
        
        
        navigationItem.title="Hesabım"
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.tintColor=UIColor.white
        navigationController?.navigationBar.backgroundColor=UIColor(named: "myGreen")
        
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
                    self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.trashClicked))
                }else {
                    self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.choosePicture))
                }
            }
        }
        getPhoto()
        
    }
    @objc func trashClicked(){
        firedatabase.collection("UserProfilePhoto").document(currentUser!.uid).delete { error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                let storageRef=self.storage.reference()
                let uuid=self.currentUser!.uid
                let deleteRef=storageRef.child("UserProfile").child("\(uuid).jpg")
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
                        }
                    }
                }
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
