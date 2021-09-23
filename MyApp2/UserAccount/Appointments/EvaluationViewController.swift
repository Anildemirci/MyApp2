//
//  EvaluationViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 25.08.2021.
//

import UIKit
import Firebase

class EvaluationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var stadiumName: UILabel!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scoringPicker: UIPickerView!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var documentID=""
    var chosenPoint=""
    var points=["","5-Çok iyi","4-İyi","3-Orta","2-Kötü","1-Çok kötü"]
    var fullName=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoringPicker.delegate=self
        scoringPicker.dataSource=self
        // Do any additional setup after loading the view.
        let docref=firestoreDatabase.collection("Users").document(currentUser!.uid)
        docref.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                let surname=document.get("Surname") as! String
                self.fullName=name+" "+surname
            }
        }
        
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).document(documentID).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        let fieldName=document.get("FieldName") as! String
                        self.fieldName.text=fieldName
                        let date=document.get("AppointmentDate") as! String
                        self.dateLabel.text=date
                        let hour=document.get("Hour") as! String
                        self.hourLabel.text=hour
                        let stadiumName=document.get("StadiumName") as! String
                        self.stadiumName.text=stadiumName
                        let status=document.get("Status") as! String
                        self.statusLabel.text=status
                        if self.statusLabel.text == "Onaylandı." {
                            self.scoringPicker.isHidden=false
                            self.commentText.isHidden=false
                            self.sendButton.isHidden=false
                            self.commentLabel.isHidden=false
                        }
                    }
                }
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }

@objc func hideKeyboard(){
    view.endEditing(true)
}
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return points.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return points[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenPoint=points[row]
    }
    @IBAction func sendClicked(_ sender: Any) {
        
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser?.email,
                           "StadiumName":stadiumName.text!,
                           "FieldName":fieldName.text!,
                           "Date":dateLabel.text!,
                           "Hour":hourLabel.text!,
                           "Status":statusLabel.text!,
                           "Comment":commentText.text!,
                           "Score":chosenPoint,
                           "FullName":fullName,
                           "CommentDate":FieldValue.serverTimestamp()] as [String:Any]
        if chosenPoint != "" && commentText.text != "" {
            firestoreDatabase.collection("Evaluation").document(stadiumName.text!).collection(stadiumName.text!).document(dateLabel.text!+"-"+hourLabel.text!).setData(firestoreUser) {
                error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toUserProfileFromComment", sender: nil)
                }
            }
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Lütfen yorum/puan boş bırakmayınız.")
        }
        
    }
    
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
