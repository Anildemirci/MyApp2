//
//  UploadPhotosViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 6.07.2021.
//

import UIKit
import Firebase
import SDWebImage

class UploadPhotosViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statementText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var uuid=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled=true
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(choosePhoto))
        imageView.addGestureRecognizer(gestureRecognizer)
        uploadButton.isEnabled=false
        uploadButton.setTitleColor(UIColor.white, for: .disabled)
        uploadButton.backgroundColor = .blue
        uploadButton.layer.cornerRadius=20
        imageView.layer.borderWidth=1
        imageView.layer.borderColor=UIColor.black.cgColor
        statementText.layer.borderWidth=1
        statementText.layer.borderColor=UIColor.black.cgColor
        // Do any additional setup after loading the view.
        let gestureRecognizer2=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer2)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func choosePhoto(){
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image=info[.originalImage] as? UIImage
        uploadButton.isEnabled=true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("StadiumPhotos").child(currentUser!.uid)
        if let data=imageView.image?.jpegData(compressionQuality: 0.5) {
             uuid=UUID().uuidString
            
            let imageReference=mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metedata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl=url?.absoluteString
                            
                            var firestoreReference:DocumentReference?=nil
                            let firestorePhotos=["photoUrl":imageUrl!,
                                                 "ID":self.currentUser!.uid,
                                                 "User":self.currentUser!.email!,
                                                 "Date":FieldValue.serverTimestamp(),
                                                 "Statement":self.statementText.text!,
                                                 "StorageID":self.uuid] as [String:Any]
                                firestoreReference=self.firestoreDatabase.collection("StadiumPhotos").document(self.currentUser!.uid).collection("Photos").addDocument(data: firestorePhotos) { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    self.makeAlert(titleInput: "Başarılı", messageInput: "Fotoğraf yüklendi.")
                                }
                            }
                            
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
